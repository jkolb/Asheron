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

public enum LightType : Int32 {
    case INVALID_LIGHT_TYPE = -1
    case POINT_LIGHT = 0
    case DISTANT_LIGHT = 1
    case SPOT_LIGHT = 2
}

public struct LightInfo {
    /*
     list[24] = LF_MEMBER, protected, type = T_INT4(0074), offset = 0 member name = 'type'
     list[25] = LF_MEMBER, protected, type = 0x5E9F, offset = 4 member name = 'offset'
     list[26] = LF_MEMBER, protected, type = 0x4CD1, offset = 68 member name = 'viewerspace_location'
     list[27] = LF_MEMBER, protected, type = 0x7282, offset = 80 member name = 'color'
     list[28] = LF_MEMBER, protected, type = T_REAL32(0040), offset = 92 member name = 'intensity'
     list[29] = LF_MEMBER, protected, type = T_REAL32(0040), offset = 96 member name = 'falloff'
     list[30] = LF_MEMBER, protected, type = T_REAL32(0040), offset = 100 member name = 'cone_angle'
     */
    public var type: LightType
    public var offset: Transform3<Float>
    public var color: ColorARGB8888 // RGBColor
    public var intensity: Float
    public var falloff: Float
    public var coneAngle: Float
    
    public init(type: LightType, offset: Transform3<Float>, color: ColorARGB8888, intensity: Float, falloff: Float, coneAngle: Float) {
        self.type = type
        self.offset = offset
        self.color = color
        self.intensity = intensity
        self.falloff = falloff
        self.coneAngle = coneAngle
    }
}
