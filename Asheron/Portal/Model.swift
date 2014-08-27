//
//  Model.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getModel() -> Model {
        let identifier = getUInt32()
        let modelType = getUInt32()
        let meshCount = getIntFrom32Bits()
        let meshId = getUInt32(meshCount)
//        let transform = getTransform(meshCount)
        
        return Model(
            identifier: identifier,
            modelType: modelType,
            meshId: meshId
//            transform: transform
        )
    }
}

public struct Model {
    public let identifier: UInt32
    public let modelType: UInt32
    public let meshId: Array<UInt32>
//    public let transform: Array<Transform>
}
