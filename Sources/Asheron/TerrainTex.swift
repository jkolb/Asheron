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

public struct TerrainTex {
    public var tex: PortalId<ImgTexRef>
    // These two are in PDB but not file?
    //        public let baseTexture: UInt32 // type = 0x7920
    //        public let minSlope: Float32
    public var texTiling: UInt32
    public var maxVertBright: UInt32
    public var minVertBright: UInt32
    public var maxVertSaturate: UInt32
    public var minVertSaturate: UInt32
    public var maxVertHue: UInt32
    public var minVertHue: UInt32
    public var detailTexTiling: UInt32
    public var detailTex: PortalId<ImgTexRef>
    
    public init(
        tex: PortalId<ImgTexRef>,
        texTiling: UInt32,
        maxVertBright: UInt32,
        minVertBright: UInt32,
        maxVertSaturate: UInt32,
        minVertSaturate: UInt32,
        maxVertHue: UInt32,
        minVertHue: UInt32,
        detailTexTiling: UInt32,
        detailTex: PortalId<ImgTexRef>
        )
    {
        self.tex = tex
        self.texTiling = texTiling
        self.maxVertBright = maxVertBright
        self.minVertBright = minVertBright
        self.maxVertSaturate = maxVertSaturate
        self.minVertSaturate = minVertSaturate
        self.maxVertHue = maxVertHue
        self.minVertHue = minVertHue
        self.detailTexTiling = detailTexTiling
        self.detailTex = detailTex
    }
}
