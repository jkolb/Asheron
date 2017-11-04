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

public struct DXT1Block : DXTBlock {
    let colorBlock: DXTColor
    let colors: [PixelARGB8888]
    
    public init(colorBlock: DXTColor) {
        self.colorBlock = colorBlock
        
        let alpha: UInt8
        let color0 = PixelRGB565(bits: colorBlock.color0())
        let color1 = PixelRGB565(bits: colorBlock.color1())
        
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
    
    public func color(at index: Int) -> PixelARGB8888 {
        return colors[colorBlock.colorIndex(at: index)]
    }
}
