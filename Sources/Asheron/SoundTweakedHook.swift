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

public struct SoundTweakedHook {
/*
     list[9] = LF_MEMBER, protected, type = 0x124C, offset = 12 member name = 'gid_'
     list[10] = LF_MEMBER, protected, type = T_REAL32(0040), offset = 16 member name = 'prio'
     list[11] = LF_MEMBER, protected, type = T_REAL32(0040), offset = 20 member name = 'prob'
     list[12] = LF_MEMBER, protected, type = T_REAL32(0040), offset = 24 member name = 'vol'
 */
    public var direction: CAnimHook.Direction
    public var gid: Handle
    public var prio: Float
    public var prob: Float
    public var vol: Float
    
    public init(direction: CAnimHook.Direction, gid: Handle, prio: Float, prob: Float, vol: Float) {
        self.direction = direction
        self.gid = gid
        self.prio = prio
        self.prob = prob
        self.vol = vol
    }
}
