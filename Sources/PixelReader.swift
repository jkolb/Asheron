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

public protocol PixelReader {
    associatedtype PixelType : Pixel
    func read(_ buffer: ByteStream) -> PixelType
}

public struct RGB565Reader : PixelReader {
    public func read(_ buffer: ByteStream) -> RGB565 {
        return RGB565(bits: buffer.getUInt16())
    }
}

public struct BGR565Reader : PixelReader {
    public func read(_ buffer: ByteStream) -> BGR565 {
        return BGR565(bits: buffer.getUInt16())
    }
}

public struct RGBA4444Reader : PixelReader {
    public func read(_ buffer: ByteStream) -> RGBA4444 {
        return RGBA4444(bits: buffer.getUInt16())
    }
}

public struct ARGB4444Reader : PixelReader {
    public func read(_ buffer: ByteStream) -> ARGB4444 {
        return ARGB4444(bits: buffer.getUInt16())
    }
}

public struct ARGB8888Reader : PixelReader {
    public func read(_ buffer: ByteStream) -> ARGB8888 {
        return ARGB8888(bits: buffer.getUInt32())
    }
}

public struct BGR888Reader : PixelReader {
    public func read(_ buffer: ByteStream) -> BGR888 {
        return BGR888(bits: buffer.getUInt24())
    }
}

public struct RGB888Reader : PixelReader {
    public func read(_ buffer: ByteStream) -> RGB888 {
        return RGB888(bits: buffer.getUInt24())
    }
}

public struct I8Reader : PixelReader {
    public func read(_ buffer: ByteStream) -> I8 {
        return I8(bits: buffer.getUInt8())
    }
}

public struct A8Reader : PixelReader {
    public func read(_ buffer: ByteStream) -> A8 {
        return A8(bits: buffer.getUInt8())
    }
}

public struct P16Reader : PixelReader {
    private let colorTable: ColorTable
    
    public init(colorTable: ColorTable) {
        self.colorTable = colorTable
    }
    
    public func read(_ buffer: ByteStream) -> ARGB8888 {
        let index = buffer.getUInt16()
        return colorTable[index]
    }
}

public struct P8Reader : PixelReader {
    private let colorTable: ColorTable
    
    public init(colorTable: ColorTable) {
        self.colorTable = colorTable
    }
    
    public func read(_ buffer: ByteStream) -> ARGB8888 {
        let index = buffer.getUInt8()
        return colorTable[index]
    }
}
