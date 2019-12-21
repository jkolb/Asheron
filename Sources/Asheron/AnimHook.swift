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

public enum AnimHookType : Int32 {
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

public enum AnimHook : Packable {
    case noop(NOOP)
    case sound(Sound)
    case soundTable(SoundTable)
    case attack(Attack)
    case animDone(AnimDone)
    case replaceObject(ReplaceObject)
    case ethereal(Ethereal)
    case transparentPart(TransparentPart)
    case luminous(Luminous)
    case luminousPart(LuminousPart)
    case diffuse(Diffuse)
    case diffusePart(DiffusePart)
    case scale(Scale)
    case createParticle(CreateParticle)
    case destroyParticle(DestroyParticle)
    case stopParticle(StopParticle)
    case noDraw(NoDraw)
    case defaultScript(DefaultScript)
    case defaultScriptPart(DefaultScriptPart)
    case callPES(CallPES)
    case transparent(Transparent)
    case soundTweaked(SoundTweaked)
    case setOmega(SetOmega)
    case textureVelocity(TextureVelocity)
    case textureVelocityPart(TextureVelocityPart)
    case setLight(SetLight)
    case createBlockingParticle(CreateBlockingParticle)
    
    public enum Direction : Int32 {
        case unknown = -2
        case backward = -1
        case both = 0
        case forward = 1
    }
    
    public init(from dataStream: DataStream) {
        let type = AnimHookType(from: dataStream)
        
        switch type {
            
        case .unknown: fatalError()
        case .noop: self = .noop(NOOP(from: dataStream))
        case .sound: self = .sound(Sound(from: dataStream))
        case .soundTable: self = .soundTable(SoundTable(from: dataStream))
        case .attack: self = .attack(Attack(from: dataStream))
        case .animDone: self = .animDone(AnimDone(from: dataStream))
        case .replaceObject: self = .replaceObject(ReplaceObject(from: dataStream))
        case .ethereal: self = .ethereal(Ethereal(from: dataStream))
        case .transparentPart: self = .transparentPart(TransparentPart(from: dataStream))
        case .luminous: self = .luminous(Luminous(from: dataStream))
        case .luminousPart: self = .luminousPart(LuminousPart(from: dataStream))
        case .diffuse: self = .diffuse(Diffuse(from: dataStream))
        case .diffusePart: self = .diffusePart(DiffusePart(from: dataStream))
        case .scale: self = .scale(Scale(from: dataStream))
        case .createParticle: self = .createParticle(CreateParticle(from: dataStream))
        case .destroyParticle: self = .destroyParticle(DestroyParticle(from: dataStream))
        case .stopParticle: self = .stopParticle(StopParticle(from: dataStream))
        case .noDraw: self = .noDraw(NoDraw(from: dataStream))
        case .defaultScript: self = .defaultScript(DefaultScript(from: dataStream))
        case .defaultScriptPart: self = .defaultScriptPart(DefaultScriptPart(from: dataStream))
        case .callPES: self = .callPES(CallPES(from: dataStream))
        case .transparent: self = .transparent(Transparent(from: dataStream))
        case .soundTweaked: self = .soundTweaked(SoundTweaked(from: dataStream))
        case .setOmega: self = .setOmega(SetOmega(from: dataStream))
        case .textureVelocity: self = .textureVelocity(TextureVelocity(from: dataStream))
        case .textureVelocityPart: self = .textureVelocityPart(TextureVelocityPart(from: dataStream))
        case .setLight: self = .setLight(SetLight(from: dataStream))
        case .createBlockingParticle: self = .createBlockingParticle(CreateBlockingParticle(from: dataStream))
        }
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }

    public struct NOOP {
        public var direction: Direction
        
        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
        }
    }

    public struct Sound {
        public var direction: Direction
        public var gid: Identifier
        
        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.gid = Identifier(from: dataStream)
        }
    }

    public struct SoundTable {
        public var direction: Direction
        public var soundType: SoundType
        
        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.soundType = SoundType(from: dataStream)
        }
    }

    public struct AttackCone {
        public var partIndex: Int32
        public var left: Vector2
        public var right: Vector2
        public var radius: Float32
        public var height: Float32
        
        public init(from dataStream: DataStream) {
            self.partIndex = Int32(from: dataStream)
            self.left = Vector2(from: dataStream)
            self.right = Vector2(from: dataStream)
            self.radius = Float32(from: dataStream)
            self.height = Float32(from: dataStream)
        }
    }

    public struct Attack {
        public var direction: Direction
        public var attackCone: AttackCone
        
        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.attackCone = AttackCone(from: dataStream)
        }
    }

    public struct AnimDone {
        public var direction: Direction
        
        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
        }
    }

    public struct AnimPartChange {
        public var partIndex: UInt8
        public var partId: Identifier
        
        public init(from dataStream: DataStream) {
            self.partIndex = UInt8(from: dataStream)
            self.partId = Identifier(from: dataStream)
        }
    }

    public struct ReplaceObject {
        public var direction: Direction
        public var apChange: AnimPartChange
        
        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.apChange = AnimPartChange(from: dataStream)
        }
    }

    public struct Ethereal {
        public var direction: Direction
        public var ethereal: Int32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.ethereal = Int32(from: dataStream)
        }
    }

    public struct TransparentPart {
        public var direction: Direction
        public var part: Identifier
        public var start: Float32
        public var end: Float32
        public var time: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.part = Identifier(from: dataStream)
            self.start = Float32(from: dataStream)
            self.end = Float32(from: dataStream)
            self.time = Float32(from: dataStream)
        }
    }

    public struct Luminous {
        public var direction: Direction
        public var start: Float32
        public var end: Float32
        public var time: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.start = Float32(from: dataStream)
            self.end = Float32(from: dataStream)
            self.time = Float32(from: dataStream)
        }
    }

    public struct LuminousPart {
        public var direction: Direction
        public var part: Identifier
        public var start: Float32
        public var end: Float32
        public var time: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.part = Identifier(from: dataStream)
            self.start = Float32(from: dataStream)
            self.end = Float32(from: dataStream)
            self.time = Float32(from: dataStream)
        }
    }

    public struct Diffuse {
        public var direction: Direction
        public var start: Float32
        public var end: Float32
        public var time: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.start = Float32(from: dataStream)
            self.end = Float32(from: dataStream)
            self.time = Float32(from: dataStream)
        }
    }

    public struct DiffusePart {
        public var direction: Direction
        public var part: Identifier
        public var start: Float32
        public var end: Float32
        public var time: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.part = Identifier(from: dataStream)
            self.start = Float32(from: dataStream)
            self.end = Float32(from: dataStream)
            self.time = Float32(from: dataStream)
        }
    }

    public struct Scale {
        public var direction: Direction
        public var end: Float32
        public var time: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.end = Float32(from: dataStream)
            self.time = Float32(from: dataStream)
        }
    }

    public struct CreateParticle {
        public var direction: Direction
        public var partIndex: UInt32
        public var offset: Frame
        public var emitterId: Identifier

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.partIndex = UInt32(from: dataStream)
            self.offset = Frame(from: dataStream)
            self.emitterId = Identifier(from: dataStream)
        }
    }

    public struct DestroyParticle {
        public var direction: Direction
        public var emitterId: Identifier

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.emitterId = Identifier(from: dataStream)
        }
    }

    public struct StopParticle {
        public var direction: Direction
        public var emitterId: Identifier

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.emitterId = Identifier(from: dataStream)
        }
    }

    public struct NoDraw {
        public var direction: Direction
        public var noDraw: UInt32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.noDraw = UInt32(from: dataStream)
        }
    }

    public struct DefaultScript {
        public var direction: Direction

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
        }
    }

    public struct DefaultScriptPart {
        public var direction: Direction
        public var partIndex: UInt32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.partIndex = UInt32(from: dataStream)
        }
    }

    public struct CallPES {
        public var direction: Direction
        public var pes: Identifier
        public var pause: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.pes = Identifier(from: dataStream)
            self.pause = Float32(from: dataStream)
        }
    }

    public struct Transparent {
        public var direction: Direction
        public var start: Float32
        public var end: Float32
        public var time: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.start = Float32(from: dataStream)
            self.end = Float32(from: dataStream)
            self.time = Float32(from: dataStream)
        }
    }

    public struct SoundTweaked {
        public var direction: Direction
        public var gid: Identifier
        public var prio: Float32
        public var prob: Float32
        public var vol: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.gid = Identifier(from: dataStream)
            self.prio = Float32(from: dataStream)
            self.prob = Float32(from: dataStream)
            self.vol = Float32(from: dataStream)
        }
    }

    public struct SetOmega {
        public var direction: Direction
        public var axis: Vector3

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.axis = Vector3(from: dataStream)
        }
    }

    public struct TextureVelocity {
        public var direction: Direction
        public var uSpeed: Float32
        public var vSpeed: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.uSpeed = Float32(from: dataStream)
            self.vSpeed = Float32(from: dataStream)
        }
    }

    public struct TextureVelocityPart {
        public var direction: Direction
        public var partIndex: UInt32
        public var uSpeed: Float32
        public var vSpeed: Float32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.partIndex = UInt32(from: dataStream)
            self.uSpeed = Float32(from: dataStream)
            self.vSpeed = Float32(from: dataStream)
        }
    }

    public struct SetLight {
        public var direction: Direction
        public var lightsOn: Int32

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
            self.lightsOn = Int32(from: dataStream)
        }
    }

    public struct CreateBlockingParticle {
        public var direction: Direction

        public init(from dataStream: DataStream) {
            self.direction = Direction(from: dataStream)
        }
    }
}
