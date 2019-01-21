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

public class DatInputStream {
    public let stream: AsheronInputStream
    
    public init(stream: AsheronInputStream) {
        self.stream = stream
    }
    
    public var bytesRead: Int32 {
        @inline(__always) get {
            return stream.bytesRead
        }
    }
    
    @inline(__always)
    public func skip(count: Int32) throws {
        try stream.skip(count: count)
    }

    @inline(__always)
    public func readUInt8() throws -> UInt8 {
        return try stream.readUInt8()
    }
    
    @inline(__always)
    public func readUInt16() throws -> UInt16 {
        return try stream.readUInt16()
    }
    
    @inline(__always)
    public func readUInt32() throws -> UInt32 {
        return try stream.readUInt32()
    }
    
    @inline(__always)
    public func readUInt64() throws -> UInt64 {
        return try stream.readUInt64()
    }
    
    @inline(__always)
    public func readInt8() throws -> Int8 {
        return try stream.readInt8()
    }
    
    @inline(__always)
    public func readInt16() throws -> Int16 {
        return try stream.readInt16()
    }
    
    @inline(__always)
    public func readInt32() throws -> Int32 {
        return try stream.readInt32()
    }
    
    @inline(__always)
    public func readInt64() throws -> Int64 {
        return try stream.readInt64()
    }
    
    @inline(__always)
    public func readFloat32() throws -> Float32 {
        return try stream.readFloat32()
    }
    
    @inline(__always)
    public func readFloat64() throws -> Float64 {
        return try stream.readFloat64()
    }

    @inline(__always)
    public func read(bytes: UnsafeMutableRawPointer, count: Int32) throws -> Int32 {
        return try stream.read(bytes: bytes, count: count)
    }
    
    @inline(__always)
    public func readPackedArray<T>(readElement: () throws -> T) throws -> [T] {
        let count = try readPackedCount()
        let array = try readArray(count: count, readElement: readElement)
        
        return array
    }

    @inline(__always)
    public func readArray<T>(readElement: () throws -> T) throws -> [T] {
        let count = try readCount()
        let array = try readArray(count: count, readElement: readElement)
        
        return array
    }
    
    @inline(__always)
    public func readArray<T>(count: Int32, readElement: () throws -> T) rethrows -> [T] {
        return try readArray(count: Int(count), readElement: readElement)
    }

    @inline(__always)
    public func readArray<T>(count: Int, readElement: () throws -> T) rethrows -> [T] {
        var array = [T]()
        array.reserveCapacity(count)
        
        for _ in 0..<count {
            let element = try readElement()
            array.append(element)
        }
        
        return array
    }
    
    @inline(__always)
    public func readDictionary<K, V>(readKey: () throws -> K, readValue: () throws -> V) throws -> [K:V] {
        let count = try readCount()
        let dictionary = try readDictionary(count: count, readKey: readKey, readValue: readValue)
        
        return dictionary
    }
    
    @inline(__always)
    public func readDictionary<K, V>(count: Int32, readKey: () throws -> K, readValue: () throws -> V) rethrows -> [K:V] {
        var dictionary = [K:V](minimumCapacity: Int(count))
        
        for _ in 0..<count {
            let key = try readKey()
            let value = try readValue()
            
            dictionary[key] = value
        }
        
        return dictionary
    }
    
    @inline(__always)
    public func readHandle() throws -> Handle {
        return Handle(bits: try readUInt32())
    }
    
    @inline(__always)
    public func readPortalId<T: PortalObject>(type: T.Type) throws -> PortalId<T> {
        let handle = try readHandle()
        
        return PortalId<T>(handle: handle)!
    }

    @inline(__always)
    public func readOffset() throws -> Int32 {
        return try readInt32()
    }
    
    @inline(__always)
    public func readCount() throws -> Int32 {
        return try readInt32()
    }
    
    @inline(__always)
    public func readLength() throws -> Int32 {
        return try readInt32()
    }

    @inline(__always)
    public func readPackedCount() throws -> Int32 {
        let byte0 = try readUInt8()
        
        if byte0 & 0b1_0000000 == 0b0_0000000 {
            let b0 = byte0
            
            return Int32(b0)
        }
        else {
            let byte1 = try readUInt8()
            
            let b0 = UInt16(byte0 & 0b0_1111111) << 8
            let b1 = UInt16(byte1)
            
            return Int32(b0 | b1)
        }
    }
    
    @inline(__always)
    public func readBool32() throws -> Bool {
        let value = try readUInt32()
        
        return value != 0
    }
    
    @inline(__always)
    public func readVector3() throws -> CVector {
        let x = try readFloat32()
        let y = try readFloat32()
        let z = try readFloat32()
        
        return CVector(x, y, z)
    }
    
    @inline(__always)
    public func readQuaternion() throws -> Quaternion {
        let w = try readFloat32()
        let x = try readFloat32()
        let y = try readFloat32()
        let z = try readFloat32()

        return Quaternion(w, x, y, z)
    }

    @inline(__always)
    public func readPlane() throws -> CPlane {
        let normal = try readVector3()
        let distance = try readFloat32()
        
        return CPlane(normal: normal, distance: distance)
    }
    
    @inline(__always)
    public func readSphere() throws -> CSphere? {
        let center = try readVector3()
        let radius = try readFloat32()
        
        if radius < 0 {
            return nil
        }
        
        return CSphere(center: center, radius: radius)
    }
    
    @inline(__always)
    public func readCPortalPoly() throws -> CPortalPoly {
        let portalIndex = try readUInt16()
        let polygonId = try readUInt16()
        
        return CPortalPoly(portalIndex: portalIndex, polygonId: polygonId)
    }
    
    @inline(__always)
    public func readCPolygon() throws -> CPolygon {
        let polyId = try readUInt16()
        let numPts = try readUInt8()
        let stippling = StipplingType(rawValue: try readUInt8())
        let sidesType = SidesType(rawValue: try readUInt32())!
        let posSurface = try readUInt16()
        let negSurface = try readUInt16()
        let vertexIds = try readArray(count: Int32(numPts), readElement: readUInt16)
        let posUVIndices = try readArray(count: !stippling.contains(.NO_POS_UVS) ? Int32(numPts) : 0, readElement: readUInt8)
        let negUVIndices = try readArray(count: sidesType == .both && !stippling.contains(.NO_NEG_UVS) ? Int32(numPts) : 0, readElement: readUInt8)
        
        return CPolygon(polyId: polyId, stippling: stippling, sidesType: sidesType, posSurface: posSurface, negSurface: negSurface, vertexIds: vertexIds, posUVIndices: posUVIndices, negUVIndices: negUVIndices)
    }

    @inline(__always)
    public func readBSPTag() throws -> BSPTag {
        let bytes = try readArray(count: 4, readElement: readUInt8)
        let string = String(bytes: bytes, encoding: .utf8)!
        return BSPTag(rawValue: String(string.reversed()))!
    }

    @inline(__always)
    public func readDrawingBSPTree() throws -> DrawingBSPTree {
        let bspTag = try readBSPTag()
        
        switch bspTag {
        case .PORT: return .portal(try readDrawingBSPPortal())
        case .LEAF: return .leaf(try readDrawingBSPLeaf())
        case .BPIN, .BPIn, .BpIN, .BpIn, .BPnN, .BPnn, .BpnN, .BPOL: return .node(try readDrawingBSPNode(bspTag: bspTag))
        }
    }
    
    @inline(__always)
    public func readDrawingBSPPortal() throws -> DrawingBSPPortal {
        let splittingPlane = try readPlane()
        let posNode = try readDrawingBSPTree()
        let negNode = try readDrawingBSPTree()
        let sphere = try readSphere()
        let numPolys = try readCount()
        let numPortals = try readCount()
        let inPolys = try readArray(count: numPolys, readElement: readUInt16)
        let inPortals = try readArray(count: numPortals, readElement: readCPortalPoly)
        
        return DrawingBSPPortal(splittingPlane: splittingPlane, posNode: posNode, negNode: negNode, sphere: sphere, inPolys: inPolys, inPortals: inPortals)
    }
    
    @inline(__always)
    public func readDrawingBSPLeaf() throws -> DrawingBSPLeaf {
        let leafIndex = try readUInt32()
        
        return DrawingBSPLeaf(leafIndex: leafIndex)
    }
    
    @inline(__always)
    public func readDrawingBSPNode(bspTag: BSPTag) throws -> DrawingBSPNode {
        let splittingPlane = try readPlane()
        let posNode = bspTag.hasPosNode ? try readDrawingBSPTree() : .empty
        let negNode = bspTag.hasNegNode ? try readDrawingBSPTree() : .empty
        let sphere = try readSphere()
        let inPolys = try readArray(readElement: readUInt16)

        return DrawingBSPNode(bspTag: bspTag, splittingPlane: splittingPlane, posNode: posNode, negNode: negNode, sphere: sphere, inPolys: inPolys)
    }
    
    @inline(__always)
    public func readPhysicsBSPTree() throws -> PhysicsBSPTree {
        let bspTag = try readBSPTag()

        switch bspTag {
        case .PORT: fatalError("Unexpected PORT node")
        case .LEAF: return .leaf(try readPhysicsBSPLeaf())
        case .BPIN, .BPIn, .BpIN, .BpIn, .BPnN, .BPnn, .BpnN, .BPOL: return .node(try readPhysicsBSPNode(bspTag: bspTag))
        }
    }
    
    @inline(__always)
    public func readPhysicsBSPLeaf() throws -> PhysicsBSPLeaf {
        let leafIndex = try readUInt32()
        let solid = try readBool32()
        let sphere = try readSphere()
        let inPolys = try readArray(readElement: readUInt16)

        return PhysicsBSPLeaf(leafIndex: leafIndex, solid: solid, sphere: sphere, inPolys: inPolys)
    }
    
    @inline(__always)
    public func readPhysicsBSPNode(bspTag: BSPTag) throws -> PhysicsBSPNode {
        let splittingPlane = try readPlane()
        let posNode = bspTag.hasPosNode ? try readPhysicsBSPTree() : .empty
        let negNode = bspTag.hasNegNode ? try readPhysicsBSPTree() : .empty
        let sphere = try readSphere()

        return PhysicsBSPNode(bspTag: bspTag, splittingPlane: splittingPlane, posNode: posNode, negNode: negNode, sphere: sphere)
    }
    
    @inline(__always)
    public func readColorA8() throws -> ColorA8 {
        let bits = try readUInt8()
        
        return ColorA8(bits: bits)
    }
    
    @inline(__always)
    public func readColorARGB4444() throws -> ColorARGB4444 {
        let bits = try readUInt16()
        
        return ColorARGB4444(bits: bits)
    }

    @inline(__always)
    public func readColorARGB8888() throws -> ColorARGB8888 {
        let bits = try readUInt32()
        
        return ColorARGB8888(bits: bits)
    }
    
    @inline(__always)
    public func readColorBGR565() throws -> ColorBGR565 {
        let bits = try readUInt16()
        
        return ColorBGR565(bits: bits)
    }
    
    @inline(__always)
    public func readColorBGR888() throws -> ColorBGR888 {
        let b = try readUInt8()
        let g = try readUInt8()
        let r = try readUInt8()

        return ColorBGR888(bits: (b, g, r))
    }
    
    @inline(__always)
    public func readColorI8() throws -> ColorI8 {
        let bits = try readUInt8()
        
        return ColorI8(bits: bits)
    }
    
    @inline(__always)
    public func readColorRGB565() throws -> ColorRGB565 {
        let bits = try readUInt16()
        
        return ColorRGB565(bits: bits)
    }
    
    @inline(__always)
    public func readColorRGB888() throws -> ColorRGB888 {
        let r = try readUInt8()
        let g = try readUInt8()
        let b = try readUInt8()
        
        return ColorRGB888(bits: (r, g, b))
    }
    
    @inline(__always)
    public func readColorRGBA4444() throws -> ColorRGBA4444 {
        let bits = try readUInt16()
        
        return ColorRGBA4444(bits: bits)
    }
    
    @inline(__always)
    public func readDXTColor() throws -> DXTColor {
        let bits = try readUInt64()
        
        return DXTColor(bits: bits)
    }
    
    @inline(__always)
    public func readDXT3Alpha() throws -> DXT3Alpha {
        let bits = try readUInt64()
        
        return DXT3Alpha(bits: bits)
    }
    
    @inline(__always)
    public func readDXT5Alpha() throws -> DXT5Alpha {
        let bits = try readUInt64()
        
        return DXT5Alpha(bits: bits)
    }

    @inline(__always)
    public func readDXT1Block() throws -> DXT1Block {
        let colorBlock = try readDXTColor()
        
        return DXT1Block(colorBlock: colorBlock)
    }

    @inline(__always)
    public func readDXT3Block() throws -> DXT3Block {
        let alphaBlock = try readDXT3Alpha()
        let colorBlock = try readDXTColor()
        
        return DXT3Block(alphaBlock: alphaBlock, colorBlock: colorBlock)
    }

    @inline(__always)
    public func readDXT5Block() throws -> DXT5Block {
        let alphaBlock = try readDXT5Alpha()
        let colorBlock = try readDXTColor()
        
        return DXT5Block(alphaBlock: alphaBlock, colorBlock: colorBlock)
    }
    
    @inline(__always)
    public func readPString() throws -> String {
        let length: Int
        let length16 = try readUInt16()
        
        if length16 == 0xFFFF {
            let length32 = try readUInt32()
            
            length = Int(length32)
        }
        else {
            length = Int(length16)
        }
        
        let bytes = try readArray(count: length, readElement: readUInt8)
        let string = String(bytes: bytes, encoding: .utf8)!

        try align()
        
        return string
    }
    
    @inline(__always)
    public func align() throws {
        let alignBytes = 4 - (bytesRead % 4)
        
        if alignBytes < 4 {
            try skip(count: alignBytes)
        }
    }
}
