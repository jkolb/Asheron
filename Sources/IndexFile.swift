public enum IndexFileError : Error {
    case missingHandle(UInt32)
}

public final class IndexFile {
    private let blockFile: BlockFile
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

    public init(blockFile: BlockFile, rootNodeOffset: UInt32) {
        self.blockFile = blockFile
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
            print(node)
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
        
        let node = parseNode(bytes: nodeBytes)
        
        nodeBytes.reset()
        
        return node
    }
    
    private func parseNode(bytes: ByteStream) -> Node {
        var node = Node()
        
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

        precondition(bytes.remaining == 0)
        
        return node
    }
}
