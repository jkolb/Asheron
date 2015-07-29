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
        return String(getUTF8(4).characters.reverse())
    }

    public func getDoubleIndex() -> (UInt16, UInt16) {
        return (getUInt16(), getUInt16())
    }
    
    public func getDoubleIndex(count: Int) -> Array<(UInt16, UInt16)> {
        return getArray(count, defaultValue: (0, 0)) { self.getDoubleIndex() }
    }

    public func getCollisionBSPNodeWithLevel(level: Int) -> BSPNode {
        let tag = getTag()
        let padChar: Character = "\t"
        let padding = String(count: level, repeatedValue: padChar)

        print("\(level)\(padding)\(tag)")

        if tag != "LEAF" {
            let plane = getVector4F()
            print("\(padding)plane: \(plane)")

            var child1: BSPNode = EmptyNode()
            var child2: BSPNode = EmptyNode()
        
            if tag == "BPnN" || tag == "BPIN" {
                child1 = getCollisionBSPNodeWithLevel(level + 1) // Recursion!
                child2 = getCollisionBSPNodeWithLevel(level + 1) // Recursion!
            } else if tag == "BPIn" {
                child1 = getCollisionBSPNodeWithLevel(level + 1) // Recursion!
            } else if tag == "BpIN" {
                child1 = getCollisionBSPNodeWithLevel(level + 1) // Recursion!
            } // BPOL (has no children)

            let unknown2 = getVector4F()

            print("\(padding)unknown2: \(unknown2)")
        
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

            print("\(padding)\(leafIndex)")
            print("\(padding)count: \(count)")
            print("\(padding)\(index)")
        
            if (self.position % 4) != 0 {
                print("\(padding)align: \(self.position % 4)")
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

    public func getRenderBSPNodeWithLevel(level: Int) -> BSPNode {
        let tag = getTag()
        let padChar: Character = "\t"
        let padding = String(count: level, repeatedValue: padChar)

        print("\(level)\(padding)\(tag)")

        if tag == "LEAF" {
            let index = getIntFrom32Bits()
            print("\(padding)\(index)")
            return RenderLeaf(
                tag: tag,
                index: index
            )
        } else if tag == "PORT" {
            let plane = getVector4F()
            print("\(padding)plane: \(plane)")

            let child1: BSPNode = getRenderBSPNodeWithLevel(level + 1) // Recursion!
            let child2: BSPNode = getRenderBSPNodeWithLevel(level + 1) // Recursion!
            let unknown2 = getVector4F()
            let count = getIntFrom32Bits()
            let count2 = getIntFrom32Bits()
            let index = getUInt16(count)
            let index2 = getDoubleIndex(count2)

            print("\(padding)unknown2: \(unknown2)")
            print("\(padding)count: \(count)")
            print("\(padding)count2: \(count2)")
            print("\(padding)\(index)")
            print("\(padding)index2: \(index2)")
        
            if (self.position % 4) != 0 {
                print("\(padding)align: \(self.position % 4)")
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
            print("\(padding)plane: \(plane)")

            var child1: BSPNode = EmptyNode()
            var child2: BSPNode = EmptyNode()

            if tag == "BPnN" || tag == "BPIN" {
                child1 = getRenderBSPNodeWithLevel(level + 1) // Recursion!
                child2 = getRenderBSPNodeWithLevel(level + 1) // Recursion!
            } else if tag == "BPIn" {
                child1 = getRenderBSPNodeWithLevel(level + 1) // Recursion!
            } else if tag == "BpIN" {
                child1 = getRenderBSPNodeWithLevel(level + 1) // Recursion!
            }

            let unknown2 = getVector4F()
            let count = getIntFrom32Bits()
            let index = getUInt16(count)

            print("\(padding)unknown2: \(unknown2)")
            print("\(padding)count: \(count)")
            print("\(padding)\(index)")
        
            if (self.position % 4) != 0 {
                print("\(padding)align: \(self.position % 4)")
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
