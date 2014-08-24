//
//  BSPNode.swift
//  Asheron
//
//  Created by Justin Kolb on 7/27/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getTag() -> String {
        let tag = getUTF8(4)
        var string = ""
        string.extend(reverse(tag))
        return string
    }

    public func getDoubleIndex() -> (UInt16, UInt16) {
        return (getUInt16(), getUInt16())
    }
    
    public func getDoubleIndex(count: Int) -> Array<(UInt16, UInt16)> {
        return getArray(count, defaultValue: (0, 0)) { self.getDoubleIndex() }
    }

    public func getCollisionBSPNode(level: Int = 0) -> BSPNode {
        let tag = getTag()
        let padChar: Character = "\t"
        let padding = String(count: level, repeatedValue: padChar)

        println("\(level)\(padding)\(tag)")

        if tag != "LEAF" {
            var plane = getVector4F()
            println("\(padding)plane: \(plane)")

            var child1: BSPNode = EmptyNode()
            var child2: BSPNode = EmptyNode()
        
            if tag == "BPnN" || tag == "BPIN" {
                child1 = getCollisionBSPNode(level: level + 1) // Recursion!
                child2 = getCollisionBSPNode(level: level + 1) // Recursion!
            } else if tag == "BPIn" {
                child1 = getCollisionBSPNode(level: level + 1) // Recursion!
            } else if tag == "BpIN" {
                child1 = getCollisionBSPNode(level: level + 1) // Recursion!
            } // BPOL (has no children)

            let unknown2 = getVector4F()

            println("\(padding)unknown2: \(unknown2)")
        
            return CollisionNode(
                tag: tag,
                plane: plane,
                child1: child1,
                child2: child2,
                unknown2: unknown2
            )
        } else {
            let leafIndex = getIntFrom32Bits()
            let unknown1 = getUInt32()
            let unknown2 = getVector4F()
            let count = getIntFrom32Bits()
            let index = getUInt16(count)

            println("\(padding)\(leafIndex)")
            println("\(padding)count: \(count)")
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

        if tag == "LEAF" {
            let index = getIntFrom32Bits()
            println("\(padding)\(index)")
            return RenderLeaf(
                tag: tag,
                index: index
            )
        } else if tag == "PORT" {
            let plane = getVector4F()
            println("\(padding)plane: \(plane)")

            let child1: BSPNode = getRenderBSPNode(level: level + 1) // Recursion!
            let child2: BSPNode = getRenderBSPNode(level: level + 1) // Recursion!
            let unknown2 = getVector4F()
            let count = getIntFrom32Bits()
            let count2 = getIntFrom32Bits()
            let index = getUInt16(count)
            let index2 = getDoubleIndex(count2)

            println("\(padding)unknown2: \(unknown2)")
            println("\(padding)count: \(count)")
            println("\(padding)count2: \(count2)")
            println("\(padding)\(index)")
            println("\(padding)index2: \(index2)")
        
            if (self.position % 4) != 0 {
                println("\(padding)align: \(self.position % 4)")
                // Make sure aligned to 4 bytes
                self.position += 4 - (self.position % 4)
            }
        
            return PortalNode(
                tag: tag,
                plane: plane,
                child1: child1,
                child2: child2,
                unknown2: unknown2,
                count: count,
                count2: count2,
                index: index,
                index2: index2
            )
        } else {
            let plane = getVector4F()
            println("\(padding)plane: \(plane)")

            var child1: BSPNode = EmptyNode()
            var child2: BSPNode = EmptyNode()

            if tag == "BPnN" || tag == "BPIN" {
                child1 = getRenderBSPNode(level: level + 1) // Recursion!
                child2 = getRenderBSPNode(level: level + 1) // Recursion!
            } else if tag == "BPIn" {
                child1 = getRenderBSPNode(level: level + 1) // Recursion!
            } else if tag == "BpIN" {
                child1 = getRenderBSPNode(level: level + 1) // Recursion!
            }

            let unknown2 = getVector4F()
            let count = getIntFrom32Bits()
            let index = getUInt16(count)

            println("\(padding)unknown2: \(unknown2)")
            println("\(padding)count: \(count)")
            println("\(padding)\(index)")
        
            if (self.position % 4) != 0 {
                println("\(padding)align: \(self.position % 4)")
                // Make sure aligned to 4 bytes
                self.position += 4 - (self.position % 4)
            }
        
            return RenderNode(
                tag: tag,
                plane: plane,
                child1: child1,
                child2: child2,
                unknown2: unknown2,
                count: count,
                index: index
            )
        }
    }
}

public protocol BSPNode {
    var tag: String { get }
}

public struct EmptyNode : BSPNode {
    public let tag: String = ""
}

public struct CollisionNode : BSPNode { // 010000C19
    public let tag: String
    public let plane: Vector4F
    public let child1: BSPNode
    public let child2: BSPNode
    public let unknown2: Vector4F
}

public struct CollisionLeaf : BSPNode { // 010000C19
    public let tag: String
    public let leafIndex: Int
    public let unknown1: UInt32
    public let unknown2: Vector4F
    public let count: Int
    public let index: Array<UInt16>
}

public struct RenderNode : BSPNode {
    public let tag: String
    public let plane: Vector4F
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

public struct PortalNode : BSPNode { // 010000801 & 0100081C
    public let tag: String
    public let plane: Vector4F
    public let child1: BSPNode
    public let child2: BSPNode
    public let unknown2: Vector4F
    public let count: Int
    public let count2: Int
    public let index: Array<UInt16>
    public let index2: Array<(UInt16, UInt16)>
}
