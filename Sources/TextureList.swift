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

public final class TextureList : PortalObject {
    public static let kind = PortalKind.textureList
    public let handle: TextureListHandle
    public let portalReference: TextureReference
    public let highresReference: TextureReference?
    
    public init(handle: TextureListHandle, portalHandle: TextureDataHandle, highresHandle: TextureDataHandle?) {
        self.handle = handle
        self.portalReference = TextureReference(handle: portalHandle, location: .portal)
        
        if let highresHandle = highresHandle {
            if portalHandle == highresHandle {
                self.highresReference = portalReference
            }
            else {
                self.highresReference = TextureReference(handle: highresHandle, location: .highres)
            }
        }
        else {
            self.highresReference = nil
        }
    }
    
    public subscript (location: TextureLocation) -> TextureReference {
        switch location {
        case .portal:
            return portalReference
            
        case .highres:
            return highresReference ?? portalReference
        }
    }
}
