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

import Swiftish

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
    
    public enum Tag : String {
        case LEAF = "LEAF"
        
        // Front child only
        case BPnn = "BPnn"
        case BPIn = "BPIn"
        
        // Back child only
        case BpIN = "BpIN"
        case BpnN = "BpnN"
        
        // Both front and back children
        case BPIN = "BPIN"
        case BPnN = "BPnN"
        case PORT = "PORT"
        
        // Neither child
        case BpIn = "BpIn"
        case BPOL = "BPOL"
        
        public var hasFront: Bool {
            switch self {
            case .LEAF:
                return false
                
            case .BPnn:
                return true
                
            case .BPIn:
                return true
                
            case .BpIN:
                return false
                
            case .BpnN:
                return false
                
            case .BPIN:
                return true
                
            case .BPnN:
                return true
                
            case .BpIn:
                return false
                
            case .BPOL:
                return false
                
            case .PORT:
                return true
            }
        }
        
        public var hasBack: Bool {
            switch self {
            case .LEAF:
                return false
                
            case .BPnn:
                return false
                
            case .BPIn:
                return false
                
            case .BpIN:
                return true
                
            case .BpnN:
                return true
                
            case .BPIN:
                return true
                
            case .BPnN:
                return true
                
            case .BpIn:
                return false
                
            case .BPOL:
                return false
                
            case .PORT:
                return true
            }
        }
    }
}
