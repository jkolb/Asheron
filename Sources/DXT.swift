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

/*
 Compressed Texture Resources (Direct3D 9)
 https://msdn.microsoft.com/en-us/library/bb204843(v=vs.85).aspx
 FOURCC Description         Alpha premultiplied?
 DXT1   Opaque/1-bit alpha  N/A
 DXT2   Explicit alpha      Yes
 DXT3   Explicit alpha      No
 DXT4   Interpolated alpha  Yes
 DXT5   Interpolated alpha  No
 */
public struct DXT3Alpha {
    let bits: UInt64
    
    public init(bits: UInt64) {
        self.bits = bits
    }
    
    public func alpha(at index: Int) -> UInt8 {
        let shift = UInt64(index) << 2
        return UInt8((bits & (0b1111 << shift)) >> shift) << 4
    }
}

public struct DXT5Alpha {
    let bits: UInt64
    
    init(bits: UInt64) {
        self.bits = bits
    }
    
    public func alpha0() -> UInt8 {
        return UInt8((bits & (0xFF << 0)) >> 0)
    }
    
    public func alpha1() -> UInt8 {
        return UInt8((bits & (0xFF << 8)) >> 8)
    }
    
    public func alphaIndex(at index: Int) -> Int {
        let shift = (UInt64(index) << 1) + UInt64(index) + 16
        return Int((bits & (0b111 << shift)) >> shift)
    }
}

public struct DXTColor {
    let bits: UInt64
    
    public init(bits: UInt64) {
        self.bits = bits
    }
    
    public func color0() -> UInt16 {
        return UInt16((bits & (0xFFFF << 0)) >> 0)
    }
    
    public func color1() -> UInt16 {
        return UInt16((bits & (0xFFFF << 16)) >> 16)
    }
    
    public func colorIndex(at index: Int) -> Int {
        let shift = (UInt64(index) << 1) + 32
        return Int((bits & (0b11 << shift)) >> shift)
    }
}

public protocol DXTBlock {
    func color(at index: Int) -> ARGB8888
}

fileprivate struct RGBTriplet {
    private let r: Int
    private let g: Int
    private let b: Int

    fileprivate init() {
        self.r = 0
        self.g = 0
        self.b = 0
    }

    fileprivate init(_ r: Int, _ g: Int, _ b: Int) {
        self.r = r
        self.g = g
        self.b = b
    }

    fileprivate init(_ pixel: Pixel) {
        self.r = Int(pixel.r)
        self.g = Int(pixel.g)
        self.b = Int(pixel.b)
    }

    fileprivate static func +(x: RGBTriplet, y: RGBTriplet) -> RGBTriplet {
        return RGBTriplet(x.r + y.r, x.g + y.g, x.b + y.b)
    }

    fileprivate static func +(x: RGBTriplet, y: Int) -> RGBTriplet {
        return RGBTriplet(x.r + y, x.g + y, x.b + y)
    }

    fileprivate static func +(x: Int, y: RGBTriplet) -> RGBTriplet {
        return RGBTriplet(x + y.r, x + y.g, x + y.b)
    }

    fileprivate static func *(x: RGBTriplet, y: Int) -> RGBTriplet {
        return RGBTriplet(x.r * y, x.g * y, x.b * y)
    }

    fileprivate static func *(x: Int, y: RGBTriplet) -> RGBTriplet {
        return RGBTriplet(x * y.r, x * y.g, x * y.b)
    }

    fileprivate static func /(x: RGBTriplet, y: Int) -> RGBTriplet {
        return RGBTriplet(x.r / y, x.g / y, x.b / y)
    }

    fileprivate static func /(x: Int, y: RGBTriplet) -> RGBTriplet {
        return RGBTriplet(x / y.r, x / y.g, x / y.b)
    }

    fileprivate func color(alpha: UInt8) -> ARGB8888 {
        return ARGB8888(r: UInt8(r), g: UInt8(g), b: UInt8(b), a: alpha)
    }

    fileprivate var color: RGB888 {
        return RGB888(r: UInt8(r), g: UInt8(g), b: UInt8(b))
    }
}

public struct DXT1Block : DXTBlock {
    let colorBlock: DXTColor
    let colors: [ARGB8888]
    
    public init(colorBlock: DXTColor) {
        self.colorBlock = colorBlock
        
        let alpha: UInt8
        let color0 = RGB565(bits: colorBlock.color0())
        let color1 = RGB565(bits: colorBlock.color1())
        
        let rgb0 = RGBTriplet(color0)
        let rgb1 = RGBTriplet(color1)
        let rgb2: RGBTriplet
        let rgb3: RGBTriplet
        
        if color0.bits > color1.bits {
            rgb2 = (2 * rgb0 + rgb1 + 1) / 3
            rgb3 = (rgb0 + 2 * rgb1 + 1) / 3
            alpha = UInt8.max
        }
        else {
            rgb2 = (rgb0 + rgb1) / 2
            rgb3 = RGBTriplet()
            alpha = 0
        }

        self.colors = [
            rgb0.color(alpha: UInt8.max),
            rgb1.color(alpha: UInt8.max),
            rgb2.color(alpha: UInt8.max),
            rgb3.color(alpha: alpha),
        ]
    }
    
    public func color(at index: Int) -> ARGB8888 {
        return colors[colorBlock.colorIndex(at: index)]
    }
}

public struct DXT3Block : DXTBlock {
    let alphaBlock: DXT3Alpha
    let colorBlock: DXTColor
    let colors: [RGB888]

    public init(alphaBlock: DXT3Alpha, colorBlock: DXTColor) {
        self.alphaBlock = alphaBlock
        self.colorBlock = colorBlock

        let color0 = RGB565(bits: colorBlock.color0())
        let color1 = RGB565(bits: colorBlock.color1())
        
        let rgb0 = RGBTriplet(color0)
        let rgb1 = RGBTriplet(color1)
        let rgb2 = (2 * rgb0 + rgb1 + 1) / 3
        let rgb3 = (rgb0 + 2 * rgb1 + 1) / 3
        
        self.colors = [
            rgb0.color,
            rgb1.color,
            rgb2.color,
            rgb3.color,
        ]
    }
    
    public func color(at index: Int) -> ARGB8888 {
        let color = colors[colorBlock.colorIndex(at: index)]
        return ARGB8888(r: color.r, g: color.g, b: color.b, a: alphaBlock.alpha(at: index))
    }
}

public struct DXT5Block : DXTBlock {
    let alphaBlock: DXT5Alpha
    let colorBlock: DXTColor
    let alpha: [UInt8]
    let colors: [RGB888]
    
    public init(alphaBlock: DXT5Alpha, colorBlock: DXTColor) {
        self.alphaBlock = alphaBlock
        self.colorBlock = colorBlock
        
        let alpha0 = alphaBlock.alpha0()
        let alpha1 = alphaBlock.alpha1()
        
        if alpha0 > alpha1 {
            self.alpha = [
                alpha0,
                alpha1,
                UInt8((6 * Int(alpha0) + 1 * Int(alpha1) + 3) / 7),
                UInt8((5 * Int(alpha0) + 2 * Int(alpha1) + 3) / 7),
                UInt8((4 * Int(alpha0) + 3 * Int(alpha1) + 3) / 7),
                UInt8((3 * Int(alpha0) + 4 * Int(alpha1) + 3) / 7),
                UInt8((2 * Int(alpha0) + 5 * Int(alpha1) + 3) / 7),
                UInt8((1 * Int(alpha0) + 6 * Int(alpha1) + 3) / 7),
            ]
        }
        else {
            self.alpha = [
                alpha0,
                alpha1,
                UInt8((4 * Int(alpha0) + 1 * Int(alpha1) + 2) / 5),
                UInt8((3 * Int(alpha0) + 2 * Int(alpha1) + 2) / 5),
                UInt8((2 * Int(alpha0) + 3 * Int(alpha1) + 2) / 5),
                UInt8((1 * Int(alpha0) + 4 * Int(alpha1) + 2) / 5),
                0,
                255,
            ]
        }

        let color0 = RGB565(bits: colorBlock.color0())
        let color1 = RGB565(bits: colorBlock.color1())
        
        let rgb0 = RGBTriplet(color0)
        let rgb1 = RGBTriplet(color1)
        let rgb2 = (2 * rgb0 + rgb1 + 1) / 3
        let rgb3 = (rgb0 + 2 * rgb1 + 1) / 3
        
        self.colors = [
            rgb0.color,
            rgb1.color,
            rgb2.color,
            rgb3.color,
        ]
    }
    
    public func color(at index: Int) -> ARGB8888 {
        let color = colors[colorBlock.colorIndex(at: index)]
        return ARGB8888(r: color.r, g: color.g, b: color.b, a: alpha[alphaBlock.alphaIndex(at: index)])
    }
}

public final class DXT {
    public static func decompress<Reader: DXTReader>(width: Int, height: Int, data: ByteBuffer, reader: Reader) -> ByteBuffer {
        let outputSize = width * height * ARGB8888.byteCount
        let outputStream = ByteStream(buffer: ByteBuffer(count: outputSize))
        let inputStream = ByteStream(buffer: data)
        
        let blockSize = 4
        let blocksWide = width / blockSize
        let blocksTall = height / blockSize
        var blockCache = Array<Reader.DXTBlockType>()
        blockCache.reserveCapacity(blocksWide)
        
        for _ in 1...blocksTall {
            blockCache.removeAll(keepingCapacity: true)
            
            for _ in 1...blocksWide {
                let block = reader.read(inputStream)
                blockCache.append(block)
            }
            
            for index in 0..<blockSize {
                let offset = index * blockSize
                
                for block in blockCache {
                    outputStream.putUInt32(block.color(at: 0 + offset).bits)
                    outputStream.putUInt32(block.color(at: 1 + offset).bits)
                    outputStream.putUInt32(block.color(at: 2 + offset).bits)
                    outputStream.putUInt32(block.color(at: 3 + offset).bits)
                }
            }
        }
        
        return outputStream.buffer
    }
}