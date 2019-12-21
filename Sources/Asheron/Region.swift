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

public final class Region : Identifiable {
    public var id: Identifier
    public var regionNumber: UInt32
    public var version: UInt32
    public var regionName: String  // ReadPString "Dereth" align if needed afterwards
    public var landDefs: LandDefs
    public var gameTime: GameTime
    public var partsMask: PartsMask // 0x21F = 10 0001 1111
//    public var minimizePal: UInt32
    public var fileInfo: FileNameDesc = FileNameDesc()
    public var skyInfo: SkyDesc?
    public var soundInfo: SoundDesc?
    public var sceneInfo: SceneDesc?
    public var terrainInfo: TerrainDesc?
    public var encounterInfo: EncounterDesc?
    public var waterInfo: WaterDesc?
    public var fogInfo: FogDesc?
    public var distFogInfo: DistanceFogDesc?
    public var regionMapInfo: RegionMapDesc?
    public var regionMisc: RegionMisc?
    
    public struct PartsMask : OptionSet, Packable {
        public static let hasSound     = PartsMask(rawValue: 0b0000000001)
        public static let hasScene     = PartsMask(rawValue: 0b0000000010)
        public static let hasTerrain   = PartsMask(rawValue: 0b0000000100)
        public static let hasEncounter = PartsMask(rawValue: 0b0000001000)
        public static let hasSky       = PartsMask(rawValue: 0b0000010000)
        public static let hasWater     = PartsMask(rawValue: 0b0000100000)
        public static let hasFog       = PartsMask(rawValue: 0b0001000000)
        public static let hasDistFog   = PartsMask(rawValue: 0b0010000000)
        public static let hasRegionMap = PartsMask(rawValue: 0b0100000000)
        public static let hasMisc      = PartsMask(rawValue: 0b1000000000)
        
        public let rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
    
    public init(from dataStream: DataStream, id: Identifier) {
        let diskId = Identifier(from: dataStream)
        precondition(diskId == id)
        self.id = id
        self.regionNumber = UInt32(from: dataStream)
        self.version = UInt32(from: dataStream)
        self.regionName = String(from: dataStream)
        self.landDefs = LandDefs(from: dataStream)
        self.gameTime = GameTime(from: dataStream)
        self.partsMask = PartsMask(from: dataStream)
        self.skyInfo = partsMask.contains(.hasSky) ? SkyDesc(from: dataStream) : nil
        self.soundInfo = partsMask.contains(.hasSound) ? SoundDesc(from: dataStream) : nil
        self.sceneInfo = partsMask.contains(.hasScene) ? SceneDesc(from: dataStream) : nil
        self.terrainInfo = partsMask.contains(.hasTerrain) ? TerrainDesc(from: dataStream) : nil
        self.encounterInfo = partsMask.contains(.hasEncounter) ? EncounterDesc(from: dataStream) : nil
        self.waterInfo = partsMask.contains(.hasWater) ? WaterDesc(from: dataStream) : nil
        self.fogInfo = partsMask.contains(.hasFog) ? FogDesc(from: dataStream) : nil
        self.distFogInfo = partsMask.contains(.hasDistFog) ? DistanceFogDesc(from: dataStream) : nil
        self.regionMapInfo = partsMask.contains(.hasRegionMap) ? RegionMapDesc(from: dataStream) : nil
        self.regionMisc = partsMask.contains(.hasMisc) ? RegionMisc(from: dataStream) : nil
    }
}

// 0x00012692
public struct SkyDesc : Packable {
    //public var presentDayGroup: UInt32
    public var tickSize: Float64
    public var lightTickSize: Float64
    public var dayGroups: [DayGroup]
    
    public init(from dataStream: DataStream) {
        self.tickSize = Float64(from: dataStream)
        self.lightTickSize = Float64(from: dataStream)
        self.dayGroups = [DayGroup](from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct SkyTimeOfDay : Packable {
    public var begin: Float32
    public var dirBright: Float32
    public var dirHeading: Float32
    public var dirPitch: Float32
    public var dirColor: ARGB8888
    public var ambBright: Float32
    public var ambColor: ARGB8888
    public var minWorldFog: Float32
    public var maxWorldFog: Float32
    public var worldFogColor: ARGB8888
    public var worldFog: UInt32
    public var skyObjReplace: [SkyObjectReplace]
    
    public init(from dataStream: DataStream) {
        self.begin = Float32(from: dataStream)
        self.dirBright = Float32(from: dataStream)
        self.dirHeading = Float32(from: dataStream)
        self.dirPitch = Float32(from: dataStream)
        self.dirColor = ARGB8888(from: dataStream)
        self.ambBright = Float32(from: dataStream)
        self.ambColor = ARGB8888(from: dataStream)
        self.minWorldFog = Float32(from: dataStream)
        self.maxWorldFog = Float32(from: dataStream)
        self.worldFogColor = ARGB8888(from: dataStream)
        self.worldFog = UInt32(from: dataStream)
        self.skyObjReplace = [SkyObjectReplace](from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct SkyObject : Packable {
    //public var objectName: String = "" // Not in file
    public var beginTime: Float32
    public var endTime: Float32
    public var beginAngle: Float32
    public var endAngle: Float32
    public var texVelocity: Vector3
    public var defaultGFXObject: Identifier
    public var defaultPesObject: Identifier
    public var properties: UInt32
    
    public init(from dataStream: DataStream) {
        self.beginTime = Float32(from: dataStream)
        self.endTime = Float32(from: dataStream)
        self.beginAngle = Float32(from: dataStream)
        self.endAngle = Float32(from: dataStream)
        let texVelocityX = Float32(from: dataStream)
        let texVelocityY = Float32(from: dataStream)
        self.texVelocity = Vector3(x: texVelocityX, y: texVelocityY, z: 0.0)
        self.defaultGFXObject = Identifier(from: dataStream)
        self.defaultPesObject = Identifier(from: dataStream)
        self.properties = UInt32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct SkyObjectReplace : Packable {
    public var objectIndex: UInt32
    public var gfxObjID: Identifier
    public var rotate: Float32
    public var transparent: Float32
    public var luminosity: Float32
    public var maxBright: Float32
    //public var object: UInt32 // Temp
    
    public init(from dataStream: DataStream) {
        self.objectIndex = UInt32(from: dataStream)
        self.gfxObjID = Identifier(from: dataStream)
        self.rotate = Float32(from: dataStream)
        self.transparent = Float32(from: dataStream)
        self.luminosity = Float32(from: dataStream)
        self.maxBright = Float32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct TMTerrainDesc : Packable {
    public var terrainType: LandDefs.TerrainType
    public var terrainTex: TerrainTex // PDB says -> [TerrainTex], but there isn't a count

    public init(from dataStream: DataStream) {
        self.terrainType = LandDefs.TerrainType(from: dataStream)
        self.terrainTex = TerrainTex(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct TexMerge : Packable {
    public var baseTexSize: UInt32
    public var cornerTerrainMaps: [TerrainAlphaMap]
    public var sideTerrainMaps: [TerrainAlphaMap]
    public var roadMaps: [RoadAlphaMap]
    public var terrainDesc: [TMTerrainDesc]
    
    public init(from dataStream: DataStream) {
        self.baseTexSize = UInt32(from: dataStream)
        self.cornerTerrainMaps = [TerrainAlphaMap](from: dataStream)
        self.sideTerrainMaps = [TerrainAlphaMap](from: dataStream)
        self.roadMaps = [RoadAlphaMap](from: dataStream)
        self.terrainDesc = [TMTerrainDesc](from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct TerrainTex : Packable {
    public var tex: Identifier
    // These two are in PDB but not file?
    //        public let baseTexture: UInt32 // type = 0x7920
    //        public let minSlope: Float32
    public var texTiling: UInt32
    public var maxVertBright: UInt32
    public var minVertBright: UInt32
    public var maxVertSaturate: UInt32
    public var minVertSaturate: UInt32
    public var maxVertHue: UInt32
    public var minVertHue: UInt32
    public var detailTexTiling: UInt32
    public var detailTex: Identifier
    
    public init(from dataStream: DataStream) {
        self.tex = Identifier(from: dataStream)
        self.texTiling = UInt32(from: dataStream)
        self.maxVertBright = UInt32(from: dataStream)
        self.minVertBright = UInt32(from: dataStream)
        self.maxVertSaturate = UInt32(from: dataStream)
        self.minVertSaturate = UInt32(from: dataStream)
        self.maxVertHue = UInt32(from: dataStream)
        self.minVertHue = UInt32(from: dataStream)
        self.detailTexTiling = UInt32(from: dataStream)
        self.detailTex = Identifier(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public enum RCode : UInt32, Packable {
    case corner = 8
    case straight = 9
    case diagonal = 10
}

public enum TCode : UInt32, Packable {
    case corner = 8
    case straight = 9
    case diagonal = 10
}

public struct TerrainAlphaMap : Packable {
    public var tcode: TCode
    public var tex: Identifier
    
    public init(from dataStream: DataStream) {
        self.tcode = TCode(from: dataStream)
        self.tex = Identifier(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct RoadAlphaMap : Packable {
    public var rcode: RCode
    public var roadTex: Identifier

    public init(from dataStream: DataStream) {
        self.rcode = RCode(from: dataStream)
        self.roadTex = Identifier(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

// 0x0001269d
public struct RegionMisc : Packable {
    public var version: UInt32
    public var gameMap: Identifier
    public var autotestMap: Identifier
    public var autotestMapSize: UInt32
    public var clearCell: UInt32 // identifier?
    public var clearMonster: UInt32 // identifier?
    
    public init(from dataStream: DataStream) {
        self.version = UInt32(from: dataStream)
        self.gameMap = Identifier(from: dataStream)
        self.autotestMap = Identifier(from: dataStream)
        self.autotestMapSize = UInt32(from: dataStream)
        self.clearCell = UInt32(from: dataStream)
        self.clearMonster = UInt32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

// Empty definitions in PDB
public struct RegionMapDesc : Packable {
    public init() {}
    
    public init(from dataStream: DataStream) {
        self.init()
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
    }
}

// Empty definition in PDB
public struct WaterDesc : Packable {
    public init() {}
    
    public init(from dataStream: DataStream) {
        self.init()
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
    }
}

// 0x00012507
public struct TerrainDesc : Packable {
    public var terrainTypes: [TerrainType]
    public var landSurfaces: LandSurf
    
    public init(from dataStream: DataStream) {
        self.terrainTypes = [TerrainType](from: dataStream)
        self.landSurfaces = LandSurf(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public enum LandSurf : Packable {
    case palShift(PalShift)
    case texMerge(TexMerge)
    
    public init(from dataStream: DataStream) {
        let isPalShift = Bool(from: dataStream)
        
        if isPalShift {
            let palShift = PalShift(from: dataStream)
            self = .palShift(palShift)
        }
        else {
            let texMerge = TexMerge(from: dataStream)
            self = .texMerge(texMerge)
        }
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

// Not defining as it is not in the files I have
public struct PalShift : Packable {
    public init() {}
    
    public init(from dataStream: DataStream) {
        self.init()
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
    }
}

public struct TerrainType : Packable {
    public var terrainName: String
    public var terrainColor: ARGB8888
    public var sceneTypeIndex: [Int32]
    
    public init(from dataStream: DataStream) {
        self.terrainName = String(from: dataStream)
        self.terrainColor = ARGB8888(from: dataStream)
        self.sceneTypeIndex = [Int32](from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct GameTime : Packable {
    public var zeroTimeOfYear: Float64
    public var zeroYear: UInt32
    public var dayLength: Float32
    public var daysPerYear: UInt32
    public var yearSpec: String // ?? PString
    public var timesOfDay: [TimeOfDay] // ??
    public var daysOfTheWeek: [WeekDay] // ??
    public var seasons: [Season] // ??
    //    public var yearLength: Float64 = day_length * days_per_year
    //    public var presentTimeOfDay: Float32
    //    public var timeOfDayBegin: Float64
    //    public var timeOfNextEvent: Float64
    // more
    
    public init(from dataStream: DataStream) {
        self.zeroTimeOfYear = Float64(from: dataStream)
        self.zeroYear = UInt32(from: dataStream)
        self.dayLength = Float32(from: dataStream)
        self.daysPerYear = UInt32(from: dataStream)
        self.yearSpec = String(from: dataStream)
        self.timesOfDay = [TimeOfDay](from: dataStream)
        self.daysOfTheWeek = [WeekDay](from: dataStream)
        self.seasons = [Season](from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct TimeOfDay : Packable {
    public var begin: Float32
    public var isNight: Bool
    public var timeOfDayName: String
    
    public init(from dataStream: DataStream) {
        self.begin = Float32(from: dataStream)
        self.isNight = Bool(from: dataStream)
        self.timeOfDayName = String(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct WeekDay : Packable {
    public let weekDayName: String
    
    public init(from dataStream: DataStream) {
        self.weekDayName = String(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct Season : Packable {
    public let begin: UInt32
    public let seasonName: String
    
    public init(from dataStream: DataStream) {
        self.begin = UInt32(from: dataStream)
        self.seasonName = String(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

// Empty definition in PDB
public struct FogDesc : Packable {
    public init() {}
    
    public init(from dataStream: DataStream) {
        self.init()
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
    }
}

public struct FileNameDesc : Packable { // 0x00015f96
    public init() {}
    
    public init(from dataStream: DataStream) {
        self.init()
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
    }
}

public struct LandDefs : Packable {
    public enum Direction : UInt32, Packable {
        case inViewerBlock = 0
        case northOfViewer = 1
        case southOfViewer = 2
        case eastOfViewer = 3
        case westOfViewer = 4
        case northWestOfViewer = 5
        case southWestOfViewer = 6
        case northEastOfViewer = 7
        case southEastOfViewer = 8
        case unknown = 9
    }
    
    public enum Rotation : UInt32, Packable {
        case rot0 = 0
        case rot90 = 1
        case rot180 = 2
        case rot270 = 3
    }
    
    public enum PalType : UInt32, Packable {
        case swTerrain = 0
        case seTerrain = 1
        case neTerrain = 2
        case nwTerrain = 3
        case road = 4
    }
    
    public enum WaterType : UInt32, Packable {
        case notWater = 0
        case partiallyWater = 1
        case entirelyWater = 2
    }
    
    public enum TerrainType : UInt32, Packable {
        case barrenRock = 0
        case grassland = 1
        case ice = 2
        case lushGrass = 3
        case marshSparseSwamp = 4
        case mudRichDirt = 5
        case obsidianPlain = 6
        case packedDirt = 7
        case patchyDirt = 8
        case patchyGrassland = 9
        case sandYellow = 10
        case sandGrey = 11
        case sandRockStrewn = 12
        case sedimentaryRock = 13
        case semiBarrenRock = 14
        case snow = 15
        case waterRunning = 16
        case waterStandingFresh = 17
        case waterShallowSea = 18
        case waterShallowStillSea = 19
        case waterDeepSea = 20
        case reserved21 = 21
        case reserved22 = 22
        case reserved23 = 23
        case reserved24 = 24
        case reserved25 = 25
        case reserved26 = 26
        case reserved27 = 27
        case reserved28 = 28
        case reserved29 = 29
        case reserved30 = 30
        case reserved31 = 31
        case roadType = 32
    }
    
    public let numBlockLength: UInt32 // 255 (0-254)
    public let numBlockWidth: UInt32  // 255 (0-254)
    public let squareLength: Float32  // 24.0
    public let lblockSide: UInt32     // 8 (8 * 24.0 = 192.0)
    public let vertexPerCell: UInt32  // 1 (overlap??)
    public let maxObjHeight: Float32  // 200.0
    public let skyHeight: Float32     // 1000.0
    public let roadWidth: Float32     // 5.0
    public let landHeightTable: [Float32] // 256 values
    
    public init(from dataStream: DataStream) {
        self.numBlockLength = UInt32(from: dataStream)
        self.numBlockWidth = UInt32(from: dataStream)
        self.squareLength = Float32(from: dataStream)
        self.lblockSide = UInt32(from: dataStream)
        self.vertexPerCell = UInt32(from: dataStream)
        self.maxObjHeight = Float32(from: dataStream)
        self.skyHeight = Float32(from: dataStream)
        self.roadWidth = Float32(from: dataStream)
        self.landHeightTable = [Float32](from: dataStream, count: 256)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct EncounterDesc : Packable { // 0x00015fa7
    public init() {}
    
    public init(from dataStream: DataStream) {
        self.init()
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
    }
}

public struct DayGroup : Packable {
    public var chanceOfOccur: Float
    public var dayName: String
    public var skyObjects: [SkyObject]
    public var skyTime: [SkyTimeOfDay]
    
    public init(from dataStream: DataStream) {
        self.chanceOfOccur = Float32(from: dataStream)
        self.dayName = String(from: dataStream)
        self.skyObjects = [SkyObject](from: dataStream)
        self.skyTime = [SkyTimeOfDay](from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

// Empty definition in PDB
public struct DistanceFogDesc : Packable {
    public init() {}
    
    public init(from dataStream: DataStream) {
        self.init()
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
    }
}

public struct SceneDesc : Packable {
    public var sceneTypes: [SceneType]
    
    public init(from dataStream: DataStream) {
        self.sceneTypes = [SceneType](from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct SceneType : Packable {
//    public var sceneName: String
    public var stbIndex: UInt32
    public var scenes: [Identifier]
//    public var soundTableDesc: AmbientSTBDesc?
    
    public init(from dataStream: DataStream) {
        self.stbIndex = UInt32(from: dataStream)
        self.scenes = [Identifier](from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct SoundDesc : Packable {
    public var stbDesc: [AmbientSTBDesc]

    public init(from dataStream: DataStream) {
        self.stbDesc = [AmbientSTBDesc](from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct AmbientSoundDesc : Packable {
    public var stype: SoundType
    public var volume: Float32
    public var baseChance: Float32
    public var isContinuous: Bool {
        return baseChance == 0.0
    }
    public var minRate: Float32
    public var maxRate: Float32
    
    public init(from dataStream: DataStream) {
        self.stype = SoundType(from: dataStream)
        self.volume = Float32(from: dataStream)
        self.baseChance = Float32(from: dataStream)
        self.minRate = Float32(from: dataStream)
        self.maxRate = Float32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

public struct AmbientSTBDesc : Packable {
    public var stbId: Identifier
    public var ambientSounds: [AmbientSoundDesc]
    
    public init(from dataStream: DataStream) {
        self.stbId = Identifier(from: dataStream)
        self.ambientSounds = [AmbientSoundDesc](from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}
