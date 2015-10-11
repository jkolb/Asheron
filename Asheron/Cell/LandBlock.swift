//
//  LandBlock.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getLandBlock() -> LandBlock {
        let identifier = getUInt32()
        let flags = getUInt32()
        let topography = getUInt16(LandBlock.sizeSquared)
        let height = getUInt8(LandBlock.sizeSquared)
        let pad = getUInt8()
        
        return LandBlock(
            identifier: identifier,
            flags: flags,
            topography: topography,
            height: height,
            pad: pad
        )
    }
}

public struct LandBlock {
    public static let size: Int = 9
    public static let sizeSquared = size * size
    public let identifier: UInt32
    public let flags: UInt32
    public let topography: [UInt16] // 9 * 9 * 2 = 162
    public let height: [UInt8] // 9 * 9 * 1 = 81
    public let pad: UInt8
    // 252
    
    public init(
        identifier: UInt32 = 0,
        flags: UInt32 = 0,
        topography: [UInt16] = [UInt16](count: LandBlock.sizeSquared, repeatedValue: 0),
        height: [UInt8] = [UInt8](count: LandBlock.sizeSquared, repeatedValue: 0),
        pad: UInt8 = 0
    ) {
        self.identifier = identifier
        self.flags = flags
        self.topography = topography
        self.height = height
        self.pad = pad
    }
    
    public func height(x: Int, _ y: Int) -> UInt8 {
        return height[y * LandBlock.size + x]
    }
    
    public func topography(x: Int, _ y: Int) -> UInt16 {
        return topography[y * LandBlock.size + x]
    }
}
