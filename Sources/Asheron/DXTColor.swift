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