/*
The MIT License (MIT)

Copyright (c) 2020 Justin Kolb

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

public final class Setup : Identifiable {
    public struct Flags : OptionSet, Packable {
        public static let hasParentIndex   = Flags(rawValue: 1 << 0)
        public static let hasDefaultScale  = Flags(rawValue: 1 << 1)
        public static let allowFreeHeading = Flags(rawValue: 1 << 2)
        public static let hasCollisionBSP  = Flags(rawValue: 1 << 3)

        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
    public var id: Identifier
    public var parts: [Identifier]
    public var parentIndex: [UInt32]
    public var defaultScale: [Vector3]
    public var allowFreeHeading: Bool
    public var hasCollisionBSP: Bool
    public var holdingLocations: [UInt32:LocationType]
    public var connectionPoints: [UInt32:LocationType]
    public var placementFrames: [UInt32:PlacementType]
    public var cylSphere: [CylSphere]
    public var sphere: [Sphere]
    public var height: Float32
    public var radius: Float32
    public var stepDownHeight: Float32
    public var stepUpHeight: Float32
    public var sortingSphere: Sphere
    public var selectionSphere: Sphere
    public var lights: [UInt32:LightInfo]
    public var defaultAnimId: Identifier
    public var defaultScriptId: Identifier
    public var defaultMTable: Identifier
    public var defaultSTable: Identifier
    public var defaultPhsTable: Identifier

    public init(from dataStream: DataStream, id: Identifier) {
        let diskId = Identifier(from: dataStream)
        precondition(diskId == id)
        self.id = id
        let flags = Flags(from: dataStream)
        self.allowFreeHeading = flags.contains(.allowFreeHeading)
        self.hasCollisionBSP = flags.contains(.hasCollisionBSP)
        let numParts = Int32(from: dataStream)
        self.parts = [Identifier](from: dataStream, count: numericCast(numParts))
        self.parentIndex = flags.contains(.hasParentIndex) ? [UInt32](from: dataStream, count: numericCast(numParts)) : []
        self.defaultScale = flags.contains(.hasDefaultScale) ? [Vector3](from: dataStream, count: numericCast(numParts)) : []
        self.holdingLocations = [UInt32:LocationType](from: dataStream)
        self.connectionPoints = [UInt32:LocationType](from: dataStream)
        self.placementFrames = [UInt32:PlacementType](from: dataStream, valueCount: numericCast(numParts))
        self.cylSphere = [CylSphere](from: dataStream)
        self.sphere = [Sphere](from: dataStream)
        self.height = Float32(from: dataStream)
        self.radius = Float32(from: dataStream)
        self.stepDownHeight = Float32(from: dataStream)
        self.stepUpHeight = Float32(from: dataStream)
        self.sortingSphere = Sphere(from: dataStream)
        self.selectionSphere = Sphere(from: dataStream)
        self.lights = [UInt32:LightInfo](from: dataStream)
        self.defaultAnimId = Identifier(from: dataStream)
        self.defaultScriptId = Identifier(from: dataStream)
        self.defaultMTable = Identifier(from: dataStream)
        self.defaultSTable = Identifier(from: dataStream)
        self.defaultPhsTable = Identifier(from: dataStream)
    }
}

public struct AnimFrame {
    public var frame: [Frame]
    public var hooks: [AnimHook]
    
    public init(from dataStream: DataStream, count: Int) {
        self.frame = [Frame](from: dataStream, count: count)
        self.hooks = [AnimHook](from: dataStream)
    }
}

public struct LocationType : Packable {
    public var partId: UInt32
    public var frame: Frame
    
    public init(from dataStream: DataStream) {
        self.partId = UInt32(from: dataStream)
        self.frame = Frame(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct PlacementType : CountPackable {
    public var animFrame: AnimFrame
    
    public init(from dataStream: DataStream, count: Int) {
        self.animFrame = AnimFrame(from: dataStream, count: count)
    }
}

public enum LightType : Int32 {
    case invalid = -1
    case point = 0
    case distant = 1
    case spot = 2
}

public struct LightInfo : Packable {
    public var type: LightType
    public var offset: Frame
    public var color: ARGB8888 // RGBColor
    public var intensity: Float32
    public var falloff: Float32
    public var coneAngle: Float32
    
    public init(from dataStream: DataStream) {
        self.type = .invalid
        self.offset = Frame(from: dataStream)
        self.color = ARGB8888(from: dataStream)
        self.intensity = Float32(from: dataStream)
        self.falloff = Float32(from: dataStream)
        self.coneAngle = Float32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}
