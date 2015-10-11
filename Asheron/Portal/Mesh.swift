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
        let materialCount = getIntFrom32Bits() & 0x0000003F
        let materialId = getUInt32(materialCount)
        let unknown1 = getUInt32()
        let vertexCount = getIntFrom32Bits()
        let vertex = getVertex(vertexCount)
        var collisionPolygons = [Polygon]()
        var collisionNode: BSPNode = EmptyNode()

        if meshType == 3 {
            let collisionPolygonCount = getIntFrom32Bits()
            collisionPolygons = getPolygon(collisionPolygonCount)
            for polygon in collisionPolygons {
                print(polygon)
            }
            collisionNode = getCollisionBSPNodeWithLevel(0)
        }
        
        let position = getVector3F()
        let renderPolygonCount = getIntFrom32Bits()
        let renderPolygons = getPolygon(renderPolygonCount)
        for polygon in renderPolygons {
            print(polygon)
        }
        let renderNode = getRenderBSPNodeWithLevel(0)
        
        assert(remaining == 0, "Not fully parsed")
        
        return Mesh(
            identifier: identifier,
            meshType: meshType,
            materialId: materialId,
            unknown1: unknown1,
            vertex: vertex,
            collisionPolygons: collisionPolygons,
            collisionNode: collisionNode,
            position: position,
            renderPolygons: renderPolygons,
            renderNode: renderNode
        )
    }
}

public struct Mesh {
    public let identifier: UInt32
    public let meshType: UInt32
    public let materialId: [UInt32]
    public let unknown1: UInt32
    public let vertex: [Vertex]
    public let collisionPolygons: [Polygon]
    public let collisionNode: BSPNode
    public let position: Vector3F
    public let renderPolygons: [Polygon]
    public let renderNode: BSPNode
}
