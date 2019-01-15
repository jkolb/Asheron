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

public protocol BTreeInputStream {
    associatedtype Entry : BTEntry
    static var nodeSize: Int { get }
    func readNode() throws -> BTNode<Entry>
    static func makeBTreeInputStream(stream: ByteInputStream) -> Self
}

public final class BTreeInputStreamV1 : DatInputStream, BTreeInputStream {
    public static var nodeSize: Int {
        return (Int(BTNode<BTEntryV1>.nextNodeCount) * MemoryLayout<Offset>.size) + MemoryLayout<Count>.size + (Int(BTNode<BTEntryV1>.entryCount) * MemoryLayout<BTEntryV1>.size)
    }
    
    public static func makeBTreeInputStream(stream: ByteInputStream) -> BTreeInputStreamV1 {
        return BTreeInputStreamV1(stream: stream)
    }
    
    public func readNode() throws -> BTNode<BTEntryV1> {
        let nextNode = try readNextNode()
        let numEntries = try readCount()
        let entry = try readEntry()
        return BTNode<BTEntryV1>(nextNode: nextNode, numEntries: numEntries, entry: entry)
    }
    
    @inline(__always)
    private func readNextNode() throws -> [Offset] {
        return try readArray(count: BTNode<BTEntryV1>.nextNodeCount, readElement: readOffset)
    }

    @inline(__always)
    private func readEntry() throws -> [BTEntryV1] {
        return try readArray(count: BTNode<BTEntryV1>.entryCount, readElement: readEntryV1)
    }
    
    @inline(__always)
    private func readEntryV1() throws -> BTEntryV1 {
        let handle = try readHandle()
        let offset = try readOffset()
        let length = try readLength()
        
        return BTEntryV1(handle: handle, offset: offset, length: length)
    }
}

public final class BTreeInputStreamV2 : DatInputStream, BTreeInputStream {
    public static var nodeSize: Int {
        return (Int(BTNode<BTEntryV2>.nextNodeCount) * MemoryLayout<Offset>.size) + MemoryLayout<Count>.size + (Int(BTNode<BTEntryV2>.entryCount) * MemoryLayout<BTEntryV2>.size)
    }
    
    public static func makeBTreeInputStream(stream: ByteInputStream) -> BTreeInputStreamV2 {
        return BTreeInputStreamV2(stream: stream)
    }
    
    public func readNode() throws -> BTNode<BTEntryV2> {
        let nextNode = try readNextNode()
        let numEntries = try readCount()
        let entry = try readEntry()
        return BTNode<BTEntryV2>(nextNode: nextNode, numEntries: numEntries, entry: entry)
    }
    
    @inline(__always)
    private func readNextNode() throws -> [Offset] {
        return try readArray(count: BTNode<BTEntryV2>.nextNodeCount, readElement: readOffset)
    }
    
    @inline(__always)
    private func readEntry() throws -> [BTEntryV2] {
        return try readArray(count: BTNode<BTEntryV2>.entryCount, readElement: readEntryV2)
    }

    @inline(__always)
    private func readEntryV2() throws -> BTEntryV2 {
        let comp_resv_ver = try readUInt32()
        let handle = try readHandle()
        let offset = try readOffset()
        let length = try readLength()
        let date = try readUInt32()
        let iter = try readUInt32()
        
        return BTEntryV2(comp_resv_ver: comp_resv_ver, handle: handle, offset: offset, length: length, date: date, iter: iter)
    }
}
