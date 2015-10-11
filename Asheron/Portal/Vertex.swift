//
//  Vertex.swift
//  AC
//
//  Created by Justin Kolb on 7/20/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getVertex() -> Vertex {
        let index = getIntFrom16Bits()
        let count = getIntFrom16Bits()
        let position = getVector3F()
        let normal = getVector3F()
        let texcoord = getVector2F(count)
        
        return Vertex(
            index: index,
            count: count,
            position: position,
            normal: normal,
            texcoord: texcoord
        )
    }
    
    public func getVertex(count: Int) -> [Vertex] {
        return getArray(count) { self.getVertex() }
    }
}

public struct Vertex {
    public let index: Int
    public let count: Int
    public let position: Vector3F
    public let normal: Vector3F
    public let texcoord: [Vector2F]
}
