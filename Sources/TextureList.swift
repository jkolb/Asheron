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

public enum TextureQuality {
    case high
    case low
}

public struct TextureReference {
    public let handle: PortalHandle<TextureData>
    public let quality: TextureQuality
    
    public init(handle: PortalHandle<TextureData>, quality: TextureQuality) {
        self.handle = handle
        self.quality = quality
    }
}

public final class TextureList : PortalObject {
    public static let kind = PortalKind.textureList
    public let handle: PortalHandle<TextureList>
    private let lowReference: TextureReference
    private let highReference: TextureReference?
    
    public init(handle: PortalHandle<TextureList>, lowHandle: PortalHandle<TextureData>, highHandle: PortalHandle<TextureData>?) {
        self.handle = handle
        self.lowReference = TextureReference(handle: lowHandle, quality: .low)
        
        if let highHandle = highHandle {
            if lowHandle == highHandle {
                self.highReference = lowReference
            }
            else {
                self.highReference = TextureReference(handle: highHandle, quality: .high)
            }
        }
        else {
            self.highReference = nil
        }
    }
    
    public subscript (quality: TextureQuality) -> TextureReference {
        switch quality {
        case .high:
            return highReference ?? lowReference
            
        case .low:
            return lowReference
        }
    }
}
