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

public enum ImgTexFile {
    case portal
    case highres
}

public struct ImgTexPtr : CustomStringConvertible {
    public let imgTexId: PortalId<ImgTex>
    public let file: ImgTexFile
    
    public init(imgTexId: PortalId<ImgTex>, file: ImgTexFile) {
        self.imgTexId = imgTexId
        self.file = file
    }
    
    public var description: String {
        return "\(imgTexId):\(file)"
    }
}

public final class ImgTexRef : PortalObject {
    public static let kind = PortalKind.imgTexRef
    public var portalId: PortalId<ImgTexRef>
    public var portalPointer: ImgTexPtr
    public var highresPointer: ImgTexPtr?

    public init(portalId: PortalId<ImgTexRef>, portalImgTexId: PortalId<ImgTex>, highresImgTexId: PortalId<ImgTex>?) {
        self.portalId = portalId
        self.portalPointer = ImgTexPtr(imgTexId: portalImgTexId, file: .portal)
        
        if let highresImgTexId = highresImgTexId {
            if highresImgTexId == portalImgTexId {
                self.highresPointer = portalPointer
            }
            else {
                self.highresPointer = ImgTexPtr(imgTexId: highresImgTexId, file: .highres)
            }
        }
        else {
            self.highresPointer = nil
        }
    }
    
    public subscript (file: ImgTexFile) -> ImgTexPtr {
        switch file {
        case .portal:
            return portalPointer
            
        case .highres:
            return highresPointer ?? portalPointer
        }
    }
}
