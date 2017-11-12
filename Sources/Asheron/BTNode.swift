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

public struct BTNode<Entry : BTEntry> : Packable {
    public var packSize: Int {
        let offsetSize = BTNode.offsetCount * MemoryLayout<UInt32>.size
        let countSize = 1 * MemoryLayout<UInt32>.size
        let entrySize = BTNode.entryCount * Entry.empty.packSize
        
        return offsetSize + countSize + entrySize
    }
    public static var entryCount: Int {
        return 61
    }
    public static var offsetCount: Int {
        return entryCount + 1
    }
    
    public var offset = [UInt32](repeating: 0, count: BTNode.offsetCount)
    public var count: Int = 0
    public var entry = [Entry](repeating: Entry.empty, count: BTNode.entryCount)
    
    public var isLeaf: Bool {
        return offset[0] == 0
    }
    
    public func pack<Order>(to buffer: OrderedByteBuffer<Order>) {
        fatalError("Not implemented")
    }
    
    public mutating func unpack<Order>(from buffer: OrderedByteBuffer<Order>) {
        for index in 0..<offset.count {
            offset[index] = buffer.getUInt32()
        }
        
        count = Int(buffer.getUInt32())
        
        for index in 0..<entry.count {
            entry[index].unpack(from: buffer)
        }
        
        precondition(!buffer.hasRemaining)
    }
}
