//
//  Vector.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput
import simd

public typealias Vector2F = float2
public typealias Vector3F = float3
public typealias Vector4F = float4

extension ByteBuffer {
    public func getVector2F() -> Vector2F {
        return Vector2F(getFloat32(), getFloat32())
    }
    
    public func getVector2F(count: Int) -> [Vector2F] {
        return getArray(count, defaultValue: Vector2F()) { self.getVector2F() }
    }
}

extension ByteBuffer {
    public func getVector3F() -> Vector3F {
        return Vector3F(getFloat32(), getFloat32(), getFloat32())
    }
    
    public func getVector3F(count: Int) -> [Vector3F] {
        return getArray(count, defaultValue: Vector3F()) { self.getVector3F() }
    }
}

extension ByteBuffer {
    public func getVector4F() -> Vector4F {
        return Vector4F(getFloat32(), getFloat32(), getFloat32(), getFloat32())
    }
    
    public func getVector4F(count: Int) -> [Vector4F] {
        return getArray(count, defaultValue: Vector4F()) { self.getVector4F() }
    }
}
