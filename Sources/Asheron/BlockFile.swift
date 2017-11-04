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

public final class BlockFile {
    private let binaryFile: BinaryFile
    private let block: ByteStream
    
    public init(binaryFile: BinaryFile, blockSize: UInt32) {
        self.binaryFile = binaryFile
        self.block = ByteStream(buffer: ByteBuffer(count: numericCast(blockSize)))
    }
    
    public func readBlocks(_ blocks: ByteBuffer, at offset: UInt32) throws {
        let data = ByteStream(buffer: blocks)
        var offset = offset
        
        while offset > 0 {
            try binaryFile.readBytes(block.buffer, at: numericCast(offset))
            
            offset = block.getUInt32()
            data.copyBytes(from: block)
            
            block.reset()
        }
        
        precondition(!data.hasRemaining)
    }
}
