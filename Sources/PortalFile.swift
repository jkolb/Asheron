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

public final class PortalFile {
    private let indexFile: IndexFile
    
    public init(indexFile: IndexFile) {
        self.indexFile = indexFile
    }
    
    public func fetchColors(handle: PortalHandle) throws -> [ARGB8888] {
        precondition(handle.kind == .colors)
        let bytes = ByteStream(buffer: try indexFile.readData(handle: handle.rawValue))
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        let count = bytes.getUInt32()
        var colors = [ARGB8888]()
        colors.reserveCapacity(numericCast(count))
        
        for _ in 0..<count {
            let color = ARGB8888(bits: bytes.getUInt32())
            
            colors.append(color)
        }
        
        return colors
    }
    
    public func fetchTexture(handle: PortalHandle) throws -> Texture {
        precondition(handle.kind == .texture)
        let bytes = ByteStream(buffer: try indexFile.readData(handle: handle.rawValue))
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        bytes.skip(MemoryLayout<UInt32>.size)
        let width = bytes.getUInt32()
        let height = bytes.getUInt32()
        let format = TextureFormat(rawValue: bytes.getUInt32())!
        let data = ByteBuffer(count: numericCast(bytes.getUInt32()))
        bytes.copyBytes(to: data)
        var colors: [ARGB8888] = []
        
        if format == .D3DFMT_INDEX16 || format == .D3DFMT_P8 {
            colors = try fetchColors(handle: PortalHandle(rawValue: bytes.getUInt32())!)
        }

        return Texture(width: width, height: height, format: format, data: data, colors: colors)
    }
}
