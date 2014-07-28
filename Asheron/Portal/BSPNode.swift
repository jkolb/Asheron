//
//  BSPNode.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getBSPNode() -> BSPNode {
        let tag = getUTF8(4)
        println(tag)
        let unknown1 = getVector4F()
        var children = Array<BSPNode>()
        
        if tag.hasPrefix("N") || tag.hasPrefix("P") {
            children += getBSPNode() // Recursion!
            children += getBSPNode() // Recursion!
        }
        
        let unknown2 = getVector4F()
        let count = getIntFrom32Bits()
        println(count)
        let index = getUInt16(count)
        let padCount = count % 2
        getUInt16(padCount) // Skip padding
        
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

public struct BSPNode {
    public let tag: String
    public let unknown1: Vector4F
    public let children: Array<BSPNode> // 2
    public let unknown2: Vector4F
    public let count: Int
    public let index: Array<UInt16>
}
