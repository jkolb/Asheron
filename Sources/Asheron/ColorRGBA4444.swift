/*
 The MIT License (MIT)
 
 Copyright (c) 2018 Justin Kolb
 
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

public struct ColorRGBA4444 : Color {
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
    public var description: String {
        return hex(bits)
    }
}
