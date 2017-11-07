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

extension ReadableFile {
    public func read(into buffer: OrderedByteBuffer<LittleEndian>, count: Int) throws -> Int {
        precondition(count <= buffer.remainingCount)
        let readCount = try read(into: buffer.remainingBytes, count: count)
        buffer.position += readCount
        return readCount
    }
    
    public func read(into buffer: OrderedByteBuffer<LittleEndian>) throws -> Int {
        return try read(into: buffer, count: buffer.remainingCount)
    }
}

public final class BlockFile {
    public enum Error : Swift.Error {
        case truncatedBlock
    }
    
    private var file: ReadableFile & SeekableFile
    private let block: OrderedByteBuffer<LittleEndian>
    
    public init(file: ReadableFile & SeekableFile, blockSize: UInt32) {
        self.file = file
        self.block = OrderedByteBuffer<LittleEndian>(count: numericCast(blockSize))
    }
    
    public func readBlocks(_ blocks: ByteBuffer, at offset: UInt32) throws {
        let data = OrderedByteBuffer<LittleEndian>(buffer: blocks)
        var offset = offset
        
        while offset > 0 {
            file.position = numericCast(offset)
            block.position = 0
            let readCount = try file.read(into: block)
            
            if readCount < block.count {
                throw Error.truncatedBlock
            }
            
            block.position = 0
            offset = block.getUInt32()
            block.copy(to: data)
        }
        
        precondition(!data.hasRemaining)
    }
}
