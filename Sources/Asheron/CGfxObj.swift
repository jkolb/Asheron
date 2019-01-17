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

public final class CGfxObj : PortalObject {
    public struct Flags : OptionSet {
        public static let collidable = Flags(rawValue: 1 << 0)
        public static let renderable = Flags(rawValue: 1 << 1)
        public static let degradable = Flags(rawValue: 1 << 3)
        
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            precondition(rawValue & 0b0100 == 0) // No proof this bit is ever used
            precondition(rawValue & 0b11111111_11111111_11111111_1111_0000 == 0) // These bits should be unused
            self.rawValue = rawValue
        }
    }
    
    public static let kind = PortalKind.cGfxObj

    public var portalId: PortalId<CGfxObj>
    public var flags: Flags
    public var rgSurfaces: [PortalId<CSurface>]
    public var vertexArray: CVertexArray
    public var physicsPolygons: [CPolygon]
    public var physicsBSP: PhysicsBSPTree
    public var sortCenter: CVector
    public var polygons: [CPolygon]
    public var drawingBSP: DrawingBSPTree
    public var degradeId: UInt32?
    
    public init(portalId: PortalId<CGfxObj>, flags: Flags, rgSurfaces: [PortalId<CSurface>], vertexArray: CVertexArray, physicsPolygons: [CPolygon], physicsBSP: PhysicsBSPTree, sortCenter: CVector, polygons: [CPolygon], drawingBSP: DrawingBSPTree, degradeId: UInt32?) {
        self.portalId = portalId
        self.flags = flags
        self.rgSurfaces = rgSurfaces
        self.vertexArray = vertexArray
        self.physicsPolygons = physicsPolygons
        self.physicsBSP = physicsBSP
        self.sortCenter = sortCenter
        self.polygons = polygons
        self.drawingBSP = drawingBSP
        self.degradeId = degradeId
    }
}
