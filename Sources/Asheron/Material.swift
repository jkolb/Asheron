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

public final class Material : PortalObject, CustomStringConvertible {
    public struct Flags : OptionSet, CustomStringConvertible {
        public static let color        = Flags(rawValue: 1 << 0)
        public static let texture      = Flags(rawValue: 1 << 1)
        public static let clipmap      = Flags(rawValue: 1 << 2)
        
        public static let translucent  = Flags(rawValue: 1 << 4)
        public static let diffuse      = Flags(rawValue: 1 << 5)
        public static let luminous     = Flags(rawValue: 1 << 6)
        
        public static let alpha        = Flags(rawValue: 1 << 8)
        public static let inverseAlpha = Flags(rawValue: 1 << 9)
        
        public static let additive     = Flags(rawValue: 1 << 16)
        public static let detail       = Flags(rawValue: 1 << 17)
        
        public static let gouraud      = Flags(rawValue: 1 << 28)
        
        public static let stippled     = Flags(rawValue: 1 << 30)
        public static let perspective  = Flags(rawValue: 1 << 31)
        
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
        public var description: String {
            var values = self
            var strings = [String]()
            
            while !values.isEmpty {
                if values.contains(.color) {
                    strings.append("color")
                    values.subtract(.color)
                }
                if values.contains(.texture) {
                    strings.append("texture")
                    values.subtract(.texture)
                }
                if values.contains(.clipmap) {
                    strings.append("clipmap")
                    values.subtract(.clipmap)
                }
                if values.contains(.translucent) {
                    strings.append("translucent")
                    values.subtract(.translucent)
                }
                if values.contains(.diffuse) {
                    strings.append("diffuse")
                    values.subtract(.diffuse)
                }
                if values.contains(.luminous) {
                    strings.append("luminous")
                    values.subtract(.luminous)
                }
                if values.contains(.alpha) {
                    strings.append("alpha")
                    values.subtract(.alpha)
                }
                if values.contains(.inverseAlpha) {
                    strings.append("inverseAlpha")
                    values.subtract(.inverseAlpha)
                }
                if values.contains(.additive) {
                    strings.append("additive")
                    values.subtract(.additive)
                }
                if values.contains(.detail) {
                    strings.append("detail")
                    values.subtract(.detail)
                }
                if values.contains(.gouraud) {
                    strings.append("gouraud")
                    values.subtract(.gouraud)
                }
                if values.contains(.stippled) {
                    strings.append("stippled")
                    values.subtract(.stippled)
                }
                if values.contains(.perspective) {
                    strings.append("perspective")
                    values.subtract(.perspective)
                }
            }
            
            return "[\(strings.joined(separator: ", "))]"
        }
    }
    
    public enum Value {
        case invalid
        case color(PixelARGB8888)
        case texture(TextureListHandle, ColorTableHandle?)
    }
    
    public static let kind = PortalKind.material
    public var handle: MaterialHandle
    public var flags: Flags = []
    public var value: Value = .invalid
    public var translucency: Float = 0.0
    public var luminosity: Float = 0.0
    public var diffuse: Float = 0.0
    
    public init(handle: MaterialHandle) {
        self.handle = handle
    }
    
    public var description: String {
        switch value {
        case .invalid:
            return "\(handle): \(flags) - invalid"
            
        case .color(let argb):
            return "\(handle): \(flags) - \(argb)"
            
        case .texture(let texture, let colorTable):
            let colorTableString = colorTable != nil ? " \(colorTable!)" : ""
            return "\(handle): \(flags) - \(texture)\(colorTableString)"
        }
    }
}
