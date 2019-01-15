/*
 The MIT License (MIT)
 
 Copyright (c) 2018 Justin Kolb
 
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

public final class ImgTexInputStream : DatInputStream {
    public enum Format : UInt32 {
        /* DirectX standard formats */
        case D3DFMT_R8G8B8   = 20         // RGB888
        case D3DFMT_A8R8G8B8 = 21         // ARGB8888
        case D3DFMT_R5G6B5   = 23         // RGB565
        case D3DFMT_A4R4G4B4 = 26         // ARGB4444
        case D3DFMT_A8       = 28         // 8-bit alpha only
        case D3DFMT_P8       = 41         // 8-bit index
        case D3DFMT_DXT1     = 0x31545844 // MAKEFOURCC('D', 'X', 'T', '1')
        case D3DFMT_DXT3     = 0x33545844 // MAKEFOURCC('D', 'X', 'T', '3')
        case D3DFMT_DXT5     = 0x35545844 // MAKEFOURCC('D', 'X', 'T', '5')
        case D3DFMT_INDEX16  = 101        // 16-bit index
        /* Custom formats */
        case CUSTOM_B8R8G8   = 0xF3       // BGR888 : PFID_CUSTOM_LSCAPE_R8G8B8
        case CUSTOM_I8       = 0xF4       // Intensity (I, I, I, I) : PFID_CUSTOM_LSCAPE_ALPHA
        case CUSTOM_JFIF     = 0x01F4     // JFIF (https://en.wikipedia.org/wiki/JPEG_File_Interchange_Format) : PFID_CUSTOM_RAW_JPEG
    }
    
    public func readImgTex(portalId: PortalId<ImgTex>) throws -> ImgTex {
        let streamID = try readPortalId(type: ImgTex.self)
        precondition(streamID == portalId)
        let category = ImgTex.Category(rawValue: try readUInt32())!
        let width = try readCount()
        let height = try readCount()
        let format = Format(rawValue: try readUInt32())!
        let count = try readCount()
        let imgTexFormat: ImgTex.Format
        
        switch format {
        case .D3DFMT_R8G8B8:
            let Colors = try readColors(width: width, height: height, count: count, reader: readColorRGB888)
            imgTexFormat = .rgb888(Colors)
            
        case .D3DFMT_A8R8G8B8:
            let Colors = try readColors(width: width, height: height, count: count, reader: readColorARGB8888)
            imgTexFormat = .argb8888(Colors)
            
        case .D3DFMT_R5G6B5:
            let Colors = try readColors(width: width, height: height, count: count, reader: readColorRGB565)
            imgTexFormat = .rgb565(Colors)
            
        case .D3DFMT_A4R4G4B4:
            let Colors = try readColors(width: width, height: height, count: count, reader: readColorARGB4444)
            imgTexFormat = .argb4444(Colors)
            
        case .D3DFMT_A8:
            let Colors = try readColors(width: width, height: height, count: count, reader: readColorA8)
            imgTexFormat = .a8(Colors)
            
        case .D3DFMT_P8:
            let indices = try readIndices(width: width, height: height, count: count, reader: readUInt8)
            let paletteId = try readPortalId(type: Palette.self)
            imgTexFormat = .p8(paletteId, indices)
            
        case .D3DFMT_DXT1:
            let blocks = try readDXTBlocks(width: width, height: height, count: count, reader: readDXT1Block)
            imgTexFormat = .dxt1(blocks)
            
        case .D3DFMT_DXT3:
            let blocks = try readDXTBlocks(width: width, height: height, count: count, reader: readDXT3Block)
            imgTexFormat = .dxt3(blocks)
            
        case .D3DFMT_DXT5:
            let blocks = try readDXTBlocks(width: width, height: height, count: count, reader: readDXT5Block)
            imgTexFormat = .dxt5(blocks)
            
        case .D3DFMT_INDEX16:
            let indices = try readIndices(width: width, height: height, count: count, reader: readUInt16)
            let paletteId = try readPortalId(type: Palette.self)
            imgTexFormat = .p16(paletteId, indices)
            
        case .CUSTOM_B8R8G8:
            let Colors = try readColors(width: width, height: height, count: count, reader: readColorBGR888)
            imgTexFormat = .bgr888(Colors)
            
        case .CUSTOM_I8:
            let Colors = try readColors(width: width, height: height, count: count, reader: readColorI8)
            imgTexFormat = .i8(Colors)
            
        case .CUSTOM_JFIF:
            let byteBuffer = try readByteBuffer(count: count)
            imgTexFormat = .jfif(byteBuffer)
        }

        return ImgTex(portalId: portalId, category: category, width: Int(width), height: Int(height), format: imgTexFormat)
    }
    
    @inline(__always)
    private func readByteBuffer(count: Count) throws -> ByteBuffer {
        let byteBuffer = MemoryBuffer(count: Int(count))
        try read(bytes: byteBuffer.bytes, count: byteBuffer.count)
        return byteBuffer
    }
    
    @inline(__always)
    private func readIndices<T>(width: Count, height: Count, count: Count, reader: () throws -> T) throws -> [T] {
        var indices = [T]()
        let numIndices = Int(width) * Int(height)
        indices.reserveCapacity(numIndices)
        for _ in 0..<height {
            for _ in 0..<width {
                let index = try reader()
                indices.append(index)
            }
        }
        return indices
    }

    @inline(__always)
    private func readColors<T : Color>(width: Count, height: Count, count: Count, reader: () throws -> T) throws -> [T] {
        var Colors = [T]()
        let numColors = Int(width) * Int(height)
        Colors.reserveCapacity(numColors)
        for _ in 0..<height {
            for _ in 0..<width {
                let Color = try reader()
                Colors.append(Color)
            }
        }
        return Colors
    }

    @inline(__always)
    private func readDXTBlocks<T : DXTBlock>(width: Count, height: Count, count: Count, reader: () throws -> T) throws -> [T] {
        var blocks = [T]()
        let blockSize = 4
        let blocksWide = Int(width) / blockSize
        let blocksTall = Int(height) / blockSize
        let numBlocks = blocksWide * blocksTall
        blocks.reserveCapacity(numBlocks)
        for _ in 0..<numBlocks {
            let block = try reader()
            blocks.append(block)
        }
        return blocks
    }
}
