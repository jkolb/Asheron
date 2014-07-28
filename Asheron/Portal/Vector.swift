//
//  Vector.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
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
    func getVector4F() -> Vector4F {
        return Vector4F(x: getFloat32(), y: getFloat32(), z: getFloat32(), w: getFloat32())
    }
    
    func getVector4F(count: Int) -> Array<Vector4F> {
        return getArray(count, defaultValue: Vector4F()) { self.getVector4F() }
    }
}

struct Vector4F {
    let x: Float = 0.0
    let y: Float = 0.0
    let z: Float = 0.0
    let w: Float = 0.0
}
