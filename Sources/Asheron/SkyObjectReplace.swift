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

public struct SkyObjectReplace {
    public var objectIndex: UInt32
    public var gfxObjID: Handle
    public var rotate: Float
    public var transparent: Float
    public var luminosity: Float
    public var maxBright: Float
    //public var object: UInt32 // Temp
    
    public init(
        objectIndex: UInt32,
        gfxObjID: Handle,
        rotate: Float,
        transparent: Float,
        luminosity: Float,
        maxBright: Float
        )
    {
        self.objectIndex = objectIndex
        self.gfxObjID = gfxObjID
        self.rotate = rotate
        self.transparent = transparent
        self.luminosity = luminosity
        self.maxBright = maxBright
    }
}
