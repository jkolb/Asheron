//
//  BSPNode.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension String {
    public func characterAtIndex(index: Int) -> Character {
        for (i, c) in enumerate(self) {
            if i == index { return c }
        }
        fatalError("Index out of range")
    }
}

extension ByteBuffer {
    public func getBSPNode(level: Int = 0) -> BSPNode {
        let tag = getUTF8(4)
        let padChar: Character = "\t"
        let padding = String(count: level, repeatedValue: padChar)

        println("\(level)\(padding)\(tag)")
        let unknown1 = getVector4F()
        println("\(padding)unknown1: \(unknown1)")
        var children = Dictionary<String, BSPNode>(minimumCapacity: 2)
        let hasNext: Character = "N"
        let hasPrev: Character = "P"
        
        if tag.characterAtIndex(0) == hasNext || tag.characterAtIndex(0) == hasPrev {
            let next = getBSPNode(level: level + 1) // Recursion!
            children["next"] = next
            let prev = getBSPNode(level: level + 1) // Recursion!
            children["prev"] = prev
        }
        
        let unknown2 = getVector4F()
        println("\(padding)unknown2: \(unknown2)")
        let count = getIntFrom32Bits()
        println("\(padding)count: \(count)")
        let index = getUInt16(count)
        println("\(padding)\(index)")
        
        if (self.position % 4) != 0 {
            println("\(padding)align: \(self.position % 4)")
            // Make sure aligned to 4 bytes
            self.position += 4 - (self.position % 4)
        }
        
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
    public let children: Dictionary<String, BSPNode>
    public let unknown2: Vector4F
    public let count: Int
    public let index: Array<UInt16>
}
