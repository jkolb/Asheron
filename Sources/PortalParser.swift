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
    public func parseColorTable(handle: PortalHandle<ColorTable>, buffer: ByteBuffer) -> ColorTable {
        let bytes = ByteStream(buffer: buffer)
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        let count = bytes.getUInt32()
        var colors = [ARGB8888]()
        colors.reserveCapacity(numericCast(count))
        
        for _ in 0..<count {
            let color = ARGB8888(bits: bytes.getUInt32())
            
            colors.append(color)
        }
        
        precondition(!bytes.hasRemaining)
        
        return ColorTable(handle: handle, colors: colors)
    }
    
    public func parseTextureList(handle: PortalHandle<TextureList>, buffer: ByteBuffer) -> TextureList {
        let bytes = ByteStream(buffer: buffer)
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        bytes.skip(5)
        let count = bytes.getUInt32()
        precondition(count == 1 || count == 2)
        let lowHandle: PortalHandle<TextureData>
        let highHandle: PortalHandle<TextureData>?
        
        if count == 1 {
            let lowRawHandle = bytes.getUInt32()
            
            highHandle = nil
            lowHandle = PortalHandle<TextureData>(rawValue: lowRawHandle)!
        }
        else {
            let highRawHandle = bytes.getUInt32()
            let lowRawHandle = bytes.getUInt32()
            
            highHandle = PortalHandle<TextureData>(rawValue: highRawHandle)!
            lowHandle = PortalHandle<TextureData>(rawValue: lowRawHandle)!
        }
        
        precondition(!bytes.hasRemaining)
        
        return TextureList(handle: handle, lowHandle: lowHandle, highHandle: highHandle)
    }

    public func parseTextureData(handle: PortalHandle<TextureData>, buffer: ByteBuffer) -> TextureData {
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
            
            guard let colorTableHandle = PortalHandle<ColorTable>(rawValue: rawColorTableHandle) else {
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
}
