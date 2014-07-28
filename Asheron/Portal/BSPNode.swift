//
//  BSPNode.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    func getBSPNode() -> BSPNode {
        let tag = getUTF8(4)
        let unknown1 = getVector4F()
        var children = Array<BSPNode>()
        
        if tag.hasPrefix("N") || tag.hasPrefix("P") {
            children += getBSPNode() // Recursion!
            children += getBSPNode() // Recursion!
        }
        
        let unknown2 = getVector4F()
        let count = getIntFrom32Bits()
        let index = getUInt16(count)
        
        return BSPNode(
            tag: tag,
            unknown1: unknown1,
            children: children,
            unknown2: unknown2,
            count: count,
            index: index
        )
    }
}

struct BSPNode {
    let tag: String
    let unknown1: Vector4F
    let children: Array<BSPNode> // 2
    let unknown2: Vector4F
    let count: Int
    let index: Array<UInt16>
}
