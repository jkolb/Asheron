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

public struct CylSphere {
/*
     list[26] = LF_MEMBER, private, type = 0x1074, offset = 0 member name = 'low_pt'
     list[27] = LF_MEMBER, private, type = T_REAL32(0040), offset = 12 member name = 'height'
     list[28] = LF_MEMBER, private, type = T_REAL32(0040), offset = 16 member name = 'radius'
 */
    public var lowPt: Vector3<Float>
    public var height: Float
    public var radius: Float
    
    public init(lowPt: Vector3<Float>, height: Float, radius: Float) {
        self.lowPt = lowPt
        self.height = height
        self.radius = radius
    }
}
