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

public struct PixelBGR565 : Pixel {
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
    public var description: String {
        return hex(bits)
    }
}
