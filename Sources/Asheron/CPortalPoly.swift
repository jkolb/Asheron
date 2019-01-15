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

public struct CPortalPoly {
    /*
     0x0001673c : Length = 210, Leaf = 0x1203 LF_FIELDLIST
     list[0] = LF_MEMBER, protected, type = T_ULONG(0022), offset = 0 member name = 'portal_index'
     list[1] = LF_MEMBER, protected, type = 0xCDD4, offset = 4 member name = 'portal'
     list[2] = LF_ONEMETHOD, public, VANILLA, index = 0x00016734, name = 'CPortalPoly'
     list[3] = LF_ONEMETHOD, public, VANILLA, index = 0x00016734, name = '~CPortalPoly'
     list[4] = LF_ONEMETHOD, public, VANILLA, index = 0x00016735, name = 'set_polygon'
     list[5] = LF_ONEMETHOD, public, VANILLA, index = 0x00016736, name = 'set_portal_index'
     list[6] = LF_ONEMETHOD, public, VANILLA, index = 0x00016739, name = 'get_polygon'
     list[7] = LF_ONEMETHOD, public, VANILLA, index = 0x0001673A, name = 'get_portal_index'
     list[8] = LF_ONEMETHOD, public, VANILLA, (compgenx), index = 0x0001673B, name = '__vecDelDtor'
     
     0x0001673d : Length = 34, Leaf = 0x1504 LF_CLASS
     # members = 9,  field list type 0x1673c, CONSTRUCTOR,
     Derivation list type 0x0000, VT shape type 0x0000
     Size = 8, class name = CPortalPoly, UDT(0x0001673d)
     */
    public var portalIndex: UInt16
    public var polygonId: UInt16
    
    public init(portalIndex: UInt16, polygonId: UInt16) {
        self.portalIndex = portalIndex
        self.polygonId = polygonId
    }
}
