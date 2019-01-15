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

public struct AnimFrame {
    /*
     list[0] = LF_MEMBER, public, type = 0x00012189, offset = 0 member name = 'frame'
     list[1] = LF_MEMBER, public, type = T_ULONG(0022), offset = 4 member name = 'num_frame_hooks'
     list[2] = LF_MEMBER, public, type = 0x00011A07, offset = 8 member name = 'hooks'
     list[3] = LF_MEMBER, public, type = T_ULONG(0022), offset = 12 member name = 'num_parts'
     */
    
    public var frame: [Transform3<Float>]
    public var hooks: [CAnimHook]
    
    public init(frame: [Transform3<Float>], hooks: [CAnimHook]) {
        self.frame = frame
        self.hooks = hooks
    }
}
