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

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public final class BinaryFile {
    private let fileDescriptor: Int32
    
    public class func openForReading(at path: String) throws -> BinaryFile {
        return try openFile(at: path, flags: O_RDONLY)
    }
    
    public class func openForWriting(at path: String, create: Bool = true) throws -> BinaryFile {
        return try openFile(at: path, flags: create ? (O_WRONLY | O_CREAT) : O_WRONLY)
    }
    
    public class func openForUpdating(at path: String, create: Bool = true) throws -> BinaryFile {
        return try openFile(at: path, flags: create ? (O_RDWR | O_CREAT) : O_RDWR)
    }
    
    private class func openFile(at path: String, flags: Int32) throws -> BinaryFile {
        let fileDescriptor = open(path, flags, 0o666)
        
        if fileDescriptor < 0 {
            throw IOError.code(errno)
        }
        
        return BinaryFile(fileDescriptor: fileDescriptor)
    }
    
    private init(fileDescriptor: Int32) {
        self.fileDescriptor = fileDescriptor
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
    
    public func writeBytes(_ bytes: ByteBuffer, at offset: Int) throws {
        var buffer = bytes.bytes
        var length = bytes.count
        var offset = offset
        
        while length > 0 {
            let bytesRead = pwrite(fileDescriptor, buffer, length, numericCast(offset))
            
            if bytesRead < 0 {
                throw IOError.code(errno)
            }
            
            buffer += bytesRead
            length -= bytesRead
            offset += bytesRead
        }
    }
}
