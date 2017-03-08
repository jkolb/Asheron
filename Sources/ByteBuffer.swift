final class ByteBuffer {
    public let bytes: UnsafeMutableRawPointer
    public let count: Int
    
    init(count: Int) {
        self.bytes = UnsafeMutableRawPointer.allocate(bytes: count, alignedTo: MemoryLayout<UInt32>.size)
        self.count = count
    }
    
    deinit {
        bytes.deallocate(bytes: count, alignedTo: MemoryLayout<UInt32>.size)
    }
}
