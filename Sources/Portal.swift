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

public enum PortalKind : UInt32 {
    case colorTable  = 0x04000000
    case textureData = 0x06000000
}

public protocol PortalObject : CustomStringConvertible {
    static var kind: PortalKind { get }
    var handle: PortalHandle<Self> { get }
}

extension PortalObject {
    public var description: String {
        return "\(handle)"
    }
}

public struct PortalHandle<ObjectType : PortalObject> : Equatable, Hashable, CustomStringConvertible, RawRepresentable {
    public let index: UInt16
    
    public init?(rawValue: UInt32) {
        guard let kind = PortalKind(rawValue: rawValue & 0xFFFF0000) else {
            return nil
        }
        
        if kind != ObjectType.kind {
            return nil
        }
        
        let index = UInt16(rawValue & 0x0000FFFF)
        
        self.init(index: index)
    }

    public init(index: UInt16) {
        self.index = index
    }

    public var kind: PortalKind {
        return ObjectType.kind
    }
    
    public var rawValue: UInt32 {
        return kind.rawValue | UInt32(index)
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public var description: String {
        return "\(kind)(\(hex(rawValue)))"
    }
}
