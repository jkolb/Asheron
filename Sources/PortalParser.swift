/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Justin Kolb
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

public final class PortalParser {
    public func parseColorTable(handle: ColorTableHandle, buffer: ByteBuffer) -> ColorTable {
        let bytes = ByteStream(buffer: buffer)
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        let count = bytes.getUInt32()
        var colors = [PixelARGB8888]()
        colors.reserveCapacity(numericCast(count))
        
        for _ in 0..<count {
            let color = PixelARGB8888(bits: bytes.getUInt32())
            
            colors.append(color)
        }
        
        precondition(!bytes.hasRemaining)
        
        return ColorTable(handle: handle, colors: colors)
    }
    
    public func parseTextureList(handle: TextureListHandle, buffer: ByteBuffer) -> TextureList {
        let bytes = ByteStream(buffer: buffer)
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        bytes.skip(5)
        let count = bytes.getUInt32()
        precondition(count == 1 || count == 2)
        let lowHandle: TextureDataHandle
        let highHandle: TextureDataHandle?
        
        if count == 1 {
            let lowRawHandle = bytes.getUInt32()
            
            highHandle = nil
            lowHandle = TextureDataHandle(rawValue: lowRawHandle)!
        }
        else {
            let highRawHandle = bytes.getUInt32()
            let lowRawHandle = bytes.getUInt32()
            
            highHandle = TextureDataHandle(rawValue: highRawHandle)!
            lowHandle = TextureDataHandle(rawValue: lowRawHandle)!
        }
        
        precondition(!bytes.hasRemaining)
        
        return TextureList(handle: handle, lowHandle: lowHandle, highHandle: highHandle)
    }

    public func parseTextureData(handle: TextureDataHandle, buffer: ByteBuffer) -> TextureData {
        let bytes = ByteStream(buffer: buffer)
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        bytes.skip(MemoryLayout<UInt32>.size)
        let width = bytes.getUInt32()
        let height = bytes.getUInt32()
        let rawD3DFormat = bytes.getUInt32()
        guard let d3dFormat = D3DFormat(rawValue: rawD3DFormat) else {
            fatalError("Unexpected D3DFMT: \(hex(rawD3DFormat))")
        }
        let data = ByteBuffer(count: numericCast(bytes.getUInt32()))
        bytes.copyBytes(to: data)
        let format: TextureFormat
        
        if d3dFormat == .D3DFMT_INDEX16 || d3dFormat == .D3DFMT_P8 {
            let rawColorTableHandle = bytes.getUInt32()
            
            guard let colorTableHandle = ColorTableHandle(rawValue: rawColorTableHandle) else {
                fatalError("Invalid color table handle: \(hex(rawColorTableHandle))")
            }
            
            if d3dFormat == .D3DFMT_INDEX16 {
                format = .p16(colorTableHandle)
            }
            else {
                format = .p8(colorTableHandle)
            }
        }
        else {
            switch d3dFormat {
            case .D3DFMT_R8G8B8:
                format = .rgb888
                
            case .D3DFMT_A8R8G8B8:
                format = .argb8888
                
            case .D3DFMT_R5G6B5:
                format = .rgb565
                
            case .D3DFMT_A4R4G4B4:
                format = .argb4444
                
            case .D3DFMT_A8:
                format = .a8
                
            case .D3DFMT_DXT1:
                format = .dxt1
                
            case .D3DFMT_DXT3:
                format = .dxt3
                
            case .D3DFMT_DXT5:
                format = .dxt5
                
            case .CUSTOM_B8R8G8:
                format = .bgr888
                
            case .CUSTOM_I8:
                format = .i8
                
            case .CUSTOM_JFIF:
                format = .jfif
                
            case .D3DFMT_P8:
                fatalError("Unpossible")
                
            case .D3DFMT_INDEX16:
                fatalError("Unpossible")
            }
        }
        
        precondition(!bytes.hasRemaining)
        
        return TextureData(handle: handle, width: width, height: height, format: format, data: data)
    }

    public func parseWorldRegion(handle: WorldRegionHandle, buffer: ByteBuffer) -> WorldRegion {
        let bytes = ByteStream(buffer: buffer)
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)

        let number = bytes.getUInt32()
        precondition(number == 1)

        let version = bytes.getUInt32()
        precondition(version == 3)

        let name = bytes.getString()
        precondition(name == "Dereth")

        let cellRowCount = bytes.getUInt32()
        precondition(cellRowCount == 255)

        let cellColCount = bytes.getUInt32()
        precondition(cellColCount == 255)

        let cellGridSize = bytes.getFloat32()
        precondition(cellGridSize == 24.0)

        let heightsPerCell = bytes.getUInt32()
        precondition(heightsPerCell == 8)

        let overlapPerCell = bytes.getUInt32()
        precondition(overlapPerCell == 1)

        let unknown1 = bytes.getFloat32()
        precondition(unknown1 == 200.0)

        let unknown2 = bytes.getFloat32()
        precondition(unknown2 == 1000.0)

        let unknown3 = bytes.getFloat32()
        precondition(unknown3 == 5.0)

        let landHeights = bytes.getFloat32(count: 256)
        precondition(landHeights.count == 256)

        let unknown4 = bytes.getUInt32()
        precondition(unknown4 == 0)

        let unknown5 = bytes.getFloat32()
        precondition(unknown5 == 5.37890625)

        let unknown6 = bytes.getUInt32()
        precondition(unknown6 == 10)

        let unknown7 = bytes.getFloat32()
        precondition(unknown7 == 7620.0)

        let daysPerYear = bytes.getUInt32()
        precondition(daysPerYear == 360)

        let yearUnitName = bytes.getString()
        precondition(yearUnitName == "P.Y.")

        let hoursCount = Int(bytes.getUInt32())
        var hours = [WorldRegionHour]()
        hours.reserveCapacity(hoursCount)

        for _ in 0..<hoursCount {
            let hour = parseWorldRegionHour(bytes: bytes)
            hours.append(hour)
        }

        let weekdaysCount = Int(bytes.getUInt32())
        var weekdays = [String]()
        weekdays.reserveCapacity(weekdaysCount)

        for _ in 0..<weekdaysCount {
            let weekday = bytes.getString()
            weekdays.append(weekday)
        }

        let monthsCount = Int(bytes.getUInt32())
        var months = [WorldRegionMonth]()
        months.reserveCapacity(monthsCount)

        for _ in 0..<monthsCount {
            let month = parseWorldRegionMonth(bytes: bytes)
            months.append(month)
        }

        return WorldRegion(
            handle: handle,
            number: number,
            version: version,
            name: name,
            cellRowCount: cellRowCount,
            cellColCount: cellColCount,
            cellGridSize: cellGridSize,
            heightsPerCell: heightsPerCell,
            overlapPerCell: overlapPerCell,
            unknown1: unknown1,
            unknown2: unknown2,
            unknown3: unknown3,
            landHeights: landHeights,
            unknown4: unknown4,
            unknown5: unknown5,
            unknown6: unknown6,
            unknown7: unknown7,
            daysPerYear: daysPerYear,
            yearUnitName: yearUnitName,
            hours: hours,
            weekdays: weekdays,
            months: months
        )
    }

    private func parseWorldRegionHour(bytes: ByteStream) -> WorldRegionHour {
        let startTime = bytes.getFloat32()
        let isNight = bytes.getBool()
        let name = bytes.getString()

        return WorldRegionHour(startTime: startTime, isNight: isNight, name: name)
    }

    private func parseWorldRegionMonth(bytes: ByteStream) -> WorldRegionMonth {
        let startDay = bytes.getUInt32()
        let name = bytes.getString()

        return WorldRegionMonth(startDay: Int(startDay), name: name)
    }
}
