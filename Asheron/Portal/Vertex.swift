//
//  Vertex.swift
//  AC
//
//  Created by Justin Kolb on 7/20/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    func getVertex() -> Vertex {
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
    
    func getVertex(count: Int) -> Array<Vertex> {
        return getArray(count) { self.getVertex() }
    }
}

struct Vertex {
    let index: Int
    let count: Int
    let position: Vector3F
    let normal: Vector3F
    let texcoord: Array<Vector2F>
}
