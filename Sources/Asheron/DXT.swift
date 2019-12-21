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

public protocol DXTBlock : Packable {
    static var byteCount: Int { get }
    func color(at index: Int) -> ARGB8888
}

public struct DXTColor : Packable {
    public init(from dataStream: DataStream) {
        self.init(bits: UInt64(from: dataStream))
    }
    
    public func encode(to dataStream: DataStream) {
        bits.encode(to: dataStream)
    }
    
    public let bits: UInt64
    
    public init(bits: UInt64) {
        self.bits = bits
    }
    
    public var color0: RGB565 {
        return RGB565(bits: UInt16((bits & (0xFFFF << 0)) >> 0))
    }
    
    public var color1: RGB565 {
        return RGB565(bits: UInt16((bits & (0xFFFF << 16)) >> 16))
    }
    
    public func colorIndex(at index: Int) -> Int {
        let shift = (UInt64(index) << 1) + 32
        return Int((bits & (0b11 << shift)) >> shift)
    }
}

public struct DXT1Block : DXTBlock {
    public static var byteCount: Int {
        return MemoryLayout<DXTColor>.size
    }
    
    let colorBlock: DXTColor
    let colors: [ARGB8888]
    
    public init(colorBlock: DXTColor) {
        self.colorBlock = colorBlock
        
        let alpha: UInt8
        let color0 = colorBlock.color0
        let color1 = colorBlock.color1
        
        let rgb0: SIMD3<Int> = SIMD3<Int>(clamping: color0.rgb)
        let rgb1: SIMD3<Int> = SIMD3<Int>(clamping: color1.rgb)
        let rgb2: SIMD3<Int>
        let rgb3: SIMD3<Int>
        
        if color0.bits > color1.bits {
            rgb2 = (2 &* rgb0 &+ rgb1 &+ 1) / 3
            rgb3 = (rgb0 &+ 2 &* rgb1 &+ 1) / 3
            alpha = UInt8.max
        }
        else {
            rgb2 = (rgb0 &+ rgb1) / 2
            rgb3 = .zero
            alpha = 0
        }
        
        self.colors = [
            ARGB8888(rgb: SIMD3<UInt8>(clamping: rgb0), a: .max),
            ARGB8888(rgb: SIMD3<UInt8>(clamping: rgb1), a: .max),
            ARGB8888(rgb: SIMD3<UInt8>(clamping: rgb2), a: .max),
            ARGB8888(rgb: SIMD3<UInt8>(clamping: rgb3), a: alpha),
        ]
    }
    
    public init(from dataStream: DataStream) {
        self.init(colorBlock: DXTColor(from: dataStream))
    }
    
    public func encode(to dataStream: DataStream) {
        colorBlock.encode(to: dataStream)
    }
    
    public func color(at index: Int) -> ARGB8888 {
        return colors[colorBlock.colorIndex(at: index)]
    }
}

public struct DXT3Alpha : Packable {
    public let bits: UInt64
    
    public init(bits: UInt64) {
        self.bits = bits
    }
    
    public init(from dataStream: DataStream) {
        self.init(bits: UInt64(from: dataStream))
    }
    
    public func encode(to dataStream: DataStream) {
        bits.encode(to: dataStream)
    }
    
    public func alpha(at index: Int) -> UInt8 {
        let shift = UInt64(index) << 2
        return UInt8((bits & (0b1111 << shift)) >> shift) << 4
    }
}

public struct DXT3Block : DXTBlock {
    public static var byteCount: Int {
        return MemoryLayout<DXT3Alpha>.size + MemoryLayout<DXTColor>.size
    }
    
    let alphaBlock: DXT3Alpha
    let colorBlock: DXTColor
    let colors: [RGB888]
    
    public init(alphaBlock: DXT3Alpha, colorBlock: DXTColor) {
        self.alphaBlock = alphaBlock
        self.colorBlock = colorBlock
        
        let color0 = colorBlock.color0
        let color1 = colorBlock.color1

        let rgb0: SIMD3<Int> = SIMD3<Int>(clamping: color0.rgb)
        let rgb1: SIMD3<Int> = SIMD3<Int>(clamping: color1.rgb)
        let rgb2: SIMD3<Int> = (2 &* rgb0 &+ rgb1 &+ 1) / 3
        let rgb3: SIMD3<Int> = (rgb0 &+ 2 &* rgb1 &+ 1) / 3
        
        self.colors = [
            RGB888(rgb: SIMD3<UInt8>(clamping: rgb0)),
            RGB888(rgb: SIMD3<UInt8>(clamping: rgb1)),
            RGB888(rgb: SIMD3<UInt8>(clamping: rgb2)),
            RGB888(rgb: SIMD3<UInt8>(clamping: rgb3)),
        ]
    }
    
    public init(from dataStream: DataStream) {
        self.init(alphaBlock: DXT3Alpha(from: dataStream), colorBlock: DXTColor(from: dataStream))
    }
    
    public func encode(to dataStream: DataStream) {
        alphaBlock.encode(to: dataStream)
        colorBlock.encode(to: dataStream)
    }
    
    public func color(at index: Int) -> ARGB8888 {
        let color = colors[colorBlock.colorIndex(at: index)]
        return ARGB8888(r: color.r, g: color.g, b: color.b, a: alphaBlock.alpha(at: index))
    }
}

public struct DXT5Alpha {
    public let bits: UInt64
    
    public init(bits: UInt64) {
        self.bits = bits
    }
    
    public init(from dataStream: DataStream) {
        self.init(bits: UInt64(from: dataStream))
    }
    
    public func encode(to dataStream: DataStream) {
        bits.encode(to: dataStream)
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

public struct DXT5Block : DXTBlock {
    public static var byteCount: Int {
        return MemoryLayout<DXT5Alpha>.size + MemoryLayout<DXTColor>.size
    }
    
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
            let alpha2 = UInt8((6 * Int(alpha0) + 1 * Int(alpha1) + 3) / 7)
            let alpha3 = UInt8((5 * Int(alpha0) + 2 * Int(alpha1) + 3) / 7)
            let alpha4 = UInt8((4 * Int(alpha0) + 3 * Int(alpha1) + 3) / 7)
            let alpha5 = UInt8((3 * Int(alpha0) + 4 * Int(alpha1) + 3) / 7)
            let alpha6 = UInt8((2 * Int(alpha0) + 5 * Int(alpha1) + 3) / 7)
            let alpha7 = UInt8((1 * Int(alpha0) + 6 * Int(alpha1) + 3) / 7)
            
            self.alpha = [alpha0, alpha1, alpha2, alpha3, alpha4, alpha5, alpha6, alpha7]
        }
        else {
            let alpha2 = UInt8((4 * Int(alpha0) + 1 * Int(alpha1) + 2) / 5)
            let alpha3 = UInt8((3 * Int(alpha0) + 2 * Int(alpha1) + 2) / 5)
            let alpha4 = UInt8((2 * Int(alpha0) + 3 * Int(alpha1) + 2) / 5)
            let alpha5 = UInt8((1 * Int(alpha0) + 4 * Int(alpha1) + 2) / 5)
            let alpha6 = UInt8(0)
            let alpha7 = UInt8(255)
            
            self.alpha = [alpha0, alpha1, alpha2, alpha3, alpha4, alpha5, alpha6, alpha7]
        }
        
        let color0 = colorBlock.color0
        let color1 = colorBlock.color1

        let rgb0: SIMD3<Int> = SIMD3<Int>(clamping: color0.rgb)
        let rgb1: SIMD3<Int> = SIMD3<Int>(clamping: color1.rgb)
        let rgb2: SIMD3<Int> = (2 &* rgb0 &+ rgb1 &+ 1) / 3
        let rgb3: SIMD3<Int> = (rgb0 &+ 2 &* rgb1 &+ 1) / 3
        
        self.colors = [
            RGB888(rgb: SIMD3<UInt8>(clamping: rgb0)),
            RGB888(rgb: SIMD3<UInt8>(clamping: rgb1)),
            RGB888(rgb: SIMD3<UInt8>(clamping: rgb2)),
            RGB888(rgb: SIMD3<UInt8>(clamping: rgb3)),
        ]
    }
    
    public init(from dataStream: DataStream) {
        self.init(alphaBlock: DXT5Alpha(from: dataStream), colorBlock: DXTColor(from: dataStream))
    }
    
    public func encode(to dataStream: DataStream) {
        alphaBlock.encode(to: dataStream)
        colorBlock.encode(to: dataStream)
    }
    
    public func color(at index: Int) -> ARGB8888 {
        let color = colors[colorBlock.colorIndex(at: index)]
        return ARGB8888(r: color.r, g: color.g, b: color.b, a: alpha[alphaBlock.alphaIndex(at: index)])
    }
}
