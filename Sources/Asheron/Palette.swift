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

public protocol PaletteIndex {
    var indexValue: Int { get }
}

extension UInt8 : PaletteIndex {
    public var indexValue: Int {
        return Int(self)
    }
}

extension UInt16 : PaletteIndex {
    public var indexValue: Int {
        return Int(self)
    }
}

public final class Palette : PortalObject {
    /*
     list[1] = LF_MEMBER, protected, type = T_ULONG(0022), offset = 56 member name = 'num_colors'
     list[2] = LF_MEMBER, protected, type = T_REAL32(0040), offset = 60 member name = 'min_lighting'
     list[3] = LF_MEMBER, protected, type = T_32PULONG(0422), offset = 64 member name = 'ARGB'
     */
    public static let kind = PortalKind.palette
    public var portalId: PortalId<Palette>
    public var argb: [ColorARGB8888]
    
    public init(portalId: PortalId<Palette>, argb: [ColorARGB8888]) {
        self.portalId = portalId
        self.argb = argb
    }
    
    public subscript (index: Int) -> ColorARGB8888 {
        return argb[index]
    }
    
    public subscript (paletteIndex: PaletteIndex) -> ColorARGB8888 {
        return self[paletteIndex.indexValue]
    }
}
