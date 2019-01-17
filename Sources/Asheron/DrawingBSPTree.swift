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

public indirect enum DrawingBSPTree {
    case empty
    case node(DrawingBSPNode)
    case leaf(DrawingBSPLeaf)
    case portal(DrawingBSPPortal)
    
    @_transparent
    public var isEmpty: Bool {
        switch self {
        case .empty: return true
        case .node, .leaf, .portal: return false
        }
    }
}

public struct DrawingBSPPortal {
    public var bspTag: BSPTag {
        return .PORT
    }
    public var splittingPlane: CPlane
    public var posNode: DrawingBSPTree
    public var negNode: DrawingBSPTree
    public var sphere: CSphere?
    public var inPolys: [UInt16]
    public var inPortals: [CPortalPoly]
    
    public init(splittingPlane: CPlane, posNode: DrawingBSPTree, negNode: DrawingBSPTree, sphere: CSphere?, inPolys: [UInt16], inPortals: [CPortalPoly]) {
        precondition(!posNode.isEmpty)
        precondition(!negNode.isEmpty)
        self.splittingPlane = splittingPlane
        self.posNode = posNode
        self.negNode = negNode
        self.sphere = sphere
        self.inPolys = inPolys
        self.inPortals = inPortals
    }
}

public struct DrawingBSPNode {
    public var bspTag: BSPTag
    public var splittingPlane: CPlane
    public var posNode: DrawingBSPTree
    public var negNode: DrawingBSPTree
    public var sphere: CSphere?
    public var inPolys: [UInt16]
    
    public init(bspTag: BSPTag, splittingPlane: CPlane, posNode: DrawingBSPTree, negNode: DrawingBSPTree, sphere: CSphere?, inPolys: [UInt16]) {
        self.bspTag = bspTag
        self.splittingPlane = splittingPlane
        self.posNode = posNode
        self.negNode = negNode
        self.sphere = sphere
        self.inPolys = inPolys
    }
}

public struct DrawingBSPLeaf {
    public var bspTag: BSPTag {
        return .LEAF
    }
    public var leafIndex: UInt32
    
    public init(leafIndex: UInt32) {
        self.leafIndex = leafIndex
    }
}
