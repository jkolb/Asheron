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

public protocol Pixel {
    static var bitCount: Int { get }
    static var byteCount: Int { get }
    static var hasAlpha: Bool { get }
    var r: UInt8 { get }
    var g: UInt8 { get }
    var b: UInt8 { get }
    var a: UInt8 { get }
}

extension Pixel {
    public var argb8888: ARGB8888 {
        return ARGB8888(r: r, g: g, b: b, a: a)
    }
}

public struct RGB565 : Pixel {
    // RRRRR_GGG|GGG_BBBBB
    public let bits: UInt16
    public init(bits: UInt16) { self.bits = bits }
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
}

public struct BGR565 : Pixel {
    // BBBBB_GGG|GGG_RRRRR
    public let bits: UInt16
    public init(bits: UInt16) { self.bits = bits }
    public static var bitCount: Int { return 16 }
    public static var byteCount: Int { return 2 }
    public static var hasAlpha: Bool { return false }
    public var r: UInt8 {
        let bits2 = UInt8((bits & 0b00000_000000_11111) >> 0)
        return (bits2 << 3) | (bits2 >> 2)
    }
    public var g: UInt8 {
        let bits1 = UInt8((bits & 0b00000_111111_00000) >> 5)
        return (bits1 << 2) | (bits1 >> 4)
    }
    public var b: UInt8 {
        let bits0 = UInt8((bits & 0b11111_000000_00000) >> 11)
        return (bits0 << 3) | (bits0 >> 2)
    }
    public var a: UInt8 { return UInt8.max }
}

public struct RGBA4444 : Pixel {
    // RRRR_GGGG|BBBB_AAAA
    public let bits: UInt16
    public init(bits: UInt16) { self.bits = bits }
    public static var bitCount: Int { return 16 }
    public static var byteCount: Int { return 2 }
    public static var hasAlpha: Bool { return true }
    public var r: UInt8 {
        let bits0 = UInt8((bits & 0b1111_0000_0000_0000) >> 12)
        return (bits0 << 4) | bits0
    }
    public var g: UInt8 {
        let bits1 = UInt8((bits & 0b0000_1111_0000_0000) >> 8)
        return (bits1 << 4) | bits1
    }
    public var b: UInt8 {
        let bits2 = UInt8((bits & 0b0000_0000_1111_0000) >> 4)
        return (bits2 << 4) | bits2
    }
    public var a: UInt8 {
        let bits3 = UInt8((bits & 0b0000_00000000_1111) >> 0)
        return (bits3 << 4) | bits3
    }
}

public struct ARGB4444 : Pixel {
    // AAAA_RRRR|GGGG_BBBB
    public let bits: UInt16
    public init(bits: UInt16) { self.bits = bits }
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
    public var rgba4444: RGBA4444 {
        let rBits = (bits & 0b0000_1111_0000_0000) << 4
        let gBits = (bits & 0b0000_0000_1111_0000) << 4
        let bBits = (bits & 0b0000_00000000_1111) << 4
        let aBits = (bits & 0b1111_0000_0000_0000) >> 12
        return RGBA4444(bits: rBits | gBits | bBits | aBits)
    }
}

public struct ARGB8888 : Pixel {
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
}

public struct BGR888 : Pixel {
    public let bits: UInt32
    public init(bits: UInt32) { self.bits = bits }
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = UInt8.max) {
        let bBits = UInt32(b) << 16
        let gBits = UInt32(g) << 8
        let rBits = UInt32(r) << 0
        
        self.bits = bBits | gBits | rBits
    }
    public static var bitCount: Int { return 24 }
    public static var byteCount: Int { return 3 }
    public static var hasAlpha: Bool { return false }
    public var r: UInt8 {
        return UInt8((bits & 0x000000FF) >> 0)
    }
    public var g: UInt8 {
        return UInt8((bits & 0x0000FF00) >> 8)
    }
    public var b: UInt8 {
        return UInt8((bits & 0x00FF0000) >> 16)
    }
    public var a: UInt8 {
        return UInt8.max
    }
}

public struct RGB888 : Pixel {
    public let bits: UInt32
    public init(bits: UInt32) { self.bits = bits }
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = UInt8.max) {
        let rBits = UInt32(r) << 16
        let gBits = UInt32(g) << 8
        let bBits = UInt32(b) << 0
        
        self.bits = bBits | gBits | rBits
    }
    public static var bitCount: Int { return 24 }
    public static var byteCount: Int { return 3 }
    public static var hasAlpha: Bool { return false }
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
        return UInt8.max
    }
}

public struct I8 : Pixel {
    public let bits: UInt8
    public init(bits: UInt8) { self.bits = bits }
    public static var bitCount: Int { return 8 }
    public static var byteCount: Int { return 1 }
    public static var hasAlpha: Bool { return false }
    public var r: UInt8 { return bits }
    public var g: UInt8 { return bits }
    public var b: UInt8 { return bits }
    public var a: UInt8 { return bits }
}
