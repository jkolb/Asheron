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

public final class TextureLoader {
    private let portalFile: PortalFile
    private let highresFile: HighresFile
    public var quality: TextureQuality
    
    public init(portalFile: PortalFile, highresFile: HighresFile) {
        self.quality = .high
        self.portalFile = portalFile
        self.highresFile = highresFile
    }

    public func fetchTextureData(handle: PortalHandle<TextureList>) throws -> TextureData {
        let textureList = try portalFile.fetchTextureList(handle: handle)
        let reference = textureList[quality]
        
        switch reference.quality {
        case .high:
            return try highresFile.fetchTextureData(handle: reference.handle)
            
        case .low:
            return try portalFile.fetchTextureData(handle: reference.handle)
        }
    }
}
