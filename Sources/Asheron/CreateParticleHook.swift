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

import Swiftish

public struct CreateParticleHook {
/*
     list[9] = LF_MEMBER, protected, type = 0x124C, offset = 12 member name = 'emitter_info_id'
     list[10] = LF_MEMBER, protected, type = T_ULONG(0022), offset = 16 member name = 'part_index'
     list[11] = LF_MEMBER, protected, type = 0x5E9F, offset = 20 member name = 'offset'
     list[12] = LF_MEMBER, protected, type = T_ULONG(0022), offset = 84 member name = 'emitter_id'
 */
    public var direction: CAnimHook.Direction
    public var partIndex: UInt32
    public var offset: Transform3<Float>
    public var emitterId: Handle
    
    public init(direction: CAnimHook.Direction, partIndex: UInt32, offset: Transform3<Float>, emitterId: Handle) {
        self.direction = direction
        self.partIndex = partIndex
        self.offset = offset
        self.emitterId = emitterId
    }
}
