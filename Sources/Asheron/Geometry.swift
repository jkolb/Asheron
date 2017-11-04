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

public final class Geometry : PortalObject {
    public struct Flags : OptionSet {
        public static let collidable = Flags(rawValue: 1 << 0)
        public static let renderable = Flags(rawValue: 1 << 1)
        public static let degradable = Flags(rawValue: 1 << 3)
        
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
    
    public static let kind = PortalKind.geometry
    
    public let handle: GeometryHandle
    public var flags: Flags = []
    public var material: [MaterialHandle] = []
    public var unknown1: UInt32 = 0
    public var vertex: [Vertex] = []
    public var unknown2: UInt16 = 0
    public var collisionPolygon: [Polygon] = []
    public var collisionTree: BSPCollisionTree = .empty
    public var center: Vector3<Float> = Vector3<Float>()
    public var renderPolygon: [Polygon] = []
    public var renderTree: BSPRenderTree = .empty
    public var unknown3: UInt32 = 0
    
    public init(handle: GeometryHandle) {
        self.handle = handle
    }
}
