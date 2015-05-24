//
//  Vector.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput
import Swiftish

public typealias Vector2F = Vector2<Float>
public typealias Vector3F = Vector3<Float>
public typealias Vector4F = Vector4<Float>

extension ByteBuffer {
    public func getVector2F() -> Vector2F {
        return Vector2F(getFloat32(), getFloat32())
    }
    
    public func getVector2F(count: Int) -> Array<Vector2F> {
        return getArray(count, defaultValue: Vector2F()) { self.getVector2F() }
    }
}

extension ByteBuffer {
    public func getVector3F() -> Vector3F {
        return Vector3F(getFloat32(), getFloat32(), getFloat32())
    }
    
    public func getVector3F(count: Int) -> Array<Vector3F> {
        return getArray(count, defaultValue: Vector3F()) { self.getVector3F() }
    }
}

extension ByteBuffer {
    public func getVector4F() -> Vector4F {
        return Vector4F(getFloat32(), getFloat32(), getFloat32(), getFloat32())
    }
    
    public func getVector4F(count: Int) -> Array<Vector4F> {
        return getArray(count, defaultValue: Vector4F()) { self.getVector4F() }
    }
}
