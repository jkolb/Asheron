/*
The MIT License (MIT)

Copyright (c) 2020 Justin Kolb

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

public enum PixelFormat : UInt32, Packable {
    /* DirectX standard formats */
    case r8g8b8   = 20         // RGB888
    case a8r8g8b8 = 21         // ARGB8888
    case r5g6b5   = 23         // RGB565
    case a4r4g4b4 = 26         // ARGB4444
    case a8       = 28         // 8-bit alpha only
    case p8       = 41         // 8-bit index
    case dxt1     = 0x31545844 // MAKEFOURCC('D', 'X', 'T', '1')
    case dxt3     = 0x33545844 // MAKEFOURCC('D', 'X', 'T', '3')
    case dxt5     = 0x35545844 // MAKEFOURCC('D', 'X', 'T', '5')
    case index16  = 101        // 16-bit index
    /* Custom formats */
    case b8g8r8Landscape = 0xF3   // BGR888
    case alphaLandscape  = 0xF4   // 8-bit alpha only
    case rawJPEG         = 0x01F4 // JFIF https://en.wikipedia.org/wiki/JPEG_File_Interchange_Format
    
    public var hasPalette: Bool {
        return self == .p8 || self == .index16
    }
    
    public var fileExtension: String {
        switch self {
        case .rawJPEG: return "jpg"
        default: return "bmp"
        }
    }
}

public protocol RGBA : Hashable, CustomStringConvertible, Packable {
    static var bitCount: Int { get }
    static var byteCount: Int { get }
    static var hasAlpha: Bool { get }
    var r: UInt8 { get }
    var g: UInt8 { get }
    var b: UInt8 { get }
    var a: UInt8 { get }
    var rgb: SIMD3<UInt8> { get }
    var rgba: SIMD4<UInt8> { get }
    var argb8888: ARGB8888 { get }
}

extension RGBA {
    public var rgb: SIMD3<UInt8> { return SIMD3<UInt8>(r, g, b) }
    public var rgba: SIMD4<UInt8> { return SIMD4<UInt8>(r, g, b, a) }
    public var argb8888: ARGB8888 { return ARGB8888(r: r, g: g, b: b, a: a) }
}

public struct ARGB8888 : RGBA {
    // AAAAAAAA|RRRRRRRR|GGGGGGGG|BBBBBBBB
    public let bits: UInt32
    public init(bits: UInt32) { self.bits = bits }
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        let aBits = UInt32(a) << 24
        let rBits = UInt32(r) << 16
        let gBits = UInt32(g) << 8
        let bBits = UInt32(b) << 0
        
        self.bits = aBits | rBits | gBits | bBits
    }
    public init(from dataStream: DataStream) {
        self.init(bits: UInt32(from: dataStream))
    }
    public func encode(to dataStream: DataStream) {
        bits.encode(to: dataStream)
    }
    public init(rgb: SIMD3<UInt8>, a: UInt8 = .max) {
        self.init(r: rgb.x, g: rgb.y, b: rgb.z, a: a)
    }
    public init(rgba: SIMD4<UInt8>) {
        self.init(r: rgba.x, g: rgba.y, b: rgba.z, a: rgba.w)
    }
    public var argb8888: ARGB8888 { return self }
    public static var bitCount: Int { return 32 }
    public static var byteCount: Int { return 4 }
    public static var hasAlpha: Bool { return true }
    public var r: UInt8 {
        return UInt8((bits & 0x00FF0000) >> 16)
    }
    public var g: UInt8 {
        return UInt8((bits & 0x0000FF00) >> 8)
    }
    public var b: UInt8 {
        return UInt8((bits & 0x000000FF) >> 0)
    }
    public var a: UInt8 {
        return UInt8((bits & 0xFF000000) >> 24)
    }
    public var description: String {
        return String(format: "%08X", bits)
    }
}

public struct RGB565 : RGBA {
    // RRRRR_GGG|GGG_BBBBB
    public let bits: UInt16
    public init(bits: UInt16) { self.bits = bits }
    public init(from dataStream: DataStream) {
        self.init(bits: UInt16(from: dataStream))
    }
    public func encode(to dataStream: DataStream) {
        bits.encode(to: dataStream)
    }
    public static var bitCount: Int { return 16 }
    public static var byteCount: Int { return 2 }
    public static var hasAlpha: Bool { return false }
    public var r: UInt8 {
        let bits0 = UInt8((bits & 0b11111_000000_00000) >> 11)
        return (bits0 << 3) | (bits0 >> 2)
    }
    public var g: UInt8 {
        let bits1 = UInt8((bits & 0b00000_111111_00000) >> 5)
        return (bits1 << 2) | (bits1 >> 4)
    }
    public var b: UInt8 {
        let bits2 = UInt8((bits & 0b00000_000000_11111) >> 0)
        return (bits2 << 3) | (bits2 >> 2)
    }
    public var a: UInt8 { return UInt8.max }
    public var description: String {
        return String(format: "%04X", bits)
    }
}

public struct RGB888 : RGBA {
    // RRRRRRRR|GGGGGGGG|BBBBBBBB
    public let bits: (UInt8, UInt8, UInt8)
    public init(bits: (UInt8, UInt8, UInt8)) { self.bits = bits }
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = UInt8.max) {
        self.bits = (r, g, b)
    }
    public init(from dataStream: DataStream) {
        self.init(bits: (UInt8(from: dataStream), UInt8(from: dataStream), UInt8(from: dataStream)))
    }
    public func encode(to dataStream: DataStream) {
        bits.0.encode(to: dataStream)
        bits.1.encode(to: dataStream)
        bits.2.encode(to: dataStream)
    }
    public init(rgb: SIMD3<UInt8>, a: UInt8 = .max) {
        self.init(r: rgb.x, g: rgb.y, b: rgb.z, a: a)
    }
    public static var bitCount: Int { return 24 }
    public static var byteCount: Int { return 3 }
    public static var hasAlpha: Bool { return false }
    public var r: UInt8 {
        return bits.0
    }
    public var g: UInt8 {
        return bits.1
    }
    public var b: UInt8 {
        return bits.2
    }
    public var a: UInt8 {
        return UInt8.max
    }
    public var description: String {
        return String(format: "%02X%02X%02X", r, g, b)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(bits.0)
        hasher.combine(bits.1)
        hasher.combine(bits.2)
    }
    public static func == (lhs: RGB888, rhs: RGB888) -> Bool {
        return lhs.bits.0 == rhs.bits.0 && lhs.bits.1 == rhs.bits.1 && lhs.bits.2 == rhs.bits.2
    }
}

public struct ARGB4444 : RGBA {
    // AAAA_RRRR|GGGG_BBBB
    public let bits: UInt16
    public init(bits: UInt16) { self.bits = bits }
    public init(from dataStream: DataStream) {
        self.init(bits: UInt16(from: dataStream))
    }
    public func encode(to dataStream: DataStream) {
        bits.encode(to: dataStream)
    }
    public static var bitCount: Int { return 16 }
    public static var byteCount: Int { return 2 }
    public static var hasAlpha: Bool { return true }
    public var r: UInt8 {
        let bits1 = UInt8((bits & 0b0000_1111_0000_0000) >> 8)
        return (bits1 << 4) | bits1
    }
    public var g: UInt8 {
        let bits2 = UInt8((bits & 0b0000_0000_1111_0000) >> 4)
        return (bits2 << 4) | bits2
    }
    public var b: UInt8 {
        let bits3 = UInt8((bits & 0b0000_00000000_1111) >> 0)
        return (bits3 << 4) | bits3
    }
    public var a: UInt8 {
        let bits0 = UInt8((bits & 0b1111_0000_0000_0000) >> 12)
        return (bits0 << 4) | bits0
    }
    public var description: String {
        return String(format: "%04X", bits)
    }
}

public struct BGR888 : RGBA {
    // BBBBBBBB|GGGGGGGG|RRRRRRRR
    public let bits: (UInt8, UInt8, UInt8)
    public init(bits: (UInt8, UInt8, UInt8)) { self.bits = bits }
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = UInt8.max) {
        self.bits = (b, g, r)
    }
    public init(from dataStream: DataStream) {
        self.init(bits: (UInt8(from: dataStream), UInt8(from: dataStream), UInt8(from: dataStream)))
    }
    public func encode(to dataStream: DataStream) {
        bits.0.encode(to: dataStream)
        bits.1.encode(to: dataStream)
        bits.2.encode(to: dataStream)
    }
    public static var bitCount: Int { return 24 }
    public static var byteCount: Int { return 3 }
    public static var hasAlpha: Bool { return false }
    public var r: UInt8 {
        return bits.2
    }
    public var g: UInt8 {
        return bits.1
    }
    public var b: UInt8 {
        return bits.0
    }
    public var a: UInt8 {
        return UInt8.max
    }
    public var description: String {
        return String(format: "%02X%02X%02X", b, g, r)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(bits.0)
        hasher.combine(bits.1)
        hasher.combine(bits.2)
    }
    public static func == (lhs: BGR888, rhs: BGR888) -> Bool {
        return lhs.bits.0 == rhs.bits.0 && lhs.bits.1 == rhs.bits.1 && lhs.bits.2 == rhs.bits.2
    }
}

public struct A8 : RGBA {
    // AAAAAAAA
    public let bits: UInt8
    public init(bits: UInt8) { self.bits = bits }
    public init(from dataStream: DataStream) {
        self.init(bits: UInt8(from: dataStream))
    }
    public func encode(to dataStream: DataStream) {
        bits.encode(to: dataStream)
    }
    public static var bitCount: Int { return 8 }
    public static var byteCount: Int { return 1 }
    public static var hasAlpha: Bool { return false }
    public var r: UInt8 { return bits }
    public var g: UInt8 { return UInt8.min }
    public var b: UInt8 { return UInt8.min }
    public var a: UInt8 { return UInt8.max }
    public var description: String {
        return String(format: "%02X", bits)
    }
}
