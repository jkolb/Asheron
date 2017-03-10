public class ByteStream : IteratorProtocol {
    public let buffer: ByteBuffer
    private var bytes: UnsafeMutableRawPointer
    
    public init(buffer: ByteBuffer) {
        self.buffer = buffer
        self.bytes = buffer.bytes
    }
    
    public var position: Int {
        get {
            return bytes - buffer.bytes
        }
        set {
            precondition(newValue >= 0 && newValue < buffer.count)
            bytes = buffer.bytes + newValue
        }
    }
    
    public var count: Int {
        return buffer.count
    }
    
    public var hasRemaining: Bool {
        return remaining > 0
    }
    
    public var remaining: Int {
        return count - position
    }
    
    public func reset() {
        position = 0
    }
    
    public func align(_ count: Int) {
        position += (count - (position % count)) % count
    }

    public func skip(_ count: Int) {
        precondition(count >= 0)
        precondition(remaining >= count)
        bytes += count
    }
    
    public func next() -> UInt8? {
        return hasRemaining ? getUInt8() : nil
    }

    public func getUInt8(count: Int) -> [UInt8] {
        precondition(remaining >= count)
        var array = [UInt8](repeating: 0, count: count)
        
        array.withUnsafeMutableBytes { (pointer) -> Void in
            pointer.copyBytes(from: UnsafeMutableRawBufferPointer(start: bytes, count: count))
        }
        
        bytes += count
        
        return array
    }
    
    public func getInt8() -> Int8 {
        return Int8(bitPattern: getUInt8())
    }
    
    public func getInt16() -> Int16 {
        return Int16(bitPattern: getUInt16())
    }
    
    public func getInt24() -> Int32 {
        precondition(remaining >= MemoryLayout<UInt8>.size * 3)
        let octets = bytes.bindMemory(to: UInt8.self, capacity: 3)
        let octet1 = UInt32(octets[0]) << 16
        let octet2 = UInt32(octets[1]) << 8
        let octet3 = UInt32(octets[2]) << 0
        let octet0 = octet1 & 0x00800000 == 0x00800000 ? UInt32(0xFF000000) : UInt32(0x00000000)
        bytes += MemoryLayout<UInt8>.size * 3
        return Int32(bitPattern: octet0 | octet1 | octet2 | octet3)
    }
    
    public func getInt32() -> Int32 {
        return Int32(bitPattern: getUInt32())
    }
    
    public func getInt64() -> Int64 {
        return Int64(bitPattern: getUInt64())
    }
    
    public func getUInt8() -> UInt8 {
        precondition(remaining >= MemoryLayout<UInt8>.size)
        let value = bytes.bindMemory(to: UInt8.self, capacity: 1).pointee
        bytes += MemoryLayout<UInt8>.size
        return value
    }
    
    public func getUInt16() -> UInt16 {
        precondition(remaining >= MemoryLayout<UInt16>.size)
        let value = bytes.bindMemory(to: UInt16.self, capacity: 1).pointee
        bytes += MemoryLayout<UInt16>.size
        return UInt16(littleEndian: value)
    }
    
    public func getUInt24() -> UInt32 {
        precondition(remaining >= MemoryLayout<UInt8>.size * 3)
        let octets = bytes.bindMemory(to: UInt8.self, capacity: 3)
        let octet1 = UInt32(octets[0]) << 16
        let octet2 = UInt32(octets[1]) << 8
        let octet3 = UInt32(octets[2]) << 0
        let octet0 = UInt32(0x00000000)
        bytes += MemoryLayout<UInt8>.size * 3
        return octet0 | octet1 | octet2 | octet3
    }

    public func getUInt32() -> UInt32 {
        precondition(remaining >= MemoryLayout<UInt32>.size)
        let value = bytes.bindMemory(to: UInt32.self, capacity: 1).pointee
        bytes += MemoryLayout<UInt32>.size
        return UInt32(littleEndian: value)
    }
    
    public func getUInt64() -> UInt64 {
        precondition(remaining >= MemoryLayout<UInt64>.size)
        let value = bytes.bindMemory(to: UInt64.self, capacity: 1).pointee
        bytes += MemoryLayout<UInt64>.size
        return UInt64(littleEndian: value)
    }
    
    public func getFloat32() -> Float32 {
        return unsafeBitCast(getUInt32(), to: Float32.self)
    }
    
    public func getFloat64() -> Float64 {
        return unsafeBitCast(getUInt64(), to: Float64.self)
    }
    
    public func getCString() -> String {
        let pointer = bytes.bindMemory(to: UInt8.self, capacity: remaining)
        var count = 0
        
        while (pointer[count] != 0) {
            precondition(count < remaining)
            count += 1
        }
        
        let string = String(cString: pointer)
        bytes += count
        
        return string
    }
    
    public func getUTF8(count: Int) -> String {
        var decodeCodec = UTF8()
        var generator = self
        var characters = [Character]()
        characters.reserveCapacity(count)
        var remaining = count
        
        while (remaining > 0) {
            let result = decodeCodec.decode(&generator)
            remaining -= 1
            
            switch result {
            case .scalarValue(let scalar):
                characters.append(Character(scalar))
                
            case .emptyInput:
                remaining = 0
                
            case .error:
                remaining = 0
            }
        }
        
        return String(characters)
    }
    
    public func putUInt8(_ array: [UInt8]) {
        array.withUnsafeBytes { (pointer) -> Void in
            bytes.copyBytes(from: pointer.baseAddress!, count: array.count)
        }
        
        bytes += array.count
    }
    
    public func putInt8(_ value: Int8) {
        putUInt8(UInt8(bitPattern: value))
    }
    
    public func putInt16(_ value: Int16) {
        putUInt16(UInt16(bitPattern: value))
    }
    
    public func putInt24(_ value: Int32) {
        precondition(value >= -8388608 && value <= 8388607)
        precondition(remaining >= MemoryLayout<UInt8>.size * 3)
        let octets = bytes.bindMemory(to: UInt8.self, capacity: 3)
        octets[0] = UInt8((value & 0x00FF0000) >> 16)
        octets[1] = UInt8((value & 0x0000FF00) >> 8)
        octets[2] = UInt8((value & 0x000000FF) >> 0)
        bytes += MemoryLayout<UInt8>.size * 3
    }
    
    public func putInt32(_ value: Int32) {
        putUInt32(UInt32(bitPattern: value))
    }
    
    public func putInt64(_ value: Int64) {
        putUInt64(UInt64(bitPattern: value))
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
    
    public func putUInt24(_ value: UInt32) {
        precondition(value <= 16777215)
        precondition(remaining >= MemoryLayout<UInt8>.size * 3)
        let octets = bytes.bindMemory(to: UInt8.self, capacity: 3)
        octets[0] = UInt8((value & 0x00FF0000) >> 16)
        octets[1] = UInt8((value & 0x0000FF00) >> 8)
        octets[2] = UInt8((value & 0x000000FF) >> 0)
        bytes += MemoryLayout<UInt8>.size * 3
    }
    
    public func putUInt32(_ value: UInt32) {
        precondition(remaining >= MemoryLayout<UInt32>.size)
        bytes.bindMemory(to: UInt32.self, capacity: 1).pointee = value.littleEndian
        bytes += MemoryLayout<UInt32>.size
    }
    
    public func putUInt64(_ value: UInt64) {
        precondition(remaining >= MemoryLayout<UInt64>.size)
        bytes.bindMemory(to: UInt64.self, capacity: 1).pointee = value.littleEndian
        bytes += MemoryLayout<UInt64>.size
    }
    
    public func putFloat32(_ value: Float32) {
        putUInt32(unsafeBitCast(value, to: UInt32.self))
    }
    
    public func putFloat64(_ value: Float64) {
        putUInt64(unsafeBitCast(value, to: UInt64.self))
    }
    
    public func putCString(_ value: String) {
        putUTF8(value)
        putUInt8(0)
    }

    public func putUTF8(_ value: String) {
        value.utf8.forEach { putUInt8($0) }
    }

    public func copyBytes(from source: ByteStream) {
        let bytesCopied = min(remaining, source.remaining)
        precondition(bytesCopied > 0)
        bytes.copyBytes(from: source.bytes, count: bytesCopied)
        bytes += bytesCopied
        source.bytes += bytesCopied
    }
    
    public func copyBytes(from source: ByteBuffer) {
        let bytesCopied = min(remaining, source.count)
        precondition(bytesCopied > 0)
        bytes.copyBytes(from: source.bytes, count: bytesCopied)
        bytes += bytesCopied
    }
    
    public func copyBytes(to destination: ByteStream) {
        let bytesCopied = min(remaining, destination.remaining)
        precondition(bytesCopied > 0)
        destination.bytes.copyBytes(from: bytes, count: bytesCopied)
        bytes += bytesCopied
        destination.bytes += bytesCopied
    }
    
    public func copyBytes(to destination: ByteBuffer) {
        let bytesCopied = min(remaining, destination.count)
        precondition(bytesCopied > 0)
        destination.bytes.copyBytes(from: bytes, count: bytesCopied)
        bytes += bytesCopied
    }
}
