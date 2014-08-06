//
//  Vector.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getVector2F() -> Vector2F {
        return Vector2F(x: getFloat32(), y: getFloat32())
    }
    
    public func getVector2F(count: Int) -> Array<Vector2F> {
        return getArray(count, defaultValue: Vector2F()) { self.getVector2F() }
    }
}

public struct Vector2F : Printable {
    public let x: Float = 0.0
    public let y: Float = 0.0
    
    public var description: String {
        return "\(x), \(y)"
    }
}

extension ByteBuffer {
    public func getVector3F() -> Vector3F {
        return Vector3F(x: getFloat32(), y: getFloat32(), z: getFloat32())
    }
    
    public func getVector3F(count: Int) -> Array<Vector3F> {
        return getArray(count, defaultValue: Vector3F()) { self.getVector3F() }
    }
}

public struct Vector3F : Printable {
    public let x: Float = 0.0
    public let y: Float = 0.0
    public let z: Float = 0.0
    
    public var description: String {
        return "\(x), \(y), \(z)"
    }
}

extension ByteBuffer {
    public func getVector4F() -> Vector4F {
        return Vector4F(x: getFloat32(), y: getFloat32(), z: getFloat32(), w: getFloat32())
    }
    
    public func getVector4F(count: Int) -> Array<Vector4F> {
        return getArray(count, defaultValue: Vector4F()) { self.getVector4F() }
    }
}

public struct Vector4F : Printable {
    public let x: Float = 0.0
    public let y: Float = 0.0
    public let z: Float = 0.0
    public let w: Float = 0.0
    
    public var description: String {
        return "\(x), \(y), \(z), \(w)"
    }
}
