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
        var unknown1: Array<UInt32>
        
        if (modelType & 1) == 1 {
            unknown1 = getUInt32(meshCount)
        } else {
            unknown1 = Array<UInt32>()
        }
        
        let unknown2Count = getIntFrom32Bits()
        let unknown2Size = unknown2Count * 9 + 1 // No idea
        let unknown2 = getUInt32(unknown2Size)
        let flags = getUInt32()
        
        if (flags & 4) == 4 {
            // Skip 30 * 32-bits
            getUInt32(30);
            
            if (flags & 1) == 1 {
                // Skip 10 * 32-bits
                getUInt32(10)
            }
        } else if (flags & 2) == 2 {
            // Do nothing??
        } else if (flags & 1) == 1 {
            // Skip 1 * 32-bits
            getUInt32()
        }
        
        let transform = getTransform(meshCount)
        
        return Model(
            identifier: identifier,
            modelType: modelType,
            meshId: meshId,
            unknown1: unknown1,
            unknown2Count: unknown2Count,
            unknown2: unknown2,
            flags: flags,
            transform: transform
        )
    }
}

public struct Model {
    public let identifier: UInt32
    public let modelType: UInt32
    public let meshId: Array<UInt32>
    public let unknown1: Array<UInt32>
    public let unknown2Count: Int
    public let unknown2: Array<UInt32>
    public let flags: UInt32
    public let transform: Array<Transform>
}
