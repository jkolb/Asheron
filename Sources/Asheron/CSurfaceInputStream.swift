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

public final class CSurfaceInputStream : DatInputStream {
    public func readCSurface(portalId: PortalId<CSurface>) throws -> CSurface {
        // Doesn't contain its own handle unlike other objects
        let type = try readSurfaceType()
        let value = try readValue(type: type)
        let translucency = try readFloat32()
        let luminosity = try readFloat32()
        let diffuse = try readFloat32()
        
        return CSurface(portalId: portalId, type: type, value: value, translucency: translucency, luminosity: luminosity, diffuse: diffuse)
    }
    
    @inline(__always)
    private func readSurfaceType() throws -> SurfaceType {
        let rawValue = try readUInt32()
        return SurfaceType(rawValue: rawValue)
    }
    
    @inline(__always)
    private func readValue(type: SurfaceType) throws -> CSurface.Value {
        if type.contains(.BASE1_SOLID) {
            let color = try readColorARGB8888()
            
            return .color(color)
        }
        else if type.contains(.BASE1_IMAGE) || type.contains(.BASE1_CLIPMAP) {
            let textureRefHandle = try readPortalId(type: ImgTexRef.self)
            let rawPaletteHandle = try readHandle()
            
            if rawPaletteHandle.bits == 0 {
                return .texture(textureRefHandle)
            }
            else {
                return .indexedTexture(textureRefHandle, PortalId<Palette>(handle: rawPaletteHandle)!)
            }
        }
        else {
            fatalError()
        }
    }
}
