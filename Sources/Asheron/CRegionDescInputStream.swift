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

public final class CRegionDescInputStream : DatInputStream {
    public func readCRegionDesc(portalId: PortalId<CRegionDesc>) throws -> CRegionDesc {
        let streamID = try readPortalId(type: CRegionDesc.self)
        precondition(streamID == portalId)
        let regionNumber = try readUInt32()
        let version = try readUInt32()
        let regionName = try readPString()
        let landDefs = try readLandDefs()
        let gameTime = try readGameTime()
        let partsMask = try readPartsMask()
        let skyInfo = partsMask.contains(.hasSky) ? try readSkyDesc() : nil
        let soundInfo = partsMask.contains(.hasSound) ? try readCSoundDesc() : nil
        let sceneInfo = partsMask.contains(.hasScene) ? try readCSceneDesc() : nil
        let terrainInfo = partsMask.contains(.hasTerrain) ? try readCTerrainDesc() : nil
        // Has flag, but doesn't exist (maybe only in older files?)
        let encounterInfo: CEncounterDesc? = nil // partsMask.contains(.hasEncounter) ? try readCEncounterDesc() : nil
        let waterInfo = partsMask.contains(.hasWater) ? try readWaterDesc() : nil
        let fogInfo = partsMask.contains(.hasFog) ? try readFogDesc() : nil
        let distFogInfo = partsMask.contains(.hasDistFog) ? try readDistanceFogDesc() : nil
        let regionMapInfo = partsMask.contains(.hasRegionMap) ? try readRegionMapDesc() : nil
        let regionMisc = partsMask.contains(.hasMisc) ? try readRegionMisc() : nil
        
        return CRegionDesc(
            portalId: portalId,
            regionNumber: regionNumber,
            version: version,
            regionName: regionName,
            landDefs: landDefs,
            gameTime: gameTime,
            partsMask: partsMask,
            skyInfo: skyInfo,
            soundInfo: soundInfo,
            sceneInfo: sceneInfo,
            terrainInfo: terrainInfo,
            encounterInfo: encounterInfo,
            waterInfo: waterInfo,
            fogInfo: fogInfo,
            distFogInfo: distFogInfo,
            regionMapInfo: regionMapInfo,
            regionMisc: regionMisc
        )
    }
    
    private func readLandDefs() throws -> LandDefs {
        let numBlockLength = try readUInt32()
        let numBlockWidth = try readUInt32()
        let squareLength = try readFloat32()
        let lblockSide = try readUInt32()
        let vertexPerCell = try readUInt32()
        let maxObjHeight = try readFloat32()
        let skyHeight = try readFloat32()
        let roadWidth = try readFloat32()
        let landHeightTable = try readArray(count: 256, readElement: readFloat32)
        
        return LandDefs(
            numBlockLength: numBlockLength,
            numBlockWidth: numBlockWidth,
            squareLength: squareLength,
            lblockSide: lblockSide,
            vertexPerCell: vertexPerCell,
            maxObjHeight: maxObjHeight,
            skyHeight: skyHeight,
            roadWidth: roadWidth,
            landHeightTable: landHeightTable
        )
    }
    
    private func readGameTime() throws -> GameTime {
        let zeroTimeOfYear = try readFloat64()
        let zeroYear = try readUInt32()
        let dayLength = try readFloat32()
        let daysPerYear = try readUInt32()
        let yearSpec = try readPString()
        let timesOfDay = try readArray(readElement: readTimeOfDay)
        let daysOfTheWeek = try readArray(readElement: readWeekDay)
        let seasons = try readArray(readElement: readSeason)
        
        return GameTime(
            zeroTimeOfYear: zeroTimeOfYear,
            zeroYear: zeroYear,
            dayLength: dayLength,
            daysPerYear: daysPerYear,
            yearSpec: yearSpec,
            timesOfDay: timesOfDay,
            daysOfTheWeek: daysOfTheWeek,
            seasons: seasons
        )
    }
    
    private func readTimeOfDay() throws -> TimeOfDay {
        let begin = try readFloat32()
        let isNight = try readBool32()
        let timeOfDayName = try readPString()
        
        return TimeOfDay(
            begin: begin,
            isNight: isNight,
            timeOfDayName: timeOfDayName
        )
    }
    
    private func readWeekDay() throws -> WeekDay {
        let weekDayName = try readPString()
        
        return WeekDay(weekDayName: weekDayName)
    }
    
    private func readSeason() throws -> Season {
        let begin = try readUInt32()
        let seasonName = try readPString()
        
        return Season(begin: begin, seasonName: seasonName)
    }
    
    private func readPartsMask() throws -> CRegionDesc.PartsMask {
        let rawValue = try readUInt32()
        return CRegionDesc.PartsMask(rawValue: rawValue)
    }
    
    private func readSkyDesc() throws -> SkyDesc {
        let tickSize = try readFloat64()
        let lightTickSize = try readFloat64()
        let dayGroups = try readArray(readElement: readDayGroup)
        
        return SkyDesc(
            tickSize: tickSize,
            lightTickSize: lightTickSize,
            dayGroups: dayGroups
        )
    }
    
    private func readDayGroup() throws -> DayGroup {
        let chanceOfOccur = try readFloat32()
        let dayName = try readPString()
        let skyObjects = try readArray(readElement: readSkyObject)
        let skyTime = try readArray(readElement: readSkyTimeOfDay)
        
        return DayGroup(
            chanceOfOccur: chanceOfOccur,
            dayName: dayName,
            skyObjects: skyObjects,
            skyTime: skyTime
        )
    }
    
    private func readSkyObject() throws -> SkyObject {
        let beginTime = try readFloat32()
        let endTime = try readFloat32()
        let beginAngle = try readFloat32()
        let endAngle = try readFloat32()
        let texVelocityX = try readFloat32()
        let texVelocityY = try readFloat32()
        let texVelocity = CVector(texVelocityX, texVelocityY, 0.0)
        let defaultGFXObject = try readHandle()
        let defaultPesObject = try readHandle()
        let properties = try readUInt32()
        
        return SkyObject(
            beginTime: beginTime,
            endTime: endTime,
            beginAngle: beginAngle,
            endAngle: endAngle,
            texVelocity: texVelocity,
            defaultGFXObject: defaultGFXObject,
            defaultPesObject: defaultPesObject,
            properties: properties
        )
    }
    
    private func readSkyTimeOfDay() throws -> SkyTimeOfDay {
        let begin = try readFloat32()
        let dirBright = try readFloat32()
        let dirHeading = try readFloat32()
        let dirPitch = try readFloat32()
        let dirColor = try readColorARGB8888()
        let ambBright = try readFloat32()
        let ambColor = try readColorARGB8888()
        let minWorldFog = try readFloat32()
        let maxWorldFog = try readFloat32()
        let worldFogColor = try readColorARGB8888()
        let worldFog = try readUInt32()
        let skyObjReplace = try readArray(readElement: readSkyObjectReplace)
        
        return SkyTimeOfDay(
            begin: begin,
            dirBright: dirBright,
            dirHeading: dirHeading,
            dirPitch: dirPitch,
            dirColor: dirColor,
            ambBright: ambBright,
            ambColor: ambColor,
            minWorldFog: minWorldFog,
            maxWorldFog: maxWorldFog,
            worldFogColor: worldFogColor,
            worldFog: worldFog,
            skyObjReplace: skyObjReplace
        )
    }
    
    private func readSkyObjectReplace() throws -> SkyObjectReplace {
        let objectIndex = try readUInt32()
        let gfxObjID = try readHandle()
        let rotate = try readFloat32()
        let transparent = try readFloat32()
        let luminosity = try readFloat32()
        let maxBright = try readFloat32()
        
        return SkyObjectReplace(
            objectIndex: objectIndex,
            gfxObjID: gfxObjID,
            rotate: rotate,
            transparent: transparent,
            luminosity: luminosity,
            maxBright: maxBright
        )
    }
    
    private func readCSoundDesc() throws -> CSoundDesc {
        let stbDesc = try readArray(readElement: readAmbientSTBDesc)
        
        return CSoundDesc(stbDesc: stbDesc)
    }
    
    private func readAmbientSTBDesc() throws -> AmbientSTBDesc {
        let stbId = try readHandle()
        let ambientSounds = try readArray(readElement: readAmbientSoundDesc)
        
        return AmbientSTBDesc(
            stbId: stbId,
            ambientSounds: ambientSounds
        )
    }
    
    private func readAmbientSoundDesc() throws -> AmbientSoundDesc {
        let stype = try readSoundType()
        let volume = try readFloat32()
        let baseChance = try readFloat32()
        let minRate = try readFloat32()
        let maxRate = try readFloat32()
        
        return AmbientSoundDesc(
            stype: stype,
            volume: volume,
            baseChance: baseChance,
            minRate: minRate,
            maxRate: maxRate
        )
    }
    
    private func readSoundType() throws -> SoundType {
        let rawValue = try readInt32()
        
        return SoundType(rawValue: rawValue)!
    }
    
    private func readCSceneDesc() throws -> CSceneDesc {
        let sceneTypes = try readArray(readElement: readCSceneType)
        
        return CSceneDesc(sceneTypes: sceneTypes)
    }
    
    private func readCSceneType() throws -> CSceneType {
        let stbIndex = try readUInt32()
        let scenes = try readArray(readElement: readHandle)
        
        return CSceneType(
            stbIndex: stbIndex,
            scenes: scenes
        )
    }
    
    private func readCTerrainDesc() throws -> CTerrainDesc {
        let terrainTypes = try readArray(readElement: readCTerrainType)
        let landSurfaces = try readLandSurf()
        
        return CTerrainDesc(terrainTypes: terrainTypes, landSurfaces: landSurfaces)
    }
    
    private func readCTerrainType() throws -> CTerrainType {
        let terrainName = try readPString()
        let terrainColor = try readColorARGB8888()
        let sceneTypeIndex = try readArray(readElement: readCount)
        
        return CTerrainType(terrainName: terrainName, terrainColor: terrainColor, sceneTypeIndex: sceneTypeIndex)
    }
    
    private func readLandSurf() throws -> LandSurf {
        let isPalShift = try readBool32()
        
        if isPalShift {
            let palShift = try readPalShift()
            
            return .palShift(palShift)
        }
        else {
            let texMerge = try readTexMerge()
            
            return .texMerge(texMerge)
        }
    }
    
    private func readPalShift() throws -> PalShift {
        return PalShift()
    }
    
    private func readTexMerge() throws -> TexMerge {
        let baseTexSize = try readUInt32()
        let cornerTerrainMaps = try readArray(readElement: readTerrainAlphaMap)
        let sideTerrainMaps = try readArray(readElement: readTerrainAlphaMap)
        let roadMaps = try readArray(readElement: readRoadAlphaMap)
        let terrainDesc = try readArray(readElement: readTMTerrainDesc)
        
        return TexMerge(
            baseTexSize: baseTexSize,
            cornerTerrainMaps: cornerTerrainMaps,
            sideTerrainMaps: sideTerrainMaps,
            roadMaps: roadMaps,
            terrainDesc: terrainDesc
        )
    }
    
    private func readTerrainAlphaMap() throws -> TerrainAlphaMap {
        let tcode = try readTCode()
        let tex = try readImgTexRefId()
        
        return TerrainAlphaMap(tcode: tcode, tex: tex)
    }
    
    private func readTCode() throws -> TCode {
        let rawValue = try readUInt32()
        
        return TCode(rawValue: rawValue)!
    }
    
    private func readRoadAlphaMap() throws -> RoadAlphaMap {
        let rcode = try readRCode()
        let roadTex = try readImgTexRefId()
        
        return RoadAlphaMap(rcode: rcode, roadTex: roadTex)
    }
    
    private func readRCode() throws -> RCode {
        let rawValue = try readUInt32()
        
        return RCode(rawValue: rawValue)!
    }

    private func readImgTexRefId() throws -> PortalId<ImgTexRef> {
        let handle = try readHandle()
        
        return PortalId<ImgTexRef>(handle: handle)!
    }

    private func readImgTexId() throws -> PortalId<ImgTex> {
        let handle = try readHandle()
        
        return PortalId<ImgTex>(handle: handle)!
    }

    private func readTMTerrainDesc() throws -> TMTerrainDesc {
        let terrainType = try readTerrainType()
        let terrainTex = try readTerrainTex()
        
        return TMTerrainDesc(terrainType: terrainType, terrainTex: terrainTex)
    }
    
    private func readTerrainType() throws -> LandDefs.TerrainType {
        let rawValue = try readUInt32()
        
        return LandDefs.TerrainType(rawValue: rawValue)!
    }
    
    private func readTerrainTex() throws -> TerrainTex {
        let tex = try readImgTexRefId()
        let texTiling = try readUInt32()
        let maxVertBright = try readUInt32()
        let minVertBright = try readUInt32()
        let maxVertSaturate = try readUInt32()
        let minVertSaturate = try readUInt32()
        let maxVertHue = try readUInt32()
        let minVertHue = try readUInt32()
        let detailTexTiling = try readUInt32()
        let detailTex = try readImgTexRefId()
        
        return TerrainTex(
            tex: tex,
            texTiling: texTiling,
            maxVertBright: maxVertBright,
            minVertBright: minVertBright,
            maxVertSaturate: maxVertSaturate,
            minVertSaturate: minVertSaturate,
            maxVertHue: maxVertHue,
            minVertHue: minVertHue,
            detailTexTiling: detailTexTiling,
            detailTex: detailTex
        )
    }
    
    private func readCEncounterDesc() throws -> CEncounterDesc {
        return CEncounterDesc()
    }
    
    private func readWaterDesc() throws -> WaterDesc {
        return WaterDesc()
    }
    
    private func readFogDesc() throws -> FogDesc {
        return FogDesc()
    }
    
    private func readDistanceFogDesc() throws -> DistanceFogDesc {
        return DistanceFogDesc()
    }
    
    private func readRegionMapDesc() throws -> RegionMapDesc {
        return RegionMapDesc()
    }
    
    private func readRegionMisc() throws -> RegionMisc {
        let version = try readUInt32()
        let gameMap = try readImgTexId()
        let autotestMap = try readImgTexId()
        let autotestMapSize = try readUInt32()
        let clearCell = try readUInt32()
        let clearMonster = try readUInt32()
        
        return RegionMisc(
            version: version,
            gameMap: gameMap,
            autotestMap: autotestMap,
            autotestMapSize: autotestMapSize,
            clearCell: clearCell,
            clearMonster: clearMonster
        )
    }
}
