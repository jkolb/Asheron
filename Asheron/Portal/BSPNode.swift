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

    public func getCollisionBSPNode(level: Int = 0) -> BSPNode {
        let tag = getTag()
        let padChar: Character = "\t"
        let padding = String(count: level, repeatedValue: padChar)

        println("\(level)\(padding)\(tag)")

        if tag != "LEAF" {
            var unknown1 = Vector4F()
            var child1: BSPNode = EmptyNode()
            var child2: BSPNode = EmptyNode()
            var unknown2 = Vector4F()

            unknown1 = getVector4F()
            println("\(padding)unknown1: \(unknown1)")
        
            if tag == "BPnN" || tag == "BPIN" {
                child1 = getCollisionBSPNode(level: level + 1) // Recursion!
                child2 = getCollisionBSPNode(level: level + 1) // Recursion!
            } else if tag == "BPIn" {
                child1 = getCollisionBSPNode(level: level + 1) // Recursion!
            } else if tag == "BpIN" {
                child1 = getCollisionBSPNode(level: level + 1) // Recursion!
            }

            unknown2 = getVector4F()
            println("\(padding)unknown2: \(unknown2)")
        
            return CollisionNode(
                tag: tag,
                unknown1: unknown1,
                child1: child1,
                child2: child2,
                unknown2: unknown2
            )
        } else {
            let leafIndex = getIntFrom32Bits()
            println("\(padding)\(leafIndex)")
            let unknown1 = getUInt32()
            let unknown2 = getVector4F()
            var count = Int(-1)
            var index = Array<UInt16>()
            count = getIntFrom32Bits()
            println("\(padding)count: \(count)")
            index = getUInt16(count)
            println("\(padding)\(index)")
        
            if (self.position % 4) != 0 {
                println("\(padding)align: \(self.position % 4)")
                // Make sure aligned to 4 bytes
                self.position += 4 - (self.position % 4)
            }
            return CollisionLeaf(
                tag: tag,
                leafIndex: leafIndex,
                unknown1: unknown1,
                unknown2: unknown2,
                count: count,
                index: index
            )
        }
    }

    public func getRenderBSPNode(level: Int = 0) -> BSPNode {
        let tag = getTag()
        let padChar: Character = "\t"
        let padding = String(count: level, repeatedValue: padChar)

        println("\(level)\(padding)\(tag)")

        if tag != "LEAF" {
            var unknown1 = Vector4F()
            var child1: BSPNode = EmptyNode()
            var child2: BSPNode = EmptyNode()
            var unknown2 = Vector4F()
            var count = Int(-1)
            var index = Array<UInt16>()

            unknown1 = getVector4F()
            println("\(padding)unknown1: \(unknown1)")
        
            if tag == "BPnN" || tag == "BPIN" {
                child1 = getRenderBSPNode(level: level + 1) // Recursion!
                child2 = getRenderBSPNode(level: level + 1) // Recursion!
            } else if tag == "BPIn" {
                child1 = getRenderBSPNode(level: level + 1) // Recursion!
            } else if tag == "BpIN" {
                child1 = getRenderBSPNode(level: level + 1) // Recursion!
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
        
            return RenderNode(
                tag: tag,
                unknown1: unknown1,
                child1: child1,
                child2: child2,
                unknown2: unknown2,
                count: count,
                index: index
            )
        } else {
            let index = getIntFrom32Bits()
            println("\(padding)\(index)")
            return RenderLeaf(tag: tag, index: index)
        }
    }
}

public protocol BSPNode {
    var tag: String { get }
}

public struct EmptyNode : BSPNode {
    public let tag: String = ""
}

public struct CollisionNode : BSPNode {
    public let tag: String
    public let unknown1: Vector4F
    public let child1: BSPNode
    public let child2: BSPNode
    public let unknown2: Vector4F
}

public struct CollisionLeaf : BSPNode {
    public let tag: String
    public let leafIndex: Int
    public let unknown1: UInt32
    public let unknown2: Vector4F
    public let count: Int
    public let index: Array<UInt16>
}

public struct RenderNode : BSPNode {
    public let tag: String
    public let unknown1: Vector4F
    public let child1: BSPNode
    public let child2: BSPNode
    public let unknown2: Vector4F
    public let count: Int
    public let index: Array<UInt16>
}

public struct RenderLeaf : BSPNode {
    public let tag: String
    public let index: Int
}
