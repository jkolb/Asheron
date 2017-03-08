#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public enum IOError : Error, CustomStringConvertible {
    case code(Int32)
    case eof
    
    public var description: String {
        switch self {
        case .code(let code):
            if let message = String(validatingUTF8: strerror(errno)) {
                return "\(code): \(message)"
            }
            else {
                return "\(code)"
            }
        case .eof:
            return "EOF"
        }
    }
}
