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

public struct WorldRegionBiomeTexture : CustomStringConvertible {
    public let index: UInt32
    public let textureListHandle1: TextureListHandle
    public let unknown1: UInt32
    public let unknown2: UInt32
    public let unknown3: UInt32
    public let unknown4: UInt32
    public let unknown5: UInt32
    public let unknown6: UInt32
    public let unknown7: UInt32
    public let unknown8: UInt32
    public let textureListHandle2: TextureListHandle

    public init(
        index: UInt32,
        textureListHandle1: TextureListHandle,
        unknown1: UInt32,
        unknown2: UInt32,
        unknown3: UInt32,
        unknown4: UInt32,
        unknown5: UInt32,
        unknown6: UInt32,
        unknown7: UInt32,
        unknown8: UInt32,
        textureListHandle2: TextureListHandle
    ) {
        self.index = index
        self.textureListHandle1 = textureListHandle1
        self.unknown1 = unknown1
        self.unknown2 = unknown2
        self.unknown3 = unknown3
        self.unknown4 = unknown4
        self.unknown5 = unknown5
        self.unknown6 = unknown6
        self.unknown7 = unknown7
        self.unknown8 = unknown8
        self.textureListHandle2 = textureListHandle2
    }

    public var description: String {
        return "\(index): \(textureListHandle1) - \(textureListHandle2)"
    }
}
