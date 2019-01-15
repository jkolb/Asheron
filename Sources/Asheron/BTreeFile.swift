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

public typealias BTreeFileV1 = BTreeFile<BTEntryV1, BTreeInputStreamV1, LittleEndian>
public typealias BTreeFileV2 = BTreeFile<BTEntryV2, BTreeInputStreamV2, LittleEndian>

public final class BTreeFile<Entry, Input : BTreeInputStream, Order : ByteOrder> where Entry == Input.Entry {
    public enum Error : Swift.Error {
        case truncatedHeader
        case missingHandle(Handle)
    }

    private let blockFile: BlockFile
    public let rootNodeOffset: Offset
    private let nodeBytes: ByteBuffer
    private var nodeCache: [Offset:BTNode<Entry>]
    
    public class func open(at path: String) throws -> BTreeFile<Entry, Input, Order> {
        let binaryFile = try BinaryFile.open(forUpdatingAtPath: path, create: false)
        let headerBytes = OrderedBuffer<Order>(count: 1024)
        let readCount = try binaryFile.read(into: headerBytes)
        
        if readCount < headerBytes.count {
            throw Error.truncatedHeader
        }
        
        // TODO: This is for V2 header only!
        let blockSize = Length(rawValue: headerBytes.getUInt32(at: 324))
        let rootNodeOffset = Offset(rawValue: headerBytes.getInt32(at: 352))
        let blockFile = BlockFile(file: binaryFile, blockSize: blockSize)
        let btreeFile = BTreeFile<Entry, Input, Order>(blockFile: blockFile, rootNodeOffset: rootNodeOffset)
        return btreeFile
    }
    
    public init(blockFile: BlockFile, rootNodeOffset: Offset) {
        self.blockFile = blockFile
        self.rootNodeOffset = rootNodeOffset
        self.nodeBytes = MemoryBuffer(count: Input.nodeSize)
        self.nodeCache = [Offset:BTNode<Entry>](minimumCapacity: 64)
    }
    
    public func readData(handle: Handle) throws -> ByteBuffer {
        guard let entry = try findEntry(for: handle) else {
            throw Error.missingHandle(handle)
        }
        
        return try readEntry(entry)
    }
    
    public func handles(matching filter: (Handle) -> Bool) throws -> [Handle] {
        let node = try fetchNode(at: rootNodeOffset)
        
        return try handlesInNode(node, matching: filter)
    }
    
    private func handlesInNode(_ node: BTNode<Entry>, matching filter: (Handle) -> Bool) throws -> [Handle] {
        var handles = [Handle]()
        
        for index in 0..<node.numEntries {
            let entry = node.entry[index]
            
            if filter(entry.handle) {
                handles.append(entry.handle)
            }
        }
        
        if !node.isLeaf {
            for index in 0...node.numEntries {
                let nodeOffset = node.nextNode[index]
                let nextNode = try fetchNode(at: nodeOffset)
                let nextHandles = try handlesInNode(nextNode, matching: filter)
                handles.append(contentsOf: nextHandles)
            }
        }
        
        return handles.sorted()
    }
    
    public func findEntry(for handle: Handle) throws -> Entry? {
        var nodeOffset = rootNodeOffset
        
        nextLevel: while nodeOffset > 0 {
            let node = try fetchNode(at: nodeOffset)
            precondition(node.numEntries > 0)
            
            for index in 0..<node.numEntries {
                let entry = node.entry[index]
                
                if entry.handle == handle {
                    return entry
                }
                else if entry.handle > handle {
                    // Traverse left
                    nodeOffset = node.isLeaf ? 0 : node.nextNode[index]
                    
                    continue nextLevel
                }
            }
            
            // Traverse right
            nodeOffset = node.isLeaf ? 0 : node.nextNode[node.numEntries]
        }
        
        return nil
    }
    
    public func readEntry(_ entry: Entry) throws -> ByteBuffer {
        let buffer = MemoryBuffer(count: Int(entry.length))
        
        try blockFile.read(into: buffer, at: entry.offset)
        
        return buffer
    }
    
    public func fetchNode(at offset: Offset) throws -> BTNode<Entry> {
        if let node = nodeCache[offset] {
            return node
        }

        let node = try readNode(at: offset)

        nodeCache[offset] = node

        return node
    }
    
    public func readNode(at offset: Offset) throws -> BTNode<Entry> {
        try blockFile.read(into: nodeBytes, at: offset)
        let stream = Input.makeBTreeInputStream(stream: OrderedInputStream<Order>(stream: BufferInputStream(buffer: nodeBytes)))
        return try stream.readNode()
    }
}
