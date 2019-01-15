/*
 The MIT License (MIT)
 
 Copyright (c) 2018 Justin Kolb
 
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

import Swiftish

public indirect enum PhysicsBSPTree {
    case empty
    case node(PhysicsBSPNode)
    case leaf(PhysicsBSPLeaf)
    
    @_transparent
    public var isEmpty: Bool {
        switch self {
        case .empty: return true
        case .node, .leaf: return false
        }
    }
}

public struct PhysicsBSPNode {
    public var bspTag: BSPTag
    public var splittingPlane: Plane<Float>
    public var posNode: PhysicsBSPTree
    public var negNode: PhysicsBSPTree
    public var sphere: Sphere<Float>?
    
    public init(bspTag: BSPTag, splittingPlane: Plane<Float>, posNode: PhysicsBSPTree, negNode: PhysicsBSPTree, sphere: Sphere<Float>?) {
        self.bspTag = bspTag
        self.splittingPlane = splittingPlane
        self.posNode = posNode
        self.negNode = negNode
        self.sphere = sphere
    }
}

public struct PhysicsBSPLeaf {
    public var bspTag: BSPTag {
        return .LEAF
    }
    public var leafIndex: UInt32
    public var solid: Bool
    public var sphere: Sphere<Float>?
    public var inPolys: [UInt16]

    public init(leafIndex: UInt32, solid: Bool, sphere: Sphere<Float>?, inPolys: [UInt16]) {
        self.leafIndex = leafIndex
        self.solid = solid
        self.sphere = sphere
        self.inPolys = inPolys
    }
}
