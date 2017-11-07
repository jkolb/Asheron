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

import Lilliput

public final class PortalParser {
    public func parseColorTable(handle: ColorTableHandle, buffer: ByteBuffer) -> ColorTable {
        let bytes = OrderedByteBuffer<LittleEndian>(buffer: buffer)
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
        let bytes = OrderedByteBuffer<LittleEndian>(buffer: buffer)
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        bytes.skip(5)
        let count = bytes.getUInt32()
        precondition(count == 1 || count == 2)
        let portalHandle: TextureDataHandle
        let highresHandle: TextureDataHandle?
        
        if count == 1 {
            let portalRawHandle = bytes.getUInt32()
            
            highresHandle = nil
            portalHandle = TextureDataHandle(rawValue: portalRawHandle)!
        }
        else {
            let highresRawHandle = bytes.getUInt32()
            let portalRawHandle = bytes.getUInt32()
            
            highresHandle = TextureDataHandle(rawValue: highresRawHandle)!
            portalHandle = TextureDataHandle(rawValue: portalRawHandle)!
        }
        
        precondition(!bytes.hasRemaining)
        
        return TextureList(handle: handle, portalHandle: portalHandle, highresHandle: highresHandle)
    }
    
    public func parseTextureData(handle: TextureDataHandle, buffer: ByteBuffer) -> TextureData {
        let bytes = OrderedByteBuffer<LittleEndian>(buffer: buffer)
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
        bytes.copy(to: data)
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
        let bytes = OrderedByteBuffer<LittleEndian>(buffer: buffer)
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
        
        let unknown8 = bytes.getUInt32()
        precondition(unknown8 == 543)
        
        let unknown9 = bytes.getUInt32()
        precondition(unknown9 == 0xA0000000)
        
        let unknown10 = bytes.getFloat32()
        //precondition(unknown10 == 1.825)
        
        let unknown11 = bytes.getFloat32()
        precondition(unknown11 == 0.0)
        
        let unknown12 = bytes.getFloat32()
        precondition(unknown12 == 2.71875)
        
        let weathersCount = Int(bytes.getUInt32())
        precondition(weathersCount == 20)
        var weathers = [WorldRegionWeather]()
        weathers.reserveCapacity(weathersCount)
        
        for _ in 0..<weathersCount {
            let weather = parseWorldRegionWeather(bytes: bytes)
            weathers.append(weather)
        }
        
        let unknownAsCount = Int(bytes.getUInt32())
        precondition(unknownAsCount == 0x25)
        var unknownAs = [WorldRegionUnknownA]()
        unknownAs.reserveCapacity(unknownAsCount)
        
        for _ in 0..<unknownAsCount {
            let unknownA = parseWorldRegionUnknownA(bytes: bytes)
            unknownAs.append(unknownA)
        }
        
        let sceneryListsCount = Int(bytes.getUInt32())
        var sceneryLists = [WorldRegionSceneryList]()
        sceneryLists.reserveCapacity(sceneryListsCount)
        
        for _ in 0..<sceneryListsCount {
            let sceneryList = parseWorldRegionSceneryList(bytes: bytes)
            sceneryLists.append(sceneryList)
        }
        
        let biomesCount = Int(bytes.getUInt32())
        var biomes = [WorldRegionBiome]()
        biomes.reserveCapacity(biomesCount)
        
        for _ in 0..<biomesCount {
            let biome = parseWorldRegionBiome(bytes: bytes)
            biomes.append(biome)
        }
        
        let unknown13 = bytes.getUInt32()
        precondition(unknown13 == 0)
        
        let unknown14 = bytes.getUInt32()
        precondition(unknown14 == 1024)
        
        let cornerBlendTextures = parseWorldRegionBlendTextures(bytes: bytes)
        let straightBlendTextures = parseWorldRegionBlendTextures(bytes: bytes)
        let roadBlendTextures = parseWorldRegionBlendTextures(bytes: bytes)
        
        let biomeTexturesCount = Int(bytes.getUInt32())
        var biomeTextures = [WorldRegionBiomeTexture]()
        biomeTextures.reserveCapacity(biomeTexturesCount)
        
        for _ in 0..<biomeTexturesCount {
            let biomeTexture = parseWorldRegionBiomeTexture(bytes: bytes)
            biomeTextures.append(biomeTexture)
        }
        
        let unknown15 = bytes.getUInt32()
        precondition(unknown15 == 1)
        
        let uiMapTextureDataHandle = TextureDataHandle(rawValue: bytes.getUInt32())!
        let rawMapTextureDataHandle = TextureDataHandle(rawValue: bytes.getUInt32())!
        
        let unknown16 = bytes.getUInt32()
        let unknown17 = bytes.getUInt32()
        let unknown18 = bytes.getUInt32()
        
        precondition(!bytes.hasRemaining)
        
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
            months: months,
            unknown8: unknown8,
            unknown9: unknown9,
            unknown10: unknown10,
            unknown11: unknown11,
            unknown12: unknown12,
            weathers: weathers,
            unknownAs: unknownAs,
            sceneryLists: sceneryLists,
            biomes: biomes,
            unknown13: unknown13,
            unknown14: unknown14,
            cornerBlendTextures: cornerBlendTextures,
            straightBlendTextures: straightBlendTextures,
            roadBlendTextures: roadBlendTextures,
            biomeTextures: biomeTextures,
            unknown15: unknown15,
            uiMapTextureDataHandle: uiMapTextureDataHandle,
            rawMapTextureDataHandle: rawMapTextureDataHandle,
            unknown16: unknown16,
            unknown17: unknown17,
            unknown18: unknown18
        )
    }
    
    private func parseWorldRegionHour(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionHour {
        let startTime = bytes.getFloat32()
        let isNight = bytes.getBool()
        let name = bytes.getString()
        
        return WorldRegionHour(startTime: startTime, isNight: isNight, name: name)
    }
    
    private func parseWorldRegionMonth(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionMonth {
        let startDay = bytes.getUInt32()
        let name = bytes.getString()
        
        return WorldRegionMonth(startDay: Int(startDay), name: name)
    }
    
    private func parseWorldRegionWeather(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionWeather {
        let percentage = bytes.getFloat32()
        let name = bytes.getString()
        let objectsCount = Int(bytes.getUInt32())
        var objects = [WorldRegionWeatherObject]()
        objects.reserveCapacity(objectsCount)
        
        for _ in 0..<objectsCount {
            let object = parseWorldRegionWeatherObject(bytes: bytes)
            objects.append(object)
        }
        
        let unknownsCount = Int(bytes.getUInt32())
        var unknowns = [WorldRegionWeatherUnknown]()
        unknowns.reserveCapacity(unknownsCount)
        
        for _ in 0..<unknownsCount {
            let unknown = parseWorldRegionWeatherUnknown(bytes: bytes)
            unknowns.append(unknown)
        }
        
        return WorldRegionWeather(percentage: percentage, name: name, objects: objects, unknowns: unknowns)
    }
    
    private func parseWorldRegionWeatherObject(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionWeatherObject {
        let unknown1 = bytes.getFloat32(count: 6)
        let objectHandle = bytes.getUInt32()
        let unknownHandle = bytes.getUInt32()
        let unknown2 = bytes.getUInt32()
        
        return WorldRegionWeatherObject(unknown1: unknown1, objectHandle: objectHandle, unknownHandle: unknownHandle, unknown2: unknown2)
    }
    
    private func parseWorldRegionWeatherUnknown(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionWeatherUnknown {
        let unknown1 = bytes.getFloat32(count: 4)
        let color1 = PixelARGB8888(bits: bytes.getUInt32())
        let unknown2 = bytes.getFloat32()
        let color2 = PixelARGB8888(bits: bytes.getUInt32())
        let unknown3 = bytes.getFloat32(count: 2)
        let color3 = PixelARGB8888(bits: bytes.getUInt32())
        let unknown4 = bytes.getUInt32()
        let unknown2sCount = Int(bytes.getUInt32())
        var unknowns2 = [WorldRegionWeatherUnknown2]()
        unknowns2.reserveCapacity(unknown2sCount)
        
        for _ in 0..<unknown2sCount {
            let unknown2 = parseWorldRegionWeatherUnknown2(bytes: bytes)
            unknowns2.append(unknown2)
        }
        
        return WorldRegionWeatherUnknown(unknown1: unknown1, color1: color1, unknown2: unknown2, color2: color2, unknown3: unknown3, color3: color3, unknown4: unknown4, unknowns2: unknowns2)
    }
    
    private func parseWorldRegionWeatherUnknown2(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionWeatherUnknown2 {
        let unknown1 = bytes.getUInt32()
        let unknown2 = bytes.getFloat32(count: 5)
        
        return WorldRegionWeatherUnknown2(unknown1: unknown1, unknown2: unknown2)
    }
    
    private func parseWorldRegionUnknownA(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionUnknownA {
        let unknown1 = bytes.getUInt32()
        let count = Int(bytes.getUInt32())
        var unknown2 = [WorldRegionUnknownB]()
        unknown2.reserveCapacity(count)
        
        for _ in 0..<count {
            let unknownB = parseWorldRegionUnknownB(bytes: bytes)
            unknown2.append(unknownB)
        }
        
        return WorldRegionUnknownA(unknown1: unknown1, unknown2: unknown2)
    }
    
    private func parseWorldRegionUnknownB(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionUnknownB {
        let unknown1 = bytes.getUInt32()
        let unknown2 = bytes.getFloat32(count: 4)
        
        return WorldRegionUnknownB(unknown1: unknown1, unknown2: unknown2)
    }
    
    private func parseWorldRegionSceneryList(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionSceneryList {
        let index = bytes.getUInt32()
        let sceneryHandlesCount = Int(bytes.getUInt32())
        var sceneryHandles = [WorldSceneryHandle]()
        sceneryHandles.reserveCapacity(sceneryHandlesCount)
        
        for _ in 0..<sceneryHandlesCount {
            let rawHandle = bytes.getUInt32()
            let sceneryHandle = WorldSceneryHandle(rawValue: rawHandle)!
            sceneryHandles.append(sceneryHandle)
        }
        
        return WorldRegionSceneryList(index: index, sceneryHandles: sceneryHandles)
    }
    
    private func parseWorldRegionBiome(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionBiome {
        let name = bytes.getString()
        let color = PixelARGB8888(bits: bytes.getUInt32())
        let sceneryListIndexesCount = Int(bytes.getUInt32())
        var sceneryListIndexes = [Int]()
        sceneryListIndexes.reserveCapacity(sceneryListIndexesCount)
        
        for _ in 0..<sceneryListIndexesCount {
            let sceneryListIndex = Int(bytes.getUInt32())
            sceneryListIndexes.append(sceneryListIndex)
        }
        
        return WorldRegionBiome(name: name, color: color, sceneryListIndexes: sceneryListIndexes)
    }
    
    private func parseWorldRegionBlendTexture(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionBlendTexture {
        let type = WorldRegionBlendTextureType(rawValue: bytes.getUInt32())!
        let textureListHandle = TextureListHandle(rawValue: bytes.getUInt32())!
        
        return WorldRegionBlendTexture(type: type, textureListHandle: textureListHandle)
    }
    
    private func parseWorldRegionBlendTextures(bytes: OrderedByteBuffer<LittleEndian>) -> [WorldRegionBlendTexture] {
        let count = Int(bytes.getUInt32())
        var blendTextures = [WorldRegionBlendTexture]()
        blendTextures.reserveCapacity(count)
        
        for _ in 0..<count {
            let blendTexture = parseWorldRegionBlendTexture(bytes: bytes)
            blendTextures.append(blendTexture)
        }
        
        return blendTextures
    }
    
    private func parseWorldRegionBiomeTexture(bytes: OrderedByteBuffer<LittleEndian>) -> WorldRegionBiomeTexture {
        let index = bytes.getUInt32()
        let textureListHandle1 = TextureListHandle(rawValue: bytes.getUInt32())!
        let unknown1 = bytes.getUInt32()
        let unknown2 = bytes.getUInt32()
        let unknown3 = bytes.getUInt32()
        let unknown4 = bytes.getUInt32()
        let unknown5 = bytes.getUInt32()
        let unknown6 = bytes.getUInt32()
        let unknown7 = bytes.getUInt32()
        let unknown8 = bytes.getUInt32()
        let textureListHandle2 = TextureListHandle(rawValue: bytes.getUInt32())!
        
        return WorldRegionBiomeTexture(index: index, textureListHandle1: textureListHandle1, unknown1: unknown1, unknown2: unknown2, unknown3: unknown3, unknown4: unknown4, unknown5: unknown5, unknown6: unknown6, unknown7: unknown7, unknown8: unknown8, textureListHandle2: textureListHandle2)
    }
    
    public func parseMaterial(handle: MaterialHandle, buffer: ByteBuffer) -> Material {
        let bytes = OrderedByteBuffer<LittleEndian>(buffer: buffer)
        // Doesn't contain its own handle unlike others
        //let rawHandle = bytes.getUInt32()
        //precondition(handle.rawValue == rawHandle)
        let material = Material(handle: handle)
        material.flags = Material.Flags(rawValue: bytes.getUInt32())
        
        if material.flags.contains(.color) {
            material.value = .color(PixelARGB8888(bits: bytes.getUInt32()))
        }
        else if material.flags.contains(.texture) || material.flags.contains(.clipmap) {
            let textureListHandle = TextureListHandle(rawValue: bytes.getUInt32())!
            let colorTableHandle = ColorTableHandle(rawValue: bytes.getUInt32())
            material.value = .texture(textureListHandle, colorTableHandle)
        }
        else {
            fatalError("Unknown flags: \(material.flags)")
        }
        
        material.translucency = bytes.getFloat32()
        material.luminosity = bytes.getFloat32()
        material.diffuse = bytes.getFloat32()
        
        precondition(!bytes.hasRemaining)
        
        return material
    }
}
