#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public final class BinaryFile {
    private let fileDescriptor: CInt
    
    public init(path: String) throws {
        self.fileDescriptor = open(path, O_RDONLY)
        if fileDescriptor < 0 {
            throw IOError.code(errno)
        }
    }
    
    deinit {
        close(fileDescriptor)
    }
    
    public func readBytes(_ bytes: ByteBuffer, at offset: Int) throws {
        var buffer = bytes.bytes
        var length = bytes.count
        var offset = offset
        
        while length > 0 {
            let bytesRead = pread(fileDescriptor, buffer, length, numericCast(offset))
            
            if bytesRead < 0 {
                throw IOError.code(errno)
            }
            
            if bytesRead == 0 {
                throw IOError.eof
            }
            
            buffer += bytesRead
            length -= bytesRead
            offset += bytesRead
        }
    }
}
