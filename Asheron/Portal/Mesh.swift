//
//  Mesh.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getMesh() -> Mesh {
        let identifier = getUInt32()
        let meshType = getUInt32()
        let materialCount = getIntFrom32Bits()
        let materialId = getUInt32(materialCount)
        let unknown1 = getUInt32()
        let vertexCount = getIntFrom32Bits()
        let vertex = getVertex(vertexCount)
        var position = Vector3F()
        
        if meshType == 3 {
            position = getVector3F()
        }
        
        let polygonCount = getIntFrom32Bits()
        let polygon = getPolygon(polygonCount)
//        let rootNode = getBSPNode()
        
        return Mesh(
            identifier: identifier,
            meshType: meshType,
            materialId: materialId,
            unknown1: unknown1,
            vertex: vertex,
            position: position,
            polygon: polygon
//            rootNode: rootNode
        )
    }
}

public struct Mesh {
    public let identifier: UInt32
    public let meshType: UInt32
    public let materialId: Array<UInt32>
    public let unknown1: UInt32
    public let vertex: Array<Vertex>
    public let position: Vector3F
    public let polygon: Array<Polygon>
//    public let rootNode: BSPNode
}
