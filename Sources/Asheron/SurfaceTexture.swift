/*
The MIT License (MIT)

Copyright (c) 2020 Justin Kolb

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

public enum TextureSource : Hashable {
    case portal
    case highres
}

public struct TexturePointer : Hashable, CustomStringConvertible {
    public let textureId: Identifier
    public let source: TextureSource
    
    public init(textureId: Identifier, source: TextureSource) {
        self.textureId = textureId
        self.source = source
    }
    
    public var description: String {
        return "\(textureId):\(source)"
    }
}

public final class SurfaceTexture : Identifiable {
    public var id: Identifier
    public var portalPointer: TexturePointer
    public var highresPointer: TexturePointer?

    public init(id: Identifier, portalTextureId: Identifier, highresTextureId: Identifier?) {
        self.id = id
        self.portalPointer = TexturePointer(textureId: portalTextureId, source: .portal)
        
        if let highresTextureId = highresTextureId {
            if highresTextureId == portalTextureId {
                self.highresPointer = nil
            }
            else {
                self.highresPointer = TexturePointer(textureId: highresTextureId, source: .highres)
            }
        }
        else {
            self.highresPointer = nil
        }
    }
    
    public func getTexturePointer(preferHighres: Bool) -> TexturePointer {
        if preferHighres, let highresPointer = getTexturePointer(source: .highres) {
            return highresPointer
        }
        else if let portalPointer = getTexturePointer(source: .portal) {
            return portalPointer
        }
        else {
            fatalError("Unexpected")
        }
    }
    
    public func getTexturePointer(source: TextureSource) -> TexturePointer? {
        switch source {
        case .portal:
            return portalPointer
            
        case .highres:
            return highresPointer
        }
    }

    public convenience init(from dataStream: DataStream, id: Identifier) {
        let diskId = Identifier(from: dataStream)
        precondition(diskId == id)
        let unknown = [UInt8](from: dataStream, count: 5)
        precondition([0, 0, 0, 0, 2] == unknown)
        let textureIds = [Identifier](from: dataStream)
        precondition(textureIds.count == 1 || textureIds.count == 2)
        
        let highresTextureId: Identifier?
        let portalTextureId: Identifier
        
        if textureIds.count == 1 {
            highresTextureId = nil
            portalTextureId = textureIds[0]
        }
        else {
            highresTextureId = textureIds[0]
            portalTextureId = textureIds[1]
        }
        
        self.init(id: id, portalTextureId: portalTextureId, highresTextureId: highresTextureId)
    }
}
