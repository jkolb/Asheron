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

class IndexedFileV1 {
    var byteOrder: ByteOrder
    var binaryFile: BinaryFile
    var header: Header
    var mappedBuffer: ByteBuffer
    var indexCache = Dictionary<Int, Index>(minimumCapacity: 64)
    
    struct Error {
        let code: Int
        let message: String
        
        init(code: Int = 0, message: String = "") {
            self.code = code
            self.message = message
        }
    }
    
    enum Type: Int {
        case Cell = 256
        case Portal = 1024
    }
    
    class func openForReading(path: String, type: Type, inout error: Error) -> IndexedFileV1? {
        let result = BinaryFile.openForReading(path)
        
        if let fileError = result.error {
            error = Error(code: Int(fileError.code))
            return nil;
        }
        
        return IndexedFileV1(byteOrder: LittleEndian(), binaryFile: result.value, type: type)
    }
    
    init(byteOrder: ByteOrder, binaryFile: BinaryFile, type: Type) {
        self.byteOrder = byteOrder
        self.binaryFile = binaryFile
        self.mappedBuffer = binaryFile.map(LittleEndian(), mode: .ReadOnly).value
        self.header = IndexedFileV1.readHeader(self.mappedBuffer)

        if (self.header.pageSize != type.toRaw()) {
            fatalError("Invalid file: Unexpected page size")
        }
    }
    
    deinit {
        binaryFile.unmap(mappedBuffer)
    }
    
    func findData(identifier: UInt32) -> ByteBuffer? {
        let rootIndex = readIndex(header.rootIndexOffset)
        if let key = findKey(identifier, index: rootIndex) {
            return readKeyData(key)
        }
        return nil
    }
    
    func findKey(identifier: UInt32, index: Index) -> Index.Key? {
        for keyIndex in 0..<index.count {
            let key = index.key[keyIndex]
            
            if key.value == identifier {
                return key
            } else if (key.value > identifier) {
                if index.isLeaf {
                    return nil
                } else {
                    let offset = index.offset[keyIndex]
                    let childIndex = readIndex(offset)
                    
                    return findKey(identifier, index: childIndex)
                }
            }
        }
        
        if index.isLeaf {
            return nil
        } else {
            let offset = index.offset[index.count]
            let childIndex = readIndex(offset)
            
            return findKey(identifier, index: childIndex)
        }
    }
    
    func readIndex(offset: Int) -> Index {
        if let index = indexCache[offset] { return index }
        let indexData = readIndexData(offset)
        indexData.flip()
        return indexData.getIndexedFileV1Index()
    }
    
    func readIndexData(offset: Int) -> ByteBuffer {
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
        
        return data
    }

    class func readHeader(buffer: ByteBuffer) -> Header {
        buffer.position = 300
        return buffer.getIndexedFileV1Header()
    }

    struct Header { // 1024
        var fileType: UInt32 = 0
        var pageSize: Int = 0
        var fileSize: Int = 0
        var fileVersion: UInt32 = 0
        var firstFreePageOffset: Int = 0
        var lastFreePageOffset: Int = 0
        var numberOfFreePages: Int = 0
        var rootIndexOffset: Int = 0
    }
    
    struct Index: Printable { // 984
        struct Key: Printable {
            let value: UInt32 = 0
            let offset: Int = 0
            let length: Int = 0
            
            var description: String { return "\(value):\(offset):\(length)" }
        }
        
        var offset: Array<Int> // 62
        var count: Int
        var key: Array<Key> // 61
        
        var isLeaf: Bool { return offset[0] == 0 }
        var description: String { return "\(offset):\(count):\(key)" }
    }
}
