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
