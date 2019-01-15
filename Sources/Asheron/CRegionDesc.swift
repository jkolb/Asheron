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

public final class CRegionDesc : PortalObject {
    /*
     list[1] = LF_MEMBER, protected, type = T_ULONG(0022), offset = 56 member name = 'region_number'
     list[2] = LF_MEMBER, protected, type = 0x35F3, offset = 60 member name = 'region_name'
     list[3] = LF_MEMBER, protected, type = T_ULONG(0022), offset = 64 member name = 'version'
     list[4] = LF_MEMBER, protected, type = T_INT4(0074), offset = 68 member name = 'minimize_pal'
     list[5] = LF_MEMBER, protected, type = T_ULONG(0022), offset = 72 member name = 'parts_mask'
     list[6] = LF_MEMBER, protected, type = 0x00012618, offset = 76 member name = 'file_info'
     list[7] = LF_MEMBER, protected, type = 0x0001261A, offset = 80 member name = 'sky_info'
     list[8] = LF_MEMBER, protected, type = 0x0001261C, offset = 84 member name = 'sound_info'
     list[9] = LF_MEMBER, protected, type = 0x0001261E, offset = 88 member name = 'scene_info'
     list[10] = LF_MEMBER, protected, type = 0x0001261F, offset = 92 member name = 'terrain_info'
     list[11] = LF_MEMBER, protected, type = 0x00012621, offset = 96 member name = 'encounter_info'
     list[12] = LF_MEMBER, protected, type = 0x00012623, offset = 100 member name = 'water_info'
     list[13] = LF_MEMBER, protected, type = 0x00012625, offset = 104 member name = 'fog_info'
     list[14] = LF_MEMBER, protected, type = 0x00012627, offset = 108 member name = 'dist_fog_info'
     list[15] = LF_MEMBER, protected, type = 0x00012629, offset = 112 member name = 'region_map_info'
     list[16] = LF_MEMBER, protected, type = 0x0001262B, offset = 116 member name = 'region_misc'
     */
    public static let kind = PortalKind.regionDesc
    public var portalId: PortalId<CRegionDesc>
    public var regionNumber: UInt32
    public var version: UInt32
    public var regionName: String  // ReadPString "Dereth" align if needed afterwards
    public var landDefs: LandDefs
    public var gameTime: GameTime
    public var partsMask: PartsMask // 0x21F = 10 0001 1111
//    public var minimizePal: UInt32
    public var fileInfo: FileNameDesc = FileNameDesc()
    public var skyInfo: SkyDesc?
    public var soundInfo: CSoundDesc?
    public var sceneInfo: CSceneDesc?
    public var terrainInfo: CTerrainDesc?
    public var encounterInfo: CEncounterDesc?
    public var waterInfo: WaterDesc?
    public var fogInfo: FogDesc?
    public var distFogInfo: DistanceFogDesc?
    public var regionMapInfo: RegionMapDesc?
    public var regionMisc: RegionMisc?
    
    public struct PartsMask : OptionSet {
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

    public init(
        portalId: PortalId<CRegionDesc>,
        regionNumber: UInt32,
        version: UInt32,
        regionName: String,
        landDefs: LandDefs,
        gameTime: GameTime,
        partsMask: PartsMask,
        skyInfo: SkyDesc?,
        soundInfo: CSoundDesc?,
        sceneInfo: CSceneDesc?,
        terrainInfo: CTerrainDesc?,
        encounterInfo: CEncounterDesc?,
        waterInfo: WaterDesc?,
        fogInfo: FogDesc?,
        distFogInfo: DistanceFogDesc?,
        regionMapInfo: RegionMapDesc?,
        regionMisc: RegionMisc?
        )
    {
        self.portalId = portalId
        self.regionNumber = regionNumber
        self.version = version
        self.regionName = regionName
        self.landDefs = landDefs
        self.gameTime = gameTime
        self.partsMask = partsMask
        self.skyInfo = skyInfo
        self.soundInfo = soundInfo
        self.sceneInfo = sceneInfo
        self.terrainInfo = terrainInfo
        self.encounterInfo = encounterInfo
        self.waterInfo = waterInfo
        self.fogInfo = fogInfo
        self.distFogInfo = distFogInfo
        self.regionMapInfo = regionMapInfo
        self.regionMisc = regionMisc
    }
}
