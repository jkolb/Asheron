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

public struct RGBTriplet {
    private let r: Int
    private let g: Int
    private let b: Int
    
    public init() {
        self.init(0, 0, 0)
    }
    
    public init(_ pixel: Pixel) {
        self.init(Int(pixel.r), Int(pixel.g), Int(pixel.b))
    }
    
    public init(_ r: Int, _ g: Int, _ b: Int) {
        self.r = r
        self.g = g
        self.b = b
    }
    
    public static func +(x: RGBTriplet, y: RGBTriplet) -> RGBTriplet {
        return RGBTriplet(x.r + y.r, x.g + y.g, x.b + y.b)
    }
    
    public static func +(x: RGBTriplet, y: Int) -> RGBTriplet {
        return RGBTriplet(x.r + y, x.g + y, x.b + y)
    }
    
    public static func +(x: Int, y: RGBTriplet) -> RGBTriplet {
        return RGBTriplet(x + y.r, x + y.g, x + y.b)
    }
    
    public static func *(x: RGBTriplet, y: Int) -> RGBTriplet {
        return RGBTriplet(x.r * y, x.g * y, x.b * y)
    }
    
    public static func *(x: Int, y: RGBTriplet) -> RGBTriplet {
        return RGBTriplet(x * y.r, x * y.g, x * y.b)
    }
    
    public static func /(x: RGBTriplet, y: Int) -> RGBTriplet {
        return RGBTriplet(x.r / y, x.g / y, x.b / y)
    }
    
    public static func /(x: Int, y: RGBTriplet) -> RGBTriplet {
        return RGBTriplet(x / y.r, x / y.g, x / y.b)
    }
    
    public func color(alpha: UInt8) -> PixelARGB8888 {
        return PixelARGB8888(r: UInt8(r), g: UInt8(g), b: UInt8(b), a: alpha)
    }
    
    public var color: PixelRGB888 {
        return PixelRGB888(r: UInt8(r), g: UInt8(g), b: UInt8(b))
    }
}
