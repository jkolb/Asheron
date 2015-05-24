//
//  Transform.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getTransform() -> Transform {
        return Transform(translation: getVector3F(), rotation: getVector4F())
    }
    
    public func getTransform(count: Int) -> Array<Transform> {
        return getArray(count, defaultValue: Transform()) { self.getTransform() }
    }
}

public struct Transform {
    public let translation: Vector3F
    public let rotation: Vector4F
    
    public init() {
        self.translation = Vector3F()
        self.rotation = Vector4F()
    }
    
    public init(translation: Vector3F, rotation: Vector4F) {
        self.translation = translation
        self.rotation = rotation
    }
}
