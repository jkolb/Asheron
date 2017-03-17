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

public final class CellFile {
    private let indexFile: IndexFile
    
    public init(indexFile: IndexFile) {
        self.indexFile = indexFile
    }
    
    public func fetchTerrainBlock(x: UInt8, y: UInt8) throws -> TerrainBlock {
        let handle = CellHandle(x: x, y: y, index: 0xFFFF)
        let bytes = ByteStream(buffer: try indexFile.readData(handle: handle.rawValue))
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        let flags = bytes.getUInt32()
        let index = bytes.getUInt16(count: TerrainBlock.size * TerrainBlock.size)
        let height = bytes.getUInt8(count: TerrainBlock.size * TerrainBlock.size)
        bytes.skip(1)
        precondition(!bytes.hasRemaining)
        return TerrainBlock(handle: rawHandle, flags: flags, index: index, height: height)
    }
}
