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

public final class IndexParser {
    public func parseNode(bytes: OrderedByteBuffer<LittleEndian>) -> IndexFile.Node {
        var node = IndexFile.Node()
        
        for index in 0..<node.offset.count {
            node.offset[index] = bytes.getUInt32()
        }
        
        node.count = Int(bytes.getUInt32())
        
        for index in 0..<node.entry.count {
            // 4 bytes skipped
            bytes.skip(MemoryLayout<UInt32>.size)
            
            node.entry[index].handle = bytes.getUInt32()
            node.entry[index].offset = bytes.getUInt32()
            node.entry[index].length = bytes.getUInt32()
            
            // 8 bytes skipped
            bytes.skip(MemoryLayout<UInt32>.size * 2)
        }
        
        precondition(!bytes.hasRemaining)
        
        return node
    }
}
