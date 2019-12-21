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

public final class GraphicsObject : Identifiable {
    public struct Flags : OptionSet, CustomStringConvertible, Packable {
        public static let collidable = Flags(rawValue: 1 << 0)
        public static let renderable = Flags(rawValue: 1 << 1)
        public static let degradable = Flags(rawValue: 1 << 3)
        
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            precondition(rawValue & 0b0100 == 0) // No proof this bit is ever used
            precondition(rawValue & 0b11111111_11111111_11111111_1111_0000 == 0) // These bits should be unused
            self.rawValue = rawValue
        }
        
        public var description: String {
            var values = self
            var strings = [String]()
            
            while !values.isEmpty {
                if values.contains(.collidable) {
                    strings.append("collidable")
                    values.subtract(.collidable)
                }
                if values.contains(.renderable) {
                    strings.append("renderable")
                    values.subtract(.renderable)
                }
                if values.contains(.degradable) {
                    strings.append("degradable")
                    values.subtract(.degradable)
                }
            }
            
            return "[\(strings.joined(separator: ", "))]"
        }
    }
    
    public var id: Identifier
    public var flags: Flags
    public var rgSurfaces: [Identifier]
    public var vertexArray: VertexArray
    public var collisionPolygons: [Polygon]
    public var collisionBSP: CollisionBSPTree
    public var sortCenter: Vector3
    public var renderPolygons: [Polygon]
    public var renderBSP: RenderBSPTree
    public var degradeId: UInt32?

    public init(from dataStream: DataStream, id: Identifier) {
        let diskId = Identifier(from: dataStream)
        precondition(diskId == id)
        self.id = id
        self.flags = Flags(from: dataStream)
        self.rgSurfaces = [Identifier](uncompress: dataStream)
        self.vertexArray = VertexArray(from: dataStream)
        self.collisionPolygons = flags.contains(.collidable) ? [Polygon](uncompress: dataStream) : []
        self.collisionBSP = flags.contains(.collidable) ? CollisionBSPTree(from: dataStream) : .empty
        self.sortCenter = Vector3(from: dataStream)
        self.renderPolygons = flags.contains(.renderable) ? [Polygon](uncompress: dataStream) : []
        self.renderBSP = flags.contains(.renderable) ? RenderBSPTree(from: dataStream) : .empty
        self.degradeId = flags.contains(.degradable) ? UInt32(from: dataStream) : nil // 0x11000000
    }

    public enum SidesType : UInt32, Hashable, Packable {
        case single = 0
        case double = 1
        case both = 2
    }
    
    public struct StipplingType : OptionSet, Hashable, CustomStringConvertible, Packable {
        public static let none: StipplingType = []
        public static let positive = StipplingType(rawValue: 1 << 0)
        public static let negative = StipplingType(rawValue: 1 << 1)
        public static let both: StipplingType = [.positive, .negative]
        public static let noPosUVs = StipplingType(rawValue: 1 << 2)
        public static let noNegUVs = StipplingType(rawValue: 1 << 3)
        public static let noUVs: StipplingType = [.noPosUVs, .noNegUVs]
        
        public let rawValue: UInt8
        
        public init(rawValue: UInt8) {
            precondition(rawValue != 20) // NO_UVS == 20 ??
            self.rawValue = rawValue
        }
        
        public var description: String {
            var values = self
            var strings = [String]()
            
            while !values.isEmpty {
                if values.contains(.positive) {
                    strings.append("positive")
                    values.subtract(.positive)
                }
                if values.contains(.negative) {
                    strings.append("negative")
                    values.subtract(.negative)
                }
                if values.contains(.noPosUVs) {
                    strings.append("noPosUVs")
                    values.subtract(.noPosUVs)
                }
                if values.contains(.noNegUVs) {
                    strings.append("noNegUVs")
                    values.subtract(.noNegUVs)
                }
            }
            
            return "[\(strings.joined(separator: ", "))]"
        }
    }
    
    public struct Polygon : Packable {
        public var polyId: UInt16
        public var numPts: Int
        public var stippling: StipplingType
        public var sidesType: SidesType
        public var posSurface: Int16
        public var negSurface: Int16
        public var vertexIds: [UInt16]
        public var posUVIndices: [UInt8]
        public var negUVIndices: [UInt8]
        
        public init(from dataStream: DataStream) {
            self.polyId = UInt16(from: dataStream)
            self.numPts = numericCast(UInt8(from: dataStream))
            let stippling = StipplingType(from: dataStream)
            self.stippling = stippling
            let sidesType = SidesType(from: dataStream)
            self.sidesType = sidesType
            self.posSurface = Int16(from: dataStream)
            self.negSurface = Int16(from: dataStream)
            self.vertexIds = [UInt16](from: dataStream, count: numPts)
            self.posUVIndices = [UInt8](from: dataStream, count: !stippling.contains(.noPosUVs) ? numPts : 0)
            self.negUVIndices = [UInt8](from: dataStream, count: sidesType == .both && !stippling.contains(.noNegUVs) ? numPts : 0)
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }

    public enum VertexType : UInt32, Packable {
        case unknown = 0
        case csw = 1 // ??
        // 2?
        // 3?
    }
    
    public struct VertexArray : Packable {
        public var vertexType: VertexType
        public var vertices: [Vertex]
        
        public init(from dataStream: DataStream) {
            let vertexType = VertexType(from: dataStream)
            precondition(vertexType == .csw)
            self.vertexType = vertexType
            self.vertices = [Vertex](from: dataStream)
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }
    
    public struct VertexUV : Packable {
        public var u: Float32
        public var v: Float32
        
        public init(from dataStream: DataStream) {
            self.u = Float32(from: dataStream)
            self.v = Float32(from: dataStream)
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            u.encode(to: dataStream)
            v.encode(to: dataStream)
        }
    }
    
    public struct Vertex : Packable {
        public var index: Int16
        public var position: Vector3
        public var normal: Vector3
        public var uvs: [VertexUV]
        
        public init(from dataStream: DataStream) {
            self.index = Int16(from: dataStream)
            let numUVs = Int16(from: dataStream)
            self.position = Vector3(from: dataStream)
            self.normal = Vector3(from: dataStream)
            self.uvs = [VertexUV](from: dataStream, count: numericCast(numUVs))
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }

    public enum BSPTag : String, Packable {
        case LEAF = "LEAF"
        
        // Front child only
        case BPnn = "BPnn"
        case BPIn = "BPIn"
        
        // Back child only
        case BpIN = "BpIN"
        case BpnN = "BpnN"
        
        // Both front and back children
        case BPIN = "BPIN"
        case BPnN = "BPnN"
        case PORT = "PORT"
        
        // Neither child
        case BpIn = "BpIn"
        case BPOL = "BPOL"
        
        public var hasPosNode: Bool {
            switch self {
            case .BPnn, .BPIn, .BPIN, .BPnN, .PORT: return true
            case .BpIN, .BpnN, .BpIn, .BPOL, .LEAF: return false
            }
        }
        
        public var hasNegNode: Bool {
            switch self {
            case .BpnN, .BpIN, .BPIN, .BPnN, .PORT: return true
            case .BPnn, .BPIn, .BpIn, .BPOL, .LEAF: return false
            }
        }
        
        public init(from dataStream: DataStream) {
            let bytes = [UInt8](from: dataStream, count: 4)
            let string = String(bytes: bytes, encoding: .utf8)!
            self.init(rawValue: String(string.reversed()))!
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }

    public indirect enum CollisionBSPTree : Packable {
        case empty
        case node(CollisionBSPNode)
        case leaf(CollisionBSPLeaf)
        
        public var isEmpty: Bool {
            switch self {
            case .empty: return true
            case .node, .leaf: return false
            }
        }
        
        public init(from dataStream: DataStream) {
            let bspTag = BSPTag(from: dataStream)
            
            switch bspTag {
            case .PORT: fatalError("Unexpected PORT node")
            case .LEAF: self = .leaf(CollisionBSPLeaf(from: dataStream))
            case .BPIN, .BPIn, .BpIN, .BpIn, .BPnN, .BPnn, .BpnN, .BPOL: self = .node(CollisionBSPNode(from: dataStream, bspTag: bspTag))
            }
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }
    
    public struct CollisionBSPNode {
        public var bspTag: BSPTag
        public var splittingPlane: Plane
        public var posNode: CollisionBSPTree
        public var negNode: CollisionBSPTree
        public var sphere: Sphere
        
        public init(from dataStream: DataStream, bspTag: BSPTag) {
            self.bspTag = bspTag
            self.splittingPlane = Plane(from: dataStream)
            self.posNode = bspTag.hasPosNode ? CollisionBSPTree(from: dataStream) : .empty
            self.negNode = bspTag.hasNegNode ? CollisionBSPTree(from: dataStream) : .empty
            self.sphere = Sphere(from: dataStream)
        }
    }
    
    public struct CollisionBSPLeaf : Packable {
        public var bspTag: BSPTag {
            return .LEAF
        }
        public var leafIndex: UInt32
        public var solid: Bool
        public var sphere: Sphere
        public var inPolys: [UInt16]
        
        public init(from dataStream: DataStream) {
            self.leafIndex = UInt32(from: dataStream)
            self.solid = Bool(from: dataStream)
            self.sphere = Sphere(from: dataStream)
            self.inPolys = [UInt16](from: dataStream)
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }

    public indirect enum RenderBSPTree : Packable {
        case empty
        case node(RenderBSPNode)
        case leaf(RenderBSPLeaf)
        case portal(RenderBSPPortal)
        
        public var isEmpty: Bool {
            switch self {
            case .empty: return true
            case .node, .leaf, .portal: return false
            }
        }
        
        public init(from dataStream: DataStream) {
            let bspTag = BSPTag(from: dataStream)
            switch bspTag {
            case .PORT: self = .portal(RenderBSPPortal(from: dataStream))
            case .LEAF: self = .leaf(RenderBSPLeaf(from: dataStream))
            case .BPIN, .BPIn, .BpIN, .BpIn, .BPnN, .BPnn, .BpnN, .BPOL: self = .node(RenderBSPNode(from: dataStream, bspTag: bspTag))
            }
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }
    
    public struct PortalPoly : Packable {
        public var portalIndex: UInt16
        public var polygonId: UInt16
        
        public init(from dataStream: DataStream) {
            self.portalIndex = UInt16(from: dataStream)
            self.polygonId = UInt16(from: dataStream)
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }
    
    public struct RenderBSPPortal : Packable {
        public var bspTag: BSPTag {
            return .PORT
        }
        public var splittingPlane: Plane
        public var posNode: RenderBSPTree
        public var negNode: RenderBSPTree
        public var sphere: Sphere
        public var inPolys: [UInt16]
        public var inPortals: [PortalPoly]
        
        public init(from dataStream: DataStream) {
            self.splittingPlane = Plane(from: dataStream)
            self.posNode = RenderBSPTree(from: dataStream)
            self.negNode = RenderBSPTree(from: dataStream)
            self.sphere = Sphere(from: dataStream)
            let numPolys = Int32(from: dataStream)
            let numPortals = Int32(from: dataStream)
            self.inPolys = [UInt16](from: dataStream, count: numericCast(numPolys))
            self.inPortals = [PortalPoly](from: dataStream, count: numericCast(numPortals))
            precondition(!posNode.isEmpty)
            precondition(!negNode.isEmpty)
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }
    
    public struct RenderBSPNode {
        public var bspTag: BSPTag
        public var splittingPlane: Plane
        public var posNode: RenderBSPTree
        public var negNode: RenderBSPTree
        public var sphere: Sphere
        public var inPolys: [UInt16]
        
        public init(from dataStream: DataStream, bspTag: BSPTag) {
            self.bspTag = bspTag
            self.splittingPlane = Plane(from: dataStream)
            self.posNode = bspTag.hasPosNode ? RenderBSPTree(from: dataStream) : .empty
            self.negNode = bspTag.hasNegNode ? RenderBSPTree(from: dataStream) : .empty
            self.sphere = Sphere(from: dataStream)
            self.inPolys = [UInt16](from: dataStream)
        }
    }
    
    public struct RenderBSPLeaf : Packable {
        public var bspTag: BSPTag {
            return .LEAF
        }
        public var leafIndex: UInt32
        
        public init(from dataStream: DataStream) {
            self.leafIndex = UInt32(from: dataStream)
        }
        
        @inlinable public func encode(to dataStream: DataStream) {
            fatalError("Not implemented")
        }
    }
}
