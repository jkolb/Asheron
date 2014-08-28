//
//  IndexedFile.swift
//  AC
//
//  Created by Justin Kolb on 7/17/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    func getIntFrom8Bits() -> Int {
        return Int(getUInt8())
    }
    
    func getIntFrom8Bits(count: Int) -> Array<Int> {
        return getArray(count, defaultValue: 0) { self.getIntFrom8Bits() }
    }
    
    func getIntFrom16Bits() -> Int {
        return Int(getUInt16())
    }
    
    func getIntFrom16Bits(count: Int) -> Array<Int> {
        return getArray(count, defaultValue: 0) { self.getIntFrom16Bits() }
    }
    
    func getIntFrom32Bits() -> Int {
        return Int(getInt32())
    }
    
    func getIntFrom32Bits(count: Int) -> Array<Int> {
        return getArray(count, defaultValue: 0) { self.getIntFrom32Bits() }
    }
    
    func getIndexedFileV1Header() -> IndexedFileV1.Header {
        var header = IndexedFileV1.Header()
        header.fileType = getUInt32()
        header.pageSize = getIntFrom32Bits()
        header.fileSize = getIntFrom32Bits()
        header.fileVersion = getUInt32()
        header.firstFreePageOffset = getIntFrom32Bits()
        header.lastFreePageOffset = getIntFrom32Bits()
        header.numberOfFreePages = getIntFrom32Bits()
        header.rootIndexOffset = getIntFrom32Bits()
        return header
    }
    
    func getIndexedFileV1IndexKey() -> IndexedFileV1.Index.Key {
        return IndexedFileV1.Index.Key(
            value: getUInt32(),
            offset: getIntFrom32Bits(),
            length: getIntFrom32Bits()
        )
    }
    
    func getIndexedFileV1IndexKey(count: Int) -> Array<IndexedFileV1.Index.Key> {
        return getArray(count, defaultValue: IndexedFileV1.Index.Key()) { return self.getIndexedFileV1IndexKey() }
    }
    
    func getIndexedFileV1Index() -> IndexedFileV1.Index {
        let offset = getIntFrom32Bits(62)
        let count = getIntFrom32Bits()
        let key = getIndexedFileV1IndexKey(61)
        return IndexedFileV1.Index(offset: offset, count: count, key: key)
    }
}

public class IndexedFileV1 {
    var byteOrder: ByteOrder
    var binaryFile: BinaryFile
    var header: Header
    var mappedBuffer: ByteBuffer
    var indexCache = Dictionary<Int, Index>(minimumCapacity: 64)
    
    public var readonlyHeader: Header {
        return header
    }
    
    public struct Error {
        public let code: Int
        public let message: String
        
        public init(code: Int = 0, message: String = "") {
            self.code = code
            self.message = message
        }
    }
    
    public class func openForReading(path: String, inout error: Error) -> IndexedFileV1? {
        let result = BinaryFile.openForReading(path)
        
        if let fileError = result.error {
            error = Error(code: Int(fileError.code))
            return nil;
        }
        
        return IndexedFileV1(byteOrder: LittleEndian(), binaryFile: result.binaryFile)
    }
    
    init(byteOrder: ByteOrder, binaryFile: BinaryFile) {
        self.byteOrder = byteOrder
        self.binaryFile = binaryFile
        self.mappedBuffer = binaryFile.map(LittleEndian(), mode: .ReadOnly).byteBuffer
        self.header = IndexedFileV1.readHeader(self.mappedBuffer)

        if (self.header.pageSize != 1024 && self.header.pageSize != 256) {
            fatalError("Invalid file: Unexpected page size")
        }
    }
    
    deinit {
        binaryFile.unmap(mappedBuffer)
    }
    
    public func findData(identifier: UInt32) -> ByteBuffer? {
        let rootIndex = readIndex(header.rootIndexOffset)
        if let key = findKey(identifier, index: rootIndex) {
            return readKeyData(key)
        }
        return nil
    }
    
    public func findKey(identifier: UInt32, index: Index) -> Index.Key? {
        var keyIndex = 0
        while keyIndex < index.count && identifier > index.key[keyIndex].value { keyIndex++ }
        if index.key[keyIndex].value == identifier { return index.key[keyIndex] }
        if index.isLeaf { return nil }
        return findKey(identifier, index: readIndex(index.offset[keyIndex]))
    }
    
    public func readIndex(offset: Int) -> Index {
        if let index = indexCache[offset] { return index }
        let indexData = readIndexData(offset)
        return indexData.getIndexedFileV1Index()
    }
    
    public func readIndexData(offset: Int) -> ByteBuffer {
        return IndexedFileV1.readData(mappedBuffer, offset: offset, length: 984, pageSize: header.pageSize)
    }
    
    func readKeyData(key: Index.Key) -> ByteBuffer {
        return IndexedFileV1.readData(mappedBuffer, offset: key.offset, length: key.length, pageSize: header.pageSize)
    }
    
    class func readData(buffer: ByteBuffer, offset: Int, length: Int, pageSize: Int) -> ByteBuffer {
        let data = ByteBuffer(order: buffer.order, capacity: length)
        var nextOffset = offset
        
        while data.remaining > 0 {
            let page = buffer[nextOffset..<nextOffset+pageSize]
            nextOffset = page.getIntFrom32Bits()
            
            if data.remaining < page.remaining {
                page.limit = page.position + data.remaining
            }
            
            data.putBuffer(page)
        }
        
        data.flip()
        return data
    }

    class func readHeader(buffer: ByteBuffer) -> Header {
        buffer.position = 300
        return buffer.getIndexedFileV1Header()
    }

    public struct Header: Printable { // 1024
        public var fileType: UInt32 = 0
        public var pageSize: Int = 0
        public var fileSize: Int = 0
        public var fileVersion: UInt32 = 0
        public var firstFreePageOffset: Int = 0
        public var lastFreePageOffset: Int = 0
        public var numberOfFreePages: Int = 0
        public var rootIndexOffset: Int = 0
        
        public var description: String { return "File Type: \(fileType)\nPage Size: \(pageSize)" }
    }
    
    public struct Index: Printable { // 984
        public struct Key: Printable {
            public let value: UInt32 = 0
            public let offset: Int = 0
            public let length: Int = 0
            
            public var description: String { return "\(value):\(offset):\(length)" }
        }
        
        public var offset: Array<Int> // 62
        public var count: Int
        public var key: Array<Key> // 61
        
        public var isLeaf: Bool { return offset[0] == 0 }
        public var description: String { return "\(offset):\(count):\(key)" }
    }
}
