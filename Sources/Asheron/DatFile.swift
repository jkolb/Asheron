/*
The MIT License (MIT)

Copyright (c) 2020 Justin Kolb

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

import Foundation

public final class DatFile {
    public struct Header : Packable {
        static let diskSize = 1024
        var ignore0: [UInt8] = []
        var magic: [UInt8] = []
        var blockSize: Int = 0
        var fileSize: UInt32 = 0
        var dataSet: UInt32 = 0 // 1 = portal DATFILE_TYPE
        var dataSubset: UInt32 = 0 // Hires?
        var firstFree: UInt32 = 0
        var finalFree: UInt32 = 0
        var freeBlocks: UInt32 = 0
        var btreeRoot: Int = 0
        var youngLRU: UInt32 = 0
        var oldLRU: UInt32 = 0
        var useLRU: Bool = false
        var padding: [UInt8] = [] // 3
        var masterMapId: UInt32 = 0
        var engPackVNum: UInt32 = 0
        var gamePackVNum: UInt32 = 0
        var idVNum: [UInt8] = [] // 16
        var ignore1: [UInt8] = []

        public init() {}
        
        public init(from dataStream: DataStream) {
            self.ignore0 = [UInt8](from: dataStream, count: 320)
            self.magic = [UInt8](from: dataStream, count: 4)
            precondition(magic == [0x42, 0x54, 0x00, 0x00]) // BT\0\0
            self.blockSize = numericCast(UInt32(from: dataStream))
            precondition(blockSize > MemoryLayout<Int32>.size)
            self.fileSize = UInt32(from: dataStream)
            self.dataSet = UInt32(from: dataStream)
            self.dataSubset = UInt32(from: dataStream)
            self.firstFree = UInt32(from: dataStream)
            self.finalFree = UInt32(from: dataStream)
            self.freeBlocks = UInt32(from: dataStream)
            self.btreeRoot = numericCast(UInt32(from: dataStream))
            self.youngLRU = UInt32(from: dataStream)
            self.oldLRU = UInt32(from: dataStream)
            self.useLRU = UInt8(from: dataStream) != 0
            self.padding = [UInt8](from: dataStream, count: 3)
            self.masterMapId = UInt32(from: dataStream)
            self.engPackVNum = UInt32(from: dataStream)
            self.gamePackVNum = UInt32(from: dataStream)
            self.idVNum = [UInt8](from: dataStream, count: 20)
            self.ignore1 = [UInt8](from: dataStream, count: 624)
            precondition(dataStream.remainingCount == 0)
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }
    
    public struct Node : Packable {
        public static let diskSize = (nextNodeCount * 4) + 4 + (entryCount * Entry.byteCount)
        public static let entryCount = 61
        public static var nextNodeCount = entryCount + 1
        
        public struct Entry : Packable {
            public static let byteCount = 24
            
            public var comp_resv_ver: UInt32 // 1_111111111111111_1111111111111111
            public var identifier: Identifier
            public var offset: Int
            public var length: Int
            public var date: UInt32
            public var iter: UInt32
            
            public init(from dataStream: DataStream) {
                self.comp_resv_ver = UInt32(from: dataStream)
                self.identifier = Identifier(from: dataStream)
                self.offset = numericCast(Int32(from: dataStream))
                self.length = numericCast(Int32(from: dataStream))
                self.date = UInt32(from: dataStream)
                self.iter = UInt32(from: dataStream)
            }
            
            @inlinable public func encode(to dataStream: DataStream) {
                fatalError("Not implemented")
            }
        }
        
        public var nextNode: [Int]
        public var numEntries: Int
        public var entry: [Entry]
        public init(nextNode: [Int], numEntries: Int, entry: [Entry]) {
            precondition(nextNode.count == Node.nextNodeCount)
            precondition(entry.count == Node.entryCount)
            precondition(numEntries <= Node.entryCount)
            self.nextNode = nextNode
            self.numEntries = numEntries
            self.entry = entry
        }
        
        public var isLeaf: Bool {
            return nextNode[0] == 0
        }
        
        public init(from dataStream: DataStream) {
            self.nextNode = [Int32](from: dataStream, count: Node.nextNodeCount).map({ numericCast($0) })
            self.numEntries = numericCast(Int32(from: dataStream))
            self.entry = [Entry](from: dataStream, count: Node.entryCount)
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }

    private let fileHandle: FileHandle
    private var header: Header

    public init(url: URL) throws {
        self.fileHandle = try FileHandle(forUpdating: url)
        self.header = Self.readHeader(fileHandle: fileHandle)
    }
    
    public func readRegion(id: Identifier) -> Region {
        let data = readData(id: id)
        let dataStream = DataStream(data: data)
        return Region(from: dataStream, id: id)
    }
    
    public func readSetup(id: Identifier) -> Setup {
        let data = readData(id: id)
        let dataStream = DataStream(data: data)
        return Setup(from: dataStream, id: id)
    }
    
    public func readSurface(id: Identifier) -> Surface {
        let data = readData(id: id)
        let dataStream = DataStream(data: data)
        return Surface(from: dataStream, id: id)
    }
    
    public func readSurfaceTexture(id: Identifier) -> SurfaceTexture {
        let data = readData(id: id)
        let dataStream = DataStream(data: data)
        return SurfaceTexture(from: dataStream, id: id)
    }
    
    public func readTexture(id: Identifier) -> Texture {
        let data = readData(id: id)
        let dataStream = DataStream(data: data)
        return Texture(from: dataStream, id: id)
    }
    
    public func readPalette(id: Identifier) -> Palette {
        let data = readData(id: id)
        let dataStream = DataStream(data: data)
        return Palette(from: dataStream, id: id)
    }
    
    public func readGraphicsObject(id: Identifier) -> GraphicsObject {
        let data = readData(id: id)
        let dataStream = DataStream(data: data)
        return GraphicsObject(from: dataStream, id: id)
    }

    public func readWave(id: Identifier) -> Wave {
        let data = readData(id: id)
        let dataStream = DataStream(data: data)
        return Wave(from: dataStream, id: id)
    }
    
    public func readData(id: Identifier) -> Data {
        guard let entry = findEntry(for: id) else {
            fatalError("Missing identifier: \(id)")
        }
        
        return readEntry(entry)
    }
    
    public func allIdentifiers() -> [Identifier] {
        return identifiers(matching: { _ in true })
    }
    
    public func identifiers(for dbType: DBType) -> [Identifier] {
        return identifiers(matching: { dbType.matches(id: $0) })
    }
    
    public func identifiers(matching filter: (Identifier) -> Bool) -> [Identifier] {
        let node = readNode(fileOffset: header.btreeRoot)
        
        return identifiersInNode(node, matching: filter)
    }
    
    private func identifiersInNode(_ node: Node, matching filter: (Identifier) -> Bool) -> [Identifier] {
        var identifiers = [Identifier]()
        
        for index in 0..<node.numEntries {
            let entry = node.entry[index]
            
            if filter(entry.identifier) {
                identifiers.append(entry.identifier)
            }
        }
        
        if !node.isLeaf {
            for index in 0...node.numEntries {
                let nodeOffset = node.nextNode[index]
                let nextNode = readNode(fileOffset: nodeOffset)
                let nextIdentifiers = identifiersInNode(nextNode, matching: filter)
                identifiers.append(contentsOf: nextIdentifiers)
            }
        }
        
        return identifiers.sorted()
    }
    
    public func findEntry(for identifier: Identifier) -> Node.Entry? {
        var nodeOffset = header.btreeRoot
        
        nextLevel: while nodeOffset > 0 {
            let node = readNode(fileOffset: nodeOffset)
            precondition(node.numEntries > 0)
            
            for index in 0..<node.numEntries {
                let entry = node.entry[index]
                
                if entry.identifier == identifier {
                    return entry
                }
                else if entry.identifier > identifier {
                    nodeOffset = node.isLeaf ? 0 : node.nextNode[index]
                    
                    continue nextLevel
                }
            }
            
            nodeOffset = node.isLeaf ? 0 : node.nextNode[node.numEntries]
        }
        
        return nil
    }
    
    public func readEntry(_ entry: Node.Entry) -> Data {
        return readBlocks(fileHandle: fileHandle, fileOffset: entry.offset, length: entry.length)
    }
    
    public func readNode(fileOffset: Int) -> Node {
        let data = readBlocks(fileHandle: fileHandle, fileOffset: fileOffset, length: Node.diskSize)
        let dataStream = DataStream(data: data)
        let node = Node(from: dataStream)
        return node
    }
    
    public static func readHeader(fileHandle: FileHandle) -> Header {
        let data = readBytes(fileHandle: fileHandle, fileOffset: 0, length: Header.diskSize)
        let dataStream = DataStream(data: data)
        let header = Header(from: dataStream)
        return header
    }

    public func readBlocks(fileHandle: FileHandle, fileOffset: Int, length: Int) -> Data {
        precondition(length > 0)
        let dataStream = DataStream(count: length)
        var nextOffset = fileOffset
        
        while nextOffset > 0 {
            precondition(nextOffset >= Header.diskSize)
            precondition((nextOffset - Header.diskSize) % header.blockSize == 0)
            let block = Self.readBytes(fileHandle: fileHandle, fileOffset: nextOffset, length: header.blockSize)
            let blockStream = DataStream(data: block)
            nextOffset = numericCast(Int32(from: blockStream))
            precondition(nextOffset >= 0)
            dataStream.putRemainingData(blockStream)
            precondition(dataStream.remainingCount >= 0)
        }
        
        precondition(dataStream.remainingCount == 0)
        return dataStream.data
    }
    
    public func writeBlocks(data: Data, fileOffset: Int) {
        fatalError()
    }
    
    public static func readBytes(fileHandle: FileHandle, fileOffset: Int, length: Int) -> Data {
        precondition(fileOffset >= 0)
        precondition(length > 0)
        let data = try! fileHandle.readDataUp(toLength: length, at: numericCast(fileOffset))
        precondition(data.count == length)
        return data
    }
    
    public func writeBytes(data: Data, fileOffset: Int) {
        fatalError()
    }
}

extension FileHandle {
    @inlinable public func readDataUp(toLength length: Int, at offset: UInt64) throws -> Data {
        try seek(toOffset: offset)
        return try __readDataUp(toLength: length)
    }
}
