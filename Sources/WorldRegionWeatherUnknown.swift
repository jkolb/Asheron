/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Justin Kolb
 
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

public struct WorldRegionWeatherUnknown {
    public let unknown1: [Float] // x4
    public let color1: PixelARGB8888
    public let unknown2: Float
    public let color2: PixelARGB8888
    public let unknown3: [Float] // x2
    public let color3: PixelARGB8888
    public let unknown4: UInt32
    public let unknowns2: [WorldRegionWeatherUnknown2]

    public init(unknown1: [Float], color1: PixelARGB8888, unknown2: Float, color2: PixelARGB8888, unknown3: [Float], color3: PixelARGB8888, unknown4: UInt32, unknowns2: [WorldRegionWeatherUnknown2]) {
        self.unknown1 = unknown1
        self.color1 = color1
        self.unknown2 = unknown2
        self.color2 = color2
        self.unknown3 = unknown3
        self.color3 = color3
        self.unknown4 = unknown4
        self.unknowns2 = unknowns2
    }
}
