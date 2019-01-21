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

public struct CSetupFlags : OptionSet {
    public static let hasParentIndex   = CSetupFlags(rawValue: 1 << 0)
    public static let hasDefaultScale  = CSetupFlags(rawValue: 1 << 1)
    public static let allowFreeHeading = CSetupFlags(rawValue: 1 << 2)
    public static let hasPhysicsBSP    = CSetupFlags(rawValue: 1 << 3)
    
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

public enum CAnimHookType : Int32 {
    case unknown = -1
    case noop = 0
    case sound = 1
    case soundTable = 2
    case attack = 3
    case animDone = 4
    case replaceObject = 5
    case ethereal = 6
    case transparentPart = 7
    case luminous = 8
    case luminousPart = 9
    case diffuse = 10
    case diffusePart = 11
    case scale = 12
    case createParticle = 13
    case destroyParticle = 14
    case stopParticle = 15
    case noDraw = 16
    case defaultScript = 17
    case defaultScriptPart = 18
    case callPES = 19
    case transparent = 20
    case soundTweaked = 21
    case setOmega = 22
    case textureVelocity = 23
    case textureVelocityPart = 24
    case setLight = 25
    case createBlockingParticle = 26
}

public final class CSetupInputStream : DatInputStream {
    public func readCSetup(portalId: PortalId<CSetup>) throws -> CSetup {
        let streamID = try readPortalId(type: CSetup.self)
        precondition(streamID == portalId)
        let flags = CSetupFlags(rawValue: try readUInt32())
        let allowFreeHeading = flags.contains(.allowFreeHeading)
        let hasPhysicsBSP = flags.contains(.hasPhysicsBSP)
        let numParts = try readCount()
        let parts = try readArray(count: numParts, readElement: { try readPortalId(type: CGfxObj.self) })
        let parentIndex = flags.contains(.hasParentIndex) ? try readArray(count: numParts, readElement: { Int(try readUInt32()) }) : []
        let defaultScale = flags.contains(.hasDefaultScale) ? try readArray(count: numParts, readElement: readVector3) : []
        let holdingLocations = try readDictionary(readKey: readUInt32, readValue: readLocationType)
        let connectionPoints = try readDictionary(readKey: readUInt32, readValue: readLocationType)
        let placementFrames = try readDictionary(readKey: readUInt32, readValue: { try readPlacementType(numParts: numParts) })
        let cylSphere = try readArray(readElement: readCylSphere)
        let sphere = try readArray(readElement: { try readSphere()! })
        let height = try readFloat32()
        let radius = try readFloat32()
        let stepDownHeight = try readFloat32()
        let stepUpHeight = try readFloat32()
        let sortingSphere = try readSphere()!
        let selectionSphere = try readSphere()!
        let lights = try readDictionary(readKey: readUInt32, readValue: readLightInfo)
        let defaultAnimId = try readHandle()
        let defaultScriptId = try readHandle()
        let defaultMTable = try readHandle()
        let defaultSTable = try readHandle()
        let defaultPhsTable = try readHandle()

        return CSetup(portalId: portalId, parts: parts, parentIndex: parentIndex, defaultScale: defaultScale, allowFreeHeading: allowFreeHeading, hasPhysicsBSP: hasPhysicsBSP, holdingLocations: holdingLocations, connectionPoints: connectionPoints, placementFrames: placementFrames, cylSphere: cylSphere, sphere: sphere, height: height, radius: radius, stepDownHeight: stepDownHeight, stepUpHeight: stepUpHeight, sortingSphere: sortingSphere, selectionSphere: selectionSphere, lights: lights, defaultAnimId: defaultAnimId, defaultScriptId: defaultScriptId, defaultMTable: defaultMTable, defaultSTable: defaultSTable, defaultPhsTable: defaultPhsTable)
    }
    
    @inline(__always)
    private func readLocationType() throws -> LocationType {
        let partId = try readUInt32()
        let frame = try readFrame()
        
        return LocationType(partId: partId, frame: frame)
    }
    
    @inline(__always)
    private func readFrame() throws -> Frame {
        let origin = try readVector3()
        let quaternion = try readQuaternion()
        
        return Frame(origin: origin, quaternion: quaternion)
    }
    
    @inline(__always)
    private func readPlacementType(numParts: Int32) throws -> PlacementType {
        let animFrame = try readAnimFrame(numParts: numParts)
        
        return PlacementType(animFrame: animFrame)
    }
    
    @inline(__always)
    private func readAnimFrame(numParts: Int32) throws -> AnimFrame {
        let frame = try readArray(count: numParts, readElement: readFrame)
        let hooks = try readArray(readElement: readCAnimHook)
        
        return AnimFrame(frame: frame, hooks: hooks)
    }
    
    @inline(__always)
    private func readCAnimHook() throws -> CAnimHook {
        let type = CAnimHookType(rawValue: try readInt32())!
        
        switch type {
            
        case .unknown: fatalError()
        case .noop: return .noop(try readNOOPHook())
        case .sound: return .sound(try readSoundHook())
        case .soundTable: return .soundTable(try readSoundTableHook())
        case .attack: return .attack(try readAttackHook())
        case .animDone: return .animDone(try readAnimDoneHook())
        case .replaceObject: return .replaceObject(try readReplaceObjectHook())
        case .ethereal: return .ethereal(try readEtherealHook())
        case .transparentPart: return .transparentPart(try readTransparentPartHook())
        case .luminous: return .luminous(try readLuminousHook())
        case .luminousPart: return .luminousPart(try readLuminousPartHook())
        case .diffuse: return .diffuse(try readDiffuseHook())
        case .diffusePart: return .diffusePart(try readDiffusePartHook())
        case .scale: return .scale(try readScaleHook())
        case .createParticle: return .createParticle(try readCreateParticleHook())
        case .destroyParticle: return .destroyParticle(try readDestroyParticleHook())
        case .stopParticle: return .stopParticle(try readStopParticleHook())
        case .noDraw: return .noDraw(try readNoDrawHook())
        case .defaultScript: return .defaultScript(try readDefaultScriptHook())
        case .defaultScriptPart: return .defaultScriptPart(try readDefaultScriptPartHook())
        case .callPES: return .callPES(try readCallPESHook())
        case .transparent: return .transparent(try readTransparentHook())
        case .soundTweaked: return .soundTweaked(try readSoundTweakedHook())
        case .setOmega: return .setOmega(try readSetOmegaHook())
        case .textureVelocity: return .textureVelocity(try readTextureVelocityHook())
        case .textureVelocityPart: return .textureVelocityPart(try readTextureVelocityPartHook())
        case .setLight: return .setLight(try readSetLightHook())
        case .createBlockingParticle: return .createBlockingParticle(try readCreateBlockingParticleHook())
        }
    }
    
    @inline(__always)
    private func readNOOPHook() throws -> NOOPHook {
        let direction = try readCAnimHookDirection()
        
        return NOOPHook(direction: direction)
    }
    
    @inline(__always)
    private func readSoundHook() throws -> SoundHook {
        let direction = try readCAnimHookDirection()
        let gid = try readHandle()
        
        return SoundHook(direction: direction, gid: gid)
    }
    
    @inline(__always)
    private func readSoundTableHook() throws -> SoundTableHook {
        let direction = try readCAnimHookDirection()
        let soundType = SoundType(rawValue: try readInt32())!
        
        return SoundTableHook(direction: direction, soundType: soundType)
    }

    @inline(__always)
    private func readAttackHook() throws -> AttackHook {
        let direction = try readCAnimHookDirection()
        let attackCone = try readAttackCone()
        
        return AttackHook(direction: direction, attackCone: attackCone)
    }

    @inline(__always)
    private func readAnimDoneHook() throws -> AnimDoneHook {
        let direction = try readCAnimHookDirection()
        
        return AnimDoneHook(direction: direction)
    }
    
    @inline(__always)
    private func readReplaceObjectHook() throws -> ReplaceObjectHook {
        let direction = try readCAnimHookDirection()
        let apChange = try readAnimPartChange()
        
        return ReplaceObjectHook(direction: direction, apChange: apChange)
    }

    @inline(__always)
    private func readEtherealHook() throws -> EtherealHook {
        let direction = try readCAnimHookDirection()
        let ethereal = try readInt32()
        
        return EtherealHook(direction: direction, ethereal: ethereal)
    }

    @inline(__always)
    private func readTransparentPartHook() throws -> TransparentPartHook {
        let direction = try readCAnimHookDirection()
        let part = try readHandle()
        let start = try readFloat32()
        let end = try readFloat32()
        let time = try readFloat32()

        return TransparentPartHook(direction: direction, part: part, start: start, end: end, time: time)
    }

    @inline(__always)
    private func readLuminousHook() throws -> LuminousHook {
        let direction = try readCAnimHookDirection()
        let start = try readFloat32()
        let end = try readFloat32()
        let time = try readFloat32()
        
        return LuminousHook(direction: direction, start: start, end: end, time: time)
    }

    @inline(__always)
    private func readLuminousPartHook() throws -> LuminousPartHook {
        let direction = try readCAnimHookDirection()
        let part = try readHandle()
        let start = try readFloat32()
        let end = try readFloat32()
        let time = try readFloat32()
        
        return LuminousPartHook(direction: direction, part: part, start: start, end: end, time: time)
    }

    @inline(__always)
    private func readDiffuseHook() throws -> DiffuseHook {
        let direction = try readCAnimHookDirection()
        let start = try readFloat32()
        let end = try readFloat32()
        let time = try readFloat32()
        
        return DiffuseHook(direction: direction, start: start, end: end, time: time)
    }

    @inline(__always)
    private func readDiffusePartHook() throws -> DiffusePartHook {
        let direction = try readCAnimHookDirection()
        let part = try readHandle()
        let start = try readFloat32()
        let end = try readFloat32()
        let time = try readFloat32()
        
        return DiffusePartHook(direction: direction, part: part, start: start, end: end, time: time)
    }

    @inline(__always)
    private func readScaleHook() throws -> ScaleHook {
        let direction = try readCAnimHookDirection()
        let end = try readFloat32()
        let time = try readFloat32()

        return ScaleHook(direction: direction, end: end, time: time)
    }

    @inline(__always)
    private func readCreateParticleHook() throws -> CreateParticleHook {
        let direction = try readCAnimHookDirection()
        let partIndex = try readUInt32()
        let offset = try readFrame()
        let emitterId = try readHandle()

        return CreateParticleHook(direction: direction, partIndex: partIndex, offset: offset, emitterId: emitterId)
    }

    @inline(__always)
    private func readDestroyParticleHook() throws -> DestroyParticleHook {
        let direction = try readCAnimHookDirection()
        let emitterId = try readHandle()

        return DestroyParticleHook(direction: direction, emitterId: emitterId)
    }

    @inline(__always)
    private func readStopParticleHook() throws -> StopParticleHook {
        let direction = try readCAnimHookDirection()
        let emitterId = try readHandle()

        return StopParticleHook(direction: direction, emitterId: emitterId)
    }

    @inline(__always)
    private func readNoDrawHook() throws -> NoDrawHook {
        let direction = try readCAnimHookDirection()
        let noDraw = try readUInt32()
        
        return NoDrawHook(direction: direction, noDraw: noDraw)
    }

    @inline(__always)
    private func readDefaultScriptHook() throws -> DefaultScriptHook {
        let direction = try readCAnimHookDirection()
        
        return DefaultScriptHook(direction: direction)
    }

    @inline(__always)
    private func readDefaultScriptPartHook() throws -> DefaultScriptPartHook {
        let direction = try readCAnimHookDirection()
        let partIndex = try readUInt32()

        return DefaultScriptPartHook(direction: direction, partIndex: partIndex)
    }

    @inline(__always)
    private func readCallPESHook() throws -> CallPESHook {
        let direction = try readCAnimHookDirection()
        let pes = try readHandle()
        let pause = try readFloat32()
        
        return CallPESHook(direction: direction, pes: pes, pause: pause)
    }

    @inline(__always)
    private func readTransparentHook() throws -> TransparentHook {
        let direction = try readCAnimHookDirection()
        let start = try readFloat32()
        let end = try readFloat32()
        let time = try readFloat32()

        return TransparentHook(direction: direction, start: start, end: end, time: time)
    }

    @inline(__always)
    private func readSoundTweakedHook() throws -> SoundTweakedHook {
        let direction = try readCAnimHookDirection()
        let gid = try readHandle()
        let prio = try readFloat32()
        let prob = try readFloat32()
        let vol = try readFloat32()

        return SoundTweakedHook(direction: direction, gid: gid, prio: prio, prob: prob, vol: vol)
    }

    @inline(__always)
    private func readSetOmegaHook() throws -> SetOmegaHook {
        let direction = try readCAnimHookDirection()
        let axis = try readVector3()
        
        return SetOmegaHook(direction: direction, axis: axis)
    }

    @inline(__always)
    private func readTextureVelocityHook() throws -> TextureVelocityHook {
        let direction = try readCAnimHookDirection()
        let uSpeed = try readFloat32()
        let vSpeed = try readFloat32()

        return TextureVelocityHook(direction: direction, uSpeed: uSpeed, vSpeed: vSpeed)
    }

    @inline(__always)
    private func readTextureVelocityPartHook() throws -> TextureVelocityPartHook {
        let direction = try readCAnimHookDirection()
        let partIndex = try readUInt32()
        let uSpeed = try readFloat32()
        let vSpeed = try readFloat32()

        return TextureVelocityPartHook(direction: direction, partIndex: partIndex, uSpeed: uSpeed, vSpeed: vSpeed)
    }

    @inline(__always)
    private func readSetLightHook() throws -> SetLightHook {
        let direction = try readCAnimHookDirection()
        let lightsOn = try readInt32()
        
        return SetLightHook(direction: direction, lightsOn: lightsOn)
    }

    @inline(__always)
    private func readCreateBlockingParticleHook() throws -> CreateBlockingParticleHook {
        let direction = try readCAnimHookDirection()
        
        return CreateBlockingParticleHook(direction: direction)
    }

    @inline(__always)
    private func readCAnimHookDirection() throws -> CAnimHook.Direction {
        let rawValue = try readInt32()
        
        return CAnimHook.Direction(rawValue: rawValue)!
    }
    
    @inline(__always)
    private func readAttackCone() throws -> AttackCone {
        let partIndex = try readInt32()
        let left = try readVector2()
        let right = try readVector2()
        let radius = try readFloat32()
        let height = try readFloat32()

        return AttackCone(partIndex: partIndex, left: left, right: right, radius: radius, height: height)
    }
    
    @inline(__always)
    private func readVector2() throws -> Vector2 {
        let x = try readFloat32()
        let y = try readFloat32()
        
        return Vector2(x, y)
    }
    
    @inline(__always)
    private func readAnimPartChange() throws -> AnimPartChange {
        let partIndex = try readUInt8()
        let partId = try readPortalId(type: CGfxObj.self)
        
        return AnimPartChange(partIndex: partIndex, partId: partId)
    }
    
    @inline(__always)
    private func readCylSphere() throws -> CylSphere {
        let lowPt = try readVector3()
        let height = try readFloat32()
        let radius = try readFloat32()

        return CylSphere(lowPt: lowPt, height: height, radius: radius)
    }
    
    @inline(__always)
    private func readLightInfo() throws -> LightInfo {
        let offset = try readFrame()
        let color = try readColorARGB8888()
        let intensity = try readFloat32()
        let falloff = try readFloat32()
        let coneAngle = try readFloat32()

        return LightInfo(type: LightType.INVALID_LIGHT_TYPE, offset: offset, color: color, intensity: intensity, falloff: falloff, coneAngle: coneAngle)
    }
}
