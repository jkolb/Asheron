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

public final class CSetup : PortalObject {
    public struct Flags : OptionSet {
        public static let hasParentIndex   = Flags(rawValue: 1 << 0)
        public static let hasDefaultScale  = Flags(rawValue: 1 << 1)
        public static let allowFreeHeading = Flags(rawValue: 1 << 2)
        public static let hasPhysicsBSP    = Flags(rawValue: 1 << 3)

        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
    public static var kind: PortalKind = .cSetup
    public var portalId: PortalId<CSetup>
    public var parts: [PortalId<CGfxObj>]
    public var parentIndex: [Int]
    public var defaultScale: [Vector3<Float>]
    public var allowFreeHeading: Bool
    public var hasPhysicsBSP: Bool
    public var holdingLocations: [UInt32:LocationType]
    public var connectionPoints: [UInt32:LocationType]
    public var placementFrames: [UInt32:PlacementType]
    public var cylSphere: [CylSphere]
    public var sphere: [Sphere<Float>]
    public var height: Float
    public var radius: Float
    public var stepDownHeight: Float
    public var stepUpHeight: Float
    public var sortingSphere: Sphere<Float>
    public var selectionSphere: Sphere<Float>
    public var lights: [UInt32:LightInfo]
    public var defaultAnimId: Handle
    public var defaultScriptId: Handle
    public var defaultMTable: Handle
    public var defaultSTable: Handle
    public var defaultPhsTable: Handle

    public init(portalId: PortalId<CSetup>, parts: [PortalId<CGfxObj>], parentIndex: [Int], defaultScale: [Vector3<Float>], allowFreeHeading: Bool, hasPhysicsBSP: Bool, holdingLocations: [UInt32:LocationType], connectionPoints: [UInt32:LocationType], placementFrames: [UInt32:PlacementType], cylSphere: [CylSphere], sphere: [Sphere<Float>], height: Float, radius: Float, stepDownHeight: Float, stepUpHeight: Float, sortingSphere: Sphere<Float>, selectionSphere: Sphere<Float>, lights: [UInt32:LightInfo], defaultAnimId: Handle, defaultScriptId: Handle, defaultMTable: Handle, defaultSTable: Handle, defaultPhsTable: Handle) {
        self.portalId = portalId
        self.parts = parts
        self.parentIndex = parentIndex
        self.defaultScale = defaultScale
        self.allowFreeHeading = allowFreeHeading
        self.hasPhysicsBSP = hasPhysicsBSP
        self.holdingLocations = holdingLocations
        self.connectionPoints = connectionPoints
        self.placementFrames = placementFrames
        self.cylSphere = cylSphere
        self.sphere = sphere
        self.height = height
        self.radius = radius
        self.stepDownHeight = stepDownHeight
        self.stepUpHeight = stepUpHeight
        self.sortingSphere = sortingSphere
        self.selectionSphere = selectionSphere
        self.lights = lights
        self.defaultAnimId = defaultAnimId
        self.defaultScriptId = defaultScriptId
        self.defaultMTable = defaultMTable
        self.defaultSTable = defaultSTable
        self.defaultPhsTable = defaultPhsTable
    }
}
