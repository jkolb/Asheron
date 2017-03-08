class ByteBufferStream {
    let buffer: ByteBuffer
    private var bytes: UnsafeMutableRawPointer
    
    init(buffer: ByteBuffer) {
        self.buffer = buffer
        self.bytes = buffer.bytes
    }
    
    var remaining: Int {
        return buffer.count - (bytes - buffer.bytes)
    }
    
    func reset() {
        bytes = buffer.bytes
    }
    
    func skipBytes(_ count: Int) {
        precondition(count >= 0)
        precondition(remaining >= count)
        bytes += count
    }
    
    func getUInt8() -> UInt8 {
        precondition(remaining >= MemoryLayout<UInt8>.size)
        let value = bytes.bindMemory(to: UInt8.self, capacity: 1).pointee
        bytes += MemoryLayout<UInt8>.size
        return value
    }
    
    func getUInt16() -> UInt16 {
        precondition(remaining >= MemoryLayout<UInt16>.size)
        let value = bytes.bindMemory(to: UInt16.self, capacity: 1).pointee
        bytes += MemoryLayout<UInt16>.size
        return UInt16(littleEndian: value)
    }

    func getUInt32() -> UInt32 {
        precondition(remaining >= MemoryLayout<UInt32>.size)
        let value = bytes.bindMemory(to: UInt32.self, capacity: 1).pointee
        bytes += MemoryLayout<UInt32>.size
        return UInt32(littleEndian: value)
    }
    
    func getFloat32() -> Float32 {
        return unsafeBitCast(getUInt32(), to: Float32.self)
    }
    
    public func putUInt8(_ value: UInt8) {
        precondition(remaining >= MemoryLayout<UInt8>.size)
        bytes.bindMemory(to: UInt8.self, capacity: 1).pointee = value
        bytes += MemoryLayout<UInt8>.size
    }
    
    public func putUInt16(_ value: UInt16) {
        precondition(remaining >= MemoryLayout<UInt16>.size)
        bytes.bindMemory(to: UInt16.self, capacity: 1).pointee = value.littleEndian
        bytes += MemoryLayout<UInt16>.size
    }
    
    public func putUInt32(_ value: UInt32) {
        precondition(remaining >= MemoryLayout<UInt32>.size)
        bytes.bindMemory(to: UInt32.self, capacity: 1).pointee = value.littleEndian
        bytes += MemoryLayout<UInt32>.size
    }
    
    public func putFloat32(_ value: Float32) {
        putUInt32(unsafeBitCast(value, to: UInt32.self))
    }

    func copyBytes(from source: ByteBufferStream) {
        let bytesCopied = min(remaining, source.remaining)
        precondition(bytesCopied > 0)
        bytes.copyBytes(from: source.bytes, count: bytesCopied)
        bytes += bytesCopied
        source.bytes += bytesCopied
    }
}
