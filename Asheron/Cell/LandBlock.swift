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
        let meshBlockFlag = getUInt32()
        let topography = getUInt16(9 * 9)
        let height = getUInt8(9 * 9)
        let pad = getUInt8()
        
        return LandBlock(
            identifier: identifier,
            meshBlockFlag: meshBlockFlag,
            topography: topography,
            height: height,
            pad: pad
        )
    }
}

public struct LandBlock {
    let identifier: UInt32
    let meshBlockFlag: UInt32
    let topography: Array<UInt16> // 9 * 9 * 2 = 162
    let height: Array<UInt8> // 9 * 9 * 1 = 81
    let pad: UInt8
    // 252
}
