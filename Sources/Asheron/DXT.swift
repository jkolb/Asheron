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

/*
 Compressed Texture Resources (Direct3D 9)
 https://msdn.microsoft.com/en-us/library/bb204843(v=vs.85).aspx
 FOURCC Description         Alpha premultiplied?
 DXT1   Opaque/1-bit alpha  N/A
 DXT2   Explicit alpha      Yes
 DXT3   Explicit alpha      No
 DXT4   Interpolated alpha  Yes
 DXT5   Interpolated alpha  No
 */

public final class DXT {
    public static func decompress<Reader: DXTReader>(width: Int, height: Int, data: ByteBuffer, reader: Reader) -> ByteBuffer {
        let outputSize = width * height * PixelARGB8888.byteCount
        let outputStream = ByteStream(buffer: ByteBuffer(count: outputSize))
        let inputStream = ByteStream(buffer: data)
        
        let blockSize = 4
        let blocksWide = width / blockSize
        let blocksTall = height / blockSize
        var blockCache = Array<Reader.DXTBlockType>()
        blockCache.reserveCapacity(blocksWide)
        
        for _ in 1...blocksTall {
            blockCache.removeAll(keepingCapacity: true)
            
            for _ in 1...blocksWide {
                let block = reader.read(inputStream)
                blockCache.append(block)
            }
            
            for index in 0..<blockSize {
                let offset = index * blockSize
                
                for block in blockCache {
                    outputStream.putUInt32(block.color(at: 0 + offset).bits)
                    outputStream.putUInt32(block.color(at: 1 + offset).bits)
                    outputStream.putUInt32(block.color(at: 2 + offset).bits)
                    outputStream.putUInt32(block.color(at: 3 + offset).bits)
                }
            }
        }
        
        return outputStream.buffer
    }
}
