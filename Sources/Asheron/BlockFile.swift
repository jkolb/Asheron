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

public final class BlockFile {
    public enum Error : Swift.Error {
        case truncatedBlock
    }
    
    private var file: ReadWriteFile
    private let block: OrderedBuffer<LittleEndian>
    
    public init(file: ReadWriteFile, blockSize: Length) {
        self.file = file
        self.block = OrderedBuffer<LittleEndian>(count: Int(blockSize))
    }
    
    public func read(into buffer: ByteBuffer, at offset: Offset) throws {
        let output = BufferOutputStream(buffer: buffer)
        var offset = offset

        while offset > 0 {
            file.position = Int(offset)
            let readCount = try file.read(into: block)

            if readCount < block.count {
                throw Error.truncatedBlock
            }

            let input = BufferInputStream(buffer: block)
            offset = Offset(rawValue: try input.readInt32())
            try output.write(bytes: input.remainingBytes, count: min(input.remainingCount, output.remainingCount))
        }

        precondition(output.offset == buffer.count)
    }
}
