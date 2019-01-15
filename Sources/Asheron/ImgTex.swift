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

import Lilliput

public final class ImgTex : PortalObject {
    public enum Category: UInt32 {
        case unknown   = 0
        case foilage   = 1
        case terrain   = 2
        case sky       = 3
        case player    = 4
        case monster   = 5
        case icon      = 6
        case detail    = 7
        case dungeon   = 8
        case particle  = 9
        case font      = 10
    }
    public enum Format {
        case rgb888([ColorRGB888])
        case argb8888([ColorARGB8888])
        case rgb565([ColorRGB565])
        case argb4444([ColorARGB4444])
        case a8([ColorA8])
        case p8(PortalId<Palette>, [UInt8])
        case dxt1([DXT1Block])
        case dxt3([DXT3Block])
        case dxt5([DXT5Block])
        case p16(PortalId<Palette>, [UInt16])
        case bgr888([ColorBGR888])
        case i8([ColorI8])
        case jfif(ByteBuffer)
    }
    
    public static let kind = PortalKind.imgTex
    public var portalId: PortalId<ImgTex>
    public var category: Category
    public var width: Int
    public var height: Int
    public var format: Format

    public init(portalId: PortalId<ImgTex>, category: Category, width: Int, height: Int, format: Format) {
        self.portalId = portalId
        self.category = category
        self.width = width
        self.height = height
        self.format = format
    }
}
