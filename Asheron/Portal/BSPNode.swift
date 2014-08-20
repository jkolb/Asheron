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
    public func getTag() -> String {
        let tag = getUTF8(4)
        var string = ""
        string.extend(reverse(tag))
        return string
    }

    public func getBSPNode(level: Int = 0) -> BSPNode {
        let tag = getTag()
        let padChar: Character = "\t"
        let padding = String(count: level, repeatedValue: padChar)
        var unknown1 = Vector4F()
        var children = Dictionary<String, BSPNode>(minimumCapacity: 2)
        var unknown2 = Vector4F()
        var count = Int(-1)
        var index = Array<UInt16>()
        var leafIndex = Int(-1)

        println("\(level)\(padding)\(tag)")

        if tag != "LEAF" {
            unknown1 = getVector4F()
            println("\(padding)unknown1: \(unknown1)")
        
            if tag == "BPnN" || tag == "BPIN" {
                let next = getBSPNode(level: level + 1) // Recursion!
                children["next"] = next
                let prev = getBSPNode(level: level + 1) // Recursion!
                children["prev"] = prev
            } else if tag == "BPIn" {
                let next = getBSPNode(level: level + 1) // Recursion!
                children["next"] = next
            } else if tag == "BpIN" {
                let prev = getBSPNode(level: level + 1) // Recursion!
                children["prev"] = prev
            }

            unknown2 = getVector4F()
            println("\(padding)unknown2: \(unknown2)")
            count = getIntFrom32Bits()
            println("\(padding)count: \(count)")
            index = getUInt16(count)
            println("\(padding)\(index)")
        
            if (self.position % 4) != 0 {
                println("\(padding)align: \(self.position % 4)")
                // Make sure aligned to 4 bytes
                self.position += 4 - (self.position % 4)
            }
        } else {
            leafIndex = getIntFrom32Bits()
            println("\(padding)\(leafIndex)")
        }
        
        return BSPNode(
            tag: tag,
            unknown1: unknown1,
            children: children,
            unknown2: unknown2,
            count: count,
            index: index,
            leafIndex: leafIndex
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
    public let leafIndex: Int
}
