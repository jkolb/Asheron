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

public final class CGfxObjInputStream : DatInputStream {
    public func readCGfxObj(portalId: PortalId<CGfxObj>) throws -> CGfxObj {
        let streamID = try readPortalId(type: CGfxObj.self)
        precondition(streamID == portalId)
        let flags = CGfxObj.Flags(rawValue: try readUInt32())
        let rgSurfaces = try readPackedArray(readElement: { try readPortalId(type: CSurface.self) })
        let vertexArray = try readCVertexArray()
        let physicsPolygons = flags.contains(.collidable) ? try readPackedArray(readElement: readCPolygon) : []
        let physicsBSP = flags.contains(.collidable) ? try readPhysicsBSPTree() : .empty
        let sortCenter = try readVector3()
        let polygons = flags.contains(.renderable) ? try readPackedArray(readElement: readCPolygon) : []
        let drawingBSP = flags.contains(.renderable) ? try readDrawingBSPTree() : .empty
        let degradeId = flags.contains(.degradable) ? try readUInt32() : nil
        
        return CGfxObj(portalId: portalId, flags: flags, rgSurfaces: rgSurfaces, vertexArray: vertexArray, physicsPolygons: physicsPolygons, physicsBSP: physicsBSP, sortCenter: sortCenter, polygons: polygons, drawingBSP: drawingBSP, degradeId: degradeId)
    }

    @inline(__always)
    private func readCVertexArray() throws -> CVertexArray {
        let vertexType = VertexType(rawValue: try readUInt32())!
        let numVertices = try readCount()
        
        switch vertexType {
        case .UnknownVertexType:
            fatalError("Invalid vertex type")
            
        case .CSWVertexType:
            let vertices = try readArray(count: numVertices, readElement: readCSWVertex)
            
            return .csw(vertices)
        }
    }
    
    @inline(__always)
    private func readCSWVertex() throws -> CSWVertex {
        let vertId = try readUInt16()
        let numUVs = try readUInt16()
        let vertex = try readVector3()
        let normal = try readVector3()
        let uvs = try readArray(count: Int32(numUVs), readElement: readVector2)
        
        return CSWVertex(vertId: vertId, vertex: vertex, normal: normal, uvs: uvs)
    }
    
    @inline(__always)
    private func readVector2() throws -> Vector2 {
        let u = try readFloat32()
        let v = try readFloat32()
        
        return Vector2(u, v)
    }
}
