public enum PortalKind : UInt16 {
    case colors  = 0x0400
    case texture = 0x0600
}

public struct PortalHandle : Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible, RawRepresentable {
    public let kind: PortalKind
    public let index: UInt16
    
    public init?(rawValue: UInt32) {
        guard let kind = PortalKind(rawValue: UInt16((rawValue & 0xFFFF0000) >> 16)) else {
            return nil
        }
        let index = UInt16(rawValue & 0x0000FFFF)
        
        self.init(kind: kind, index: index)
    }

    public init(kind: PortalKind, index: UInt16) {
        self.kind = kind
        self.index = index
    }

    public var rawValue: UInt32 {
        return UInt32(kind.rawValue) << 16 | UInt32(index)
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public var description: String {
        return "\(kind)(\(index))"
    }
    
    public var debugDescription: String {
        var string = String(rawValue, radix: 16, uppercase: true)
        
        while string.characters.count < 8 {
            string = "0\(string)"
        }
        
        return string
    }
}
