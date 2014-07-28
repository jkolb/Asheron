//
//  Transform.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    func getTransform() -> Transform {
        return Transform(translation: getVector3F(), rotation: getVector4F())
    }
    
    func getTransform(count: Int) -> Array<Transform> {
        return getArray(count, defaultValue: Transform()) { self.getTransform() }
    }
}

struct Transform {
    let translation: Vector3F = Vector3F()
    let rotation: Vector4F = Vector4F()
}
