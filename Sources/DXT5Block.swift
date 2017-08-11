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

public struct DXT5Block : DXTBlock {
    let alphaBlock: DXT5Alpha
    let colorBlock: DXTColor
    let alpha: [UInt8]
    let colors: [PixelRGB888]
    
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

        let color0 = PixelRGB565(bits: colorBlock.color0())
        let color1 = PixelRGB565(bits: colorBlock.color1())
        
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
    
    public func color(at index: Int) -> PixelARGB8888 {
        let color = colors[colorBlock.colorIndex(at: index)]
        return PixelARGB8888(r: color.r, g: color.g, b: color.b, a: alpha[alphaBlock.alphaIndex(at: index)])
    }
}
