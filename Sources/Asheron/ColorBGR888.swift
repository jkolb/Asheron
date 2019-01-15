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

public struct ColorBGR888 : Color {
    // BBBBBBBB|GGGGGGGG|RRRRRRRR
    public let bits: (UInt8, UInt8, UInt8)
    public init(bits: (UInt8, UInt8, UInt8)) { self.bits = bits }
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = UInt8.max) {
        self.bits = (b, g, r)
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
        return hex(b) + hex(g) + hex(r)
    }
}
