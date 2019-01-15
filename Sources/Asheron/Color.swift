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

import Swiftish

public protocol Color : CustomStringConvertible {
    static var bitCount: Int { get }
    static var byteCount: Int { get }
    static var hasAlpha: Bool { get }
    var r: UInt8 { get }
    var g: UInt8 { get }
    var b: UInt8 { get }
    var a: UInt8 { get }
}

extension Color {
    public var colorARGB8888: ColorARGB8888 {
        return ColorARGB8888(r: r, g: g, b: b, a: a)
    }
}

extension IntVector3 {
    public init(_ color: Color) {
        self.init(T(color.r), T(color.g), T(color.b))
    }
}

extension IntVector4 {
    public init(_ color: Color) {
        self.init(T(color.r), T(color.g), T(color.b), T(color.a))
    }
}

extension IntVector3 where T == UInt8 {
    public var colorRGB888: ColorRGB888 {
        return ColorRGB888(r: r, g: g, b: b)
    }
    
    public var colorARGB8888: ColorARGB8888 {
        return ColorARGB8888(r: r, g: g, b: b, a: UInt8.max)
    }
    
    public func colorARGB8888(alpha: UInt8) -> ColorARGB8888 {
        return ColorARGB8888(r: r, g: g, b: b, a: alpha)
    }
}

extension IntVector4 where T == UInt8 {
    public var colorRGB888: ColorRGB888 {
        return ColorRGB888(r: r, g: g, b: b)
    }
    
    public var colorARGB8888: ColorARGB8888 {
        return ColorARGB8888(r: r, g: g, b: b, a: a)
    }
}
