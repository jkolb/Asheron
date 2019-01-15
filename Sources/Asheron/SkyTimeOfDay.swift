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

public struct SkyTimeOfDay {
    public var begin: Float
    public var dirBright: Float
    public var dirHeading: Float
    public var dirPitch: Float
    public var dirColor: ColorARGB8888
    public var ambBright: Float
    public var ambColor: ColorARGB8888
    public var minWorldFog: Float
    public var maxWorldFog: Float
    public var worldFogColor: ColorARGB8888
    public var worldFog: UInt32
    public var skyObjReplace: [SkyObjectReplace]
    
    public init(
        begin: Float,
        dirBright: Float,
        dirHeading: Float,
        dirPitch: Float,
        dirColor: ColorARGB8888,
        ambBright: Float,
        ambColor: ColorARGB8888,
        minWorldFog: Float,
        maxWorldFog: Float,
        worldFogColor: ColorARGB8888,
        worldFog: UInt32,
        skyObjReplace: [SkyObjectReplace]
        )
    {
        self.begin = begin
        self.dirBright = dirBright
        self.dirHeading = dirHeading
        self.dirPitch = dirPitch
        self.dirColor = dirColor
        self.ambBright = ambBright
        self.ambColor = ambColor
        self.minWorldFog = minWorldFog
        self.maxWorldFog = maxWorldFog
        self.worldFogColor = worldFogColor
        self.worldFog = worldFog
        self.skyObjReplace = skyObjReplace
    }
}
