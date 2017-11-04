/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Justin Kolb
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

extension ByteStream {
    public func getBSPRenderTree() -> BSPRenderTree {
        let tag = getBSPRenderTreeTag()
        
        if tag == .LEAF {
            var leaf = BSPRenderTree.Leaf()
            leaf.leafIndex = getUInt32()
            
            return .leaf(leaf)
        }
        else if tag == .PORT {
            var portal = BSPRenderTree.Portal()
            portal.partition = getPlane()
            portal.front = getBSPRenderTree()
            portal.back = getBSPRenderTree()
            portal.bounds = getSphere()
            //portal.index1 =
            //portal.index2 =
            return .portal(portal)
        }
        else {
            var node = BSPRenderTree.Node(tag: tag)
            
            if tag.hasFront {
                node.front = getBSPRenderTree()
            }
            
            if tag.hasBack {
                node.back = getBSPRenderTree()
            }
            
            node.bounds = getSphere()
            //node.index =
            return .node(node)
        }
    }
    
    private func getBSPRenderTreeTag() -> BSPRenderTree.Tag {
        let rawValue = String(getUTF8(count: 4).characters.reversed())
        return BSPRenderTree.Tag(rawValue: rawValue)!
    }
}
/*
 public indirect enum BSPRenderTree {
 case empty
 case node(Node)
 case leaf(Leaf)
 case portal(Portal)
 
 public struct Node {
 public var tag: Tag
 public var partition: Plane<Float> = Plane<Float>(normal: Vector3<Float>(), distance: 0.0)
 public var front: BSPRenderTree = .empty
 public var back: BSPRenderTree = .empty
 public var bounds: Sphere<Float> = Sphere<Float>()
 public var polygonIndex: [UInt16] = []
 
 public init(tag: Tag) {
 self.tag = tag
 }
 }
 
 public struct Leaf {
 public let tag: Tag = .LEAF
 public var leafIndex: UInt32 = 0
 
 public init() {}
 }
 
 public struct Portal {
 public let tag: Tag = .PORT
 public var partition: Plane<Float> = Plane<Float>(normal: Vector3<Float>(), distance: 0.0)
 public var front: BSPRenderTree = .empty
 public var back: BSPRenderTree = .empty
 public var bounds: Sphere<Float> = Sphere<Float>()
 public var index1: [UInt16] = []
 public var index2: [(UInt16, UInt16)] = []
 }
 */
