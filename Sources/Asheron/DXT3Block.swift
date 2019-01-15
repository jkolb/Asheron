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

import Swiftish

public struct DXT3Block : DXTBlock {
    public static var byteCount: Int {
        return MemoryLayout<DXT3Alpha>.size + MemoryLayout<DXTColor>.size
    }
    
    let alphaBlock: DXT3Alpha
    let colorBlock: DXTColor
    let colors: [ColorRGB888]
    
    public init(alphaBlock: DXT3Alpha, colorBlock: DXTColor) {
        self.alphaBlock = alphaBlock
        self.colorBlock = colorBlock
        
        let color0 = ColorRGB565(bits: colorBlock.color0())
        let color1 = ColorRGB565(bits: colorBlock.color1())
        
        let rgb0: IntVector3<Int> = IntVector3<Int>(color0)
        let rgb1: IntVector3<Int> = IntVector3<Int>(color1)
        let rgb2: IntVector3<Int> = (2 * rgb0 + rgb1 + 1) / 3
        let rgb3: IntVector3<Int> = (rgb0 + 2 * rgb1 + 1) / 3
        
        self.colors = [
            IntVector3<UInt8>(rgb0).colorRGB888,
            IntVector3<UInt8>(rgb1).colorRGB888,
            IntVector3<UInt8>(rgb2).colorRGB888,
            IntVector3<UInt8>(rgb3).colorRGB888,
        ]
    }
    
    public func color(at index: Int) -> ColorARGB8888 {
        let color = colors[colorBlock.colorIndex(at: index)]
        return ColorARGB8888(r: color.r, g: color.g, b: color.b, a: alphaBlock.alpha(at: index))
    }
}
