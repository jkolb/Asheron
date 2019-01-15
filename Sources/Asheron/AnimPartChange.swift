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

public struct AnimPartChange {
/*
     list[3] = LF_MEMBER, public, type = T_UINT4(0075), offset = 4
     member name = 'part_index'
     list[4] = LF_MEMBER, public, type = 0x124C, offset = 8
     member name = 'part_id'
     list[5] = LF_MEMBER, public, type = 0x7E72, offset = 12
     member name = 'prev'
     list[6] = LF_MEMBER, public, type = 0x7E72, offset = 16
     member name = 'next'
 */
    public var partIndex: UInt8
    public var partId: PortalId<CGfxObj>
    
    public init(partIndex: UInt8, partId: PortalId<CGfxObj>) {
        self.partIndex = partIndex
        self.partId = partId
    }
}
