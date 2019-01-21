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

public final class BlockDataSource : AsheronDataSource {
    public enum Error : Swift.Error {
        case truncatedBlock
    }
    
    private var dataSource: AsheronDataSource
    private let block: UnsafeMutableRawPointer
    private let blockSize: Int32
    
    public init(dataSource: AsheronDataSource, blockSize: Int32) {
        precondition(blockSize > Int32(MemoryLayout<Int32>.size))
        self.dataSource = dataSource
        self.block = UnsafeMutableRawPointer.allocate(byteCount: Int(blockSize), alignment: 1)
        self.blockSize = blockSize
    }
    
    public func wrap(bytes: UnsafeMutableRawPointer, count: Int32) -> AsheronInputStream {
        return dataSource.wrap(bytes: bytes, count: count)
    }
    
    public func read(bytes: UnsafeMutableRawPointer, count: Int32, at offset: Int32) throws -> Int32 {
        precondition(count > 0)
        precondition(offset >= 0)
        var output = bytes
        var offset = offset
        var remaining = count
        
        while offset > 0 {
            let blockReadCount = try dataSource.read(bytes: block, count: blockSize, at: offset)

            precondition(blockReadCount >= 0)
            precondition(blockReadCount <= blockSize)
            
            if blockReadCount < blockSize {
                throw Error.truncatedBlock
            }

            let input = dataSource.wrap(bytes: block, count: blockSize)
            offset = try input.readInt32()
            
            precondition(offset >= 0)
            precondition(input.bytesRead == Int32(MemoryLayout<Int32>.size))
            precondition(remaining > 0)
            
            let outputCount = min(blockSize - input.bytesRead, remaining)
            let inputReadCount = try input.read(bytes: output, count: outputCount)

            precondition(inputReadCount >= 0)
            precondition(inputReadCount <= outputCount)

            output += Int(inputReadCount)
            remaining -= inputReadCount
            
            precondition(remaining >= 0)
        }

        precondition(output == bytes + Int(count))
        
        return count
    }
}
