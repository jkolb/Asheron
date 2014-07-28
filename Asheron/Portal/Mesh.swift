//
//  Mesh.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    func getMesh() -> Mesh {
        let identifier = getUInt32()
        let meshType = getUInt32()
        let materialCount = getIntFrom32Bits()
        let materialId = getUInt32(materialCount)
        let unknown1 = getUInt32()
        let vertexCount = getIntFrom32Bits()
        let vertex = getVertex(vertexCount)
        let position = getVector3F()
        let polygonCount = getIntFrom32Bits()
        let polygon = getPolygon(polygonCount)
        let rootNode = getBSPNode()
        
        return Mesh(
            identifier: identifier,
            meshType: meshType,
            materialId: materialId,
            unknown1: unknown1,
            vertex: vertex,
            position: position,
            polygon: polygon,
            rootNode: rootNode
        )
    }
}

struct Mesh {
    let identifier: UInt32
    let meshType: UInt32
    let materialId: Array<UInt32>
    let unknown1: UInt32
    let vertex: Array<Vertex>
    let position: Vector3F
    let polygon: Array<Polygon>
    let rootNode: BSPNode
}
