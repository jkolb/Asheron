//
//  Vertex.swift
//  AC
//
//  Created by Justin Kolb on 7/20/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    func getVector2F() -> Vector2F {
        return Vector2F(x: getFloat32(), y: getFloat32())
    }
    
    func getVector2F(count: Int) -> Array<Vector2F> {
        return getArray(count, defaultValue: Vector2F()) { self.getVector2F() }
    }
}

struct Vector2F {
    let x: Float = 0.0
    let y: Float = 0.0
}

extension ByteBuffer {
    func getVector3F() -> Vector3F {
        return Vector3F(x: getFloat32(), y: getFloat32(), z: getFloat32())
    }
    
    func getVector3F(count: Int) -> Array<Vector3F> {
        return getArray(count, defaultValue: Vector3F()) { self.getVector3F() }
    }
}

struct Vector3F {
    let x: Float = 0.0
    let y: Float = 0.0
    let z: Float = 0.0
}

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
