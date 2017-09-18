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

public final class IndexFile {
    private let blockFile: BlockFile
    private let parser: IndexParser
    public let rootNodeOffset: UInt32
    private let nodeBytes: ByteStream
    private var nodeCache: [UInt32:Node]
    
    public struct Node {
        static let entryCount = 61
        static let offsetCount = entryCount + 1
        static let diskSize = MemoryLayout<UInt32>.size * (offsetCount + 1 + (entryCount * 6))
        
        public struct Entry {
            // 4 bytes skipped
            public var handle: UInt32 = 0
            public var offset: UInt32 = 0
            public var length: UInt32 = 0
            // 8 bytes ignored
        }
        
        public var offset = [UInt32](repeating: 0, count: Node.offsetCount)
        public var count: Int = 0
        public var entry = [Entry](repeating: Entry(), count: Node.entryCount)
        
        public var isLeaf: Bool {
            return offset[0] == 0
        }
    }
    
    public class func openForReading(at path: String) throws -> IndexFile {
        let binaryFile = try BinaryFile.openForReading(at: path)
        let headerBytes = ByteStream(buffer: ByteBuffer(count: 1024))
        try binaryFile.readBytes(headerBytes.buffer, at: 0)
        headerBytes.skip(324)
        let blockSize = headerBytes.getUInt32()
        headerBytes.skip(24)
        let rootNodeOffset = headerBytes.getUInt32()
        let blockFile = BlockFile(binaryFile: binaryFile, blockSize: blockSize)
        let indexFile = IndexFile(blockFile: blockFile, rootNodeOffset: rootNodeOffset)
        return indexFile
    }

    public init(blockFile: BlockFile, rootNodeOffset: UInt32) {
        self.blockFile = blockFile
        self.parser = IndexParser()
        self.rootNodeOffset = rootNodeOffset
        self.nodeBytes = ByteStream(buffer: ByteBuffer(count: Node.diskSize))
        self.nodeCache = [UInt32:Node](minimumCapacity: 64)
    }
    
    public func readData(handle: UInt32) throws -> ByteBuffer {
        guard let entry = try findEntry(for: handle) else {
            throw IndexFileError.missingHandle(handle)
        }
        
        return try readEntry(entry)
    }

    public func handles(matching filter: (UInt32) -> Bool) throws -> [UInt32] {
        let node = try fetchNode(at: rootNodeOffset)
        
        return try handlesInNode(node, matching: filter)
    }
    
    private func handlesInNode(_ node: Node, matching filter: (UInt32) -> Bool) throws -> [UInt32] {
        var handles = [UInt32]()
        
        for entryIndex in 0..<node.count {
            let entry = node.entry[Int(entryIndex)]
            
            if filter(entry.handle) {
                handles.append(entry.handle)
            }
        }
        
        if !node.isLeaf {
            for offsetIndex in 0...node.count {
                let offset = node.offset[Int(offsetIndex)]
                let nextNode = try fetchNode(at: offset)
                let nextHandles = try handlesInNode(nextNode, matching: filter)
                handles.append(contentsOf: nextHandles)
            }
        }
        
        return handles.sorted()
    }

    public func findEntry(for handle: UInt32) throws -> Node.Entry? {
        var offset = rootNodeOffset
        
        nextLevel: while offset > 0 {
            let node = try fetchNode(at: offset)
            precondition(node.count > 0)
            
            for index in 0..<node.count {
                let entry = node.entry[index]

                if entry.handle == handle {
                    return entry
                }
                else if entry.handle > handle {
                    // Traverse left
                    offset = node.isLeaf ? 0 : node.offset[index]
                    
                    continue nextLevel
                }
            }
            
            // Traverse right
            offset = node.isLeaf ? 0 : node.offset[node.count]
        }
        
        return nil
    }

    public func readEntry(_ entry: Node.Entry) throws -> ByteBuffer {
        let buffer = ByteBuffer(count: numericCast(entry.length))
        
        try blockFile.readBlocks(buffer, at: entry.offset)
        
        return buffer
    }
    
    public func fetchNode(at offset: UInt32) throws -> Node {
        if let node = nodeCache[offset] {
            return node
        }
        
        let node = try readNode(at: offset)
        
        nodeCache[offset] = node
        
        return node
    }
    
    public func readNode(at offset: UInt32) throws -> Node {
        try blockFile.readBlocks(nodeBytes.buffer, at: offset)
        
        let node = parser.parseNode(bytes: nodeBytes)
        
        nodeBytes.reset()
        
        return node
    }
}
