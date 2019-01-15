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

public struct LandDefs {
    public enum Direction : UInt32 {
        case IN_VIEWER_BLOCK = 0
        case NORTH_OF_VIEWER = 1
        case SOUTH_OF_VIEWER = 2
        case EAST_OF_VIEWER = 3
        case WEST_OF_VIEWER = 4
        case NORTHWEST_OF_VIEWER = 5
        case SOUTHWEST_OF_VIEWER = 6
        case NORTHEAST_OF_VIEWER = 7
        case SOUTHEAST_OF_VIEWER = 8
        case UNKNOWN = 9
    }
    
    public enum Rotation : UInt32 {
        case ROT_0 = 0
        case ROT_90 = 1
        case ROT_180 = 2
        case ROT_270 = 3
    }
    
    public enum PalType : UInt32 {
        case SWTerrain = 0
        case SETerrain = 1
        case NETerrain = 2
        case NWTerrain = 3
        case Road = 4
    }
    
    public enum WaterType : UInt32 {
        case NOT_WATER = 0
        case PARTIALLY_WATER = 1
        case ENTIRELY_WATER = 2
    }

    public enum TerrainType : UInt32 {
        case BarrenRock = 0
        case Grassland = 1
        case Ice = 2
        case LushGrass = 3
        case MarshSparseSwamp = 4
        case MudRichDirt = 5
        case ObsidianPlain = 6
        case PackedDirt = 7
        case PatchyDirt = 8
        case PatchyGrassland = 9
        case SandYellow = 10
        case SandGrey = 11
        case SandRockStrewn = 12
        case SedimentaryRock = 13
        case SemiBarrenRock = 14
        case Snow = 15
        case WaterRunning = 16
        case WaterStandingFresh = 17
        case WaterShallowSea = 18
        case WaterShallowStillSea = 19
        case WaterDeepSea = 20
        case Reserved21 = 21
        case Reserved22 = 22
        case Reserved23 = 23
        case Reserved24 = 24
        case Reserved25 = 25
        case Reserved26 = 26
        case Reserved27 = 27
        case Reserved28 = 28
        case Reserved29 = 29
        case Reserved30 = 30
        case Reserved31 = 31
        case RoadType = 32
    }
    
    public let numBlockLength: UInt32 // 255 (0-254)
    public let numBlockWidth: UInt32  // 255 (0-254)
    public let squareLength: Float    // 24.0
    public let lblockSide: UInt32     // 8 (8 * 24.0 = 192.0)
    public let vertexPerCell: UInt32  // 1 (overlap??)
    public let maxObjHeight: Float    // 200.0
    public let skyHeight: Float       // 1000.0
    public let roadWidth: Float       // 5.0
    public let landHeightTable: [Float] // 256 values
    
    public init() {
        self.init(numBlockLength: 0, numBlockWidth: 0, squareLength: 0.0, lblockSide: 0, vertexPerCell: 0, maxObjHeight: 0.0, skyHeight: 0.0, roadWidth: 0.0, landHeightTable: [])
    }
    
    public init(
        numBlockLength: UInt32,
        numBlockWidth: UInt32,
        squareLength: Float,
        lblockSide: UInt32,
        vertexPerCell: UInt32,
        maxObjHeight: Float,
        skyHeight: Float,
        roadWidth: Float,
        landHeightTable: [Float]
        )
    {
        self.numBlockLength = numBlockLength
        self.numBlockWidth = numBlockWidth
        self.squareLength = squareLength
        self.lblockSide = lblockSide
        self.vertexPerCell = vertexPerCell
        self.maxObjHeight = maxObjHeight
        self.skyHeight = skyHeight
        self.roadWidth = roadWidth
        self.landHeightTable = landHeightTable
    }
    /*
     list[5] = LF_ONEMETHOD, public, STATIC, index = 0x6188, name = 'get_vars'
     list[6] = LF_ONEMETHOD, public, STATIC, index = 0x618A, name = 'set_height_table'
     list[7] = LF_METHOD, count = 2, list = 0x618D, name = 'get_block_part'
     list[8] = LF_METHOD, count = 2, list = 0x618D, name = 'get_cell_part'
     list[9] = LF_ONEMETHOD, public, STATIC, index = 0x618E, name = 'get_blockx'
     list[10] = LF_ONEMETHOD, public, STATIC, index = 0x618E, name = 'get_blocky'
     list[11] = LF_ONEMETHOD, public, STATIC, index = 0x618E, name = 'get_cellx'
     list[12] = LF_ONEMETHOD, public, STATIC, index = 0x618E, name = 'get_celly'
     list[13] = LF_ONEMETHOD, public, STATIC, index = 0x618F, name = 'form_cellid'
     list[14] = LF_ONEMETHOD, public, STATIC, index = 0x6191, name = 'get_outside_lcoord'
     list[15] = LF_ONEMETHOD, public, STATIC, index = 0x6193, name = 'get_outside_cell_id'
     list[16] = LF_ONEMETHOD, public, STATIC, index = 0x6195, name = 'adjust_to_outside'
     list[17] = LF_ONEMETHOD, public, STATIC, index = 0x6196, name = 'in_bounds'
     list[18] = LF_ONEMETHOD, public, STATIC, index = 0x6196, name = 'IsValidLBIPosition'
     list[19] = LF_ONEMETHOD, public, STATIC, index = 0x6197, name = 'valid_cellid'
     list[20] = LF_ONEMETHOD, public, STATIC, index = 0x6197, name = 'inbound_valid_cellid'
     list[21] = LF_ONEMETHOD, public, STATIC, index = 0x6197, name = 'valid_outside_cellid'
     list[22] = LF_ONEMETHOD, public, STATIC, index = 0x6197, name = 'outside'
     list[23] = LF_ONEMETHOD, public, STATIC, index = 0x618B, name = 'get_block_gid'
     list[24] = LF_ONEMETHOD, public, STATIC, index = 0x6198, name = 'get_block_did'
     list[25] = LF_ONEMETHOD, public, STATIC, index = 0x618B, name = 'lcoord_to_gid'
     list[26] = LF_ONEMETHOD, public, STATIC, index = 0x6197, name = 'is_landblock_gid'
     list[27] = LF_ONEMETHOD, public, STATIC, index = 0x618C, name = 'get_landblock_gid'
     list[28] = LF_ONEMETHOD, public, STATIC, index = 0x6199, name = 'get_landblock_did'
     list[29] = LF_ONEMETHOD, public, STATIC, index = 0x6199, name = 'get_first_envcell_did'
     list[30] = LF_ONEMETHOD, public, STATIC, index = 0x619A, name = 'get_nth_envcell_gid'
     list[31] = LF_ONEMETHOD, public, STATIC, index = 0x618C, name = 'get_lbi_id'
     list[32] = LF_ONEMETHOD, public, STATIC, index = 0x6199, name = 'get_lbi_did'
     list[33] = LF_ONEMETHOD, public, STATIC, index = 0x619C, name = 'blockid_to_lcoord'
     list[34] = LF_ONEMETHOD, public, STATIC, index = 0x619C, name = 'gid_to_lcoord'
     list[35] = LF_ONEMETHOD, public, STATIC, index = 0x619C, name = 'find_xy_offset_in_block'
     list[36] = LF_ONEMETHOD, public, STATIC, index = 0x619D, name = 'in_same_block'
     list[37] = LF_METHOD, count = 2, list = 0x61A2, name = 'GetBlockID'
     list[38] = LF_METHOD, count = 2, list = 0x61A7, name = 'GetBlockOffset'
     list[39] = LF_ONEMETHOD, public, STATIC, index = 0x61A8, name = 'get_block_offset'
     list[40] = LF_METHOD, count = 2, list = 0x61AD, name = 'get_block_diff'
     list[41] = LF_METHOD, count = 2, list = 0x61B1, name = 'within_block'
     list[42] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_lblock_side'
     list[43] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_lblock_shift'
     list[44] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_land_width'
     list[45] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_land_length'
     list[46] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_num_block_width'
     list[47] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_num_block_length'
     list[48] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_num_blocks'
     list[49] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_side_vertex_count'
     list[50] = LF_ONEMETHOD, public, STATIC, index = 0x61B3, name = 'get_block_length'
     list[51] = LF_ONEMETHOD, public, STATIC, index = 0x61B3, name = 'get_square_length'
     list[52] = LF_ONEMETHOD, public, STATIC, index = 0x61B3, name = 'get_road_width'
     list[53] = LF_ONEMETHOD, public, STATIC, index = 0x61B3, name = 'get_half_square_length'
     list[54] = LF_ONEMETHOD, public, STATIC, index = 0x61B4, name = 'get_num_terrain'
     list[55] = LF_ONEMETHOD, public, STATIC, index = 0x61B4, name = 'get_num_road'
     list[56] = LF_ONEMETHOD, public, STATIC, index = 0x61B4, name = 'get_max_tex_size'
     list[57] = LF_ONEMETHOD, public, STATIC, index = 0x61B4, name = 'get_max_encounter_columns'
     list[58] = LF_ONEMETHOD, public, STATIC, index = 0x61B4, name = 'get_max_scene_types'
     list[59] = LF_ONEMETHOD, public, STATIC, index = 0x61B5, name = 'get_terrain_offset'
     list[60] = LF_ONEMETHOD, public, STATIC, index = 0x61B5, name = 'get_road_offset'
     list[61] = LF_ONEMETHOD, public, STATIC, index = 0x61B4, name = 'get_tex_size_offset'
     list[62] = LF_ONEMETHOD, public, STATIC, index = 0x61B4, name = 'get_terrain_byte_offset'
     list[63] = LF_ONEMETHOD, public, STATIC, index = 0x61B4, name = 'get_scene_byte_offset'
     list[64] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_scene_bit_mask'
     list[65] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_encounter_shift'
     list[66] = LF_ONEMETHOD, public, STATIC, index = 0x61B2, name = 'get_encounter_bit_mask'
     list[67] = LF_ONEMETHOD, public, STATIC, index = 0x61B4, name = 'get_last_envcell_id'
     list[68] = LF_ONEMETHOD, public, STATIC, index = 0x61B3, name = 'get_inside_val'
     list[69] = LF_ONEMETHOD, public, STATIC, index = 0x61B3, name = 'get_sky_height'
     list[70] = LF_ONEMETHOD, public, STATIC, index = 0x61B3, name = 'get_outside_val'
     list[71] = LF_ONEMETHOD, public, STATIC, index = 0x61B3, name = 'get_max_object_height'
     list[72] = LF_ONEMETHOD, public, STATIC, index = 0x61B6, name = 'get_height_mask'
     list[73] = LF_ONEMETHOD, public, STATIC, index = 0x618E, name = 'calc_vertex_count'
     list[74] = LF_ONEMETHOD, public, STATIC, index = 0x618E, name = 'calc_cell_count'
     list[75] = LF_ONEMETHOD, public, STATIC, index = 0x618E, name = 'calc_polygon_count'
     list[76] = LF_ONEMETHOD, public, STATIC, index = 0x61B7, name = 'get_vertex_per_cell'
     list[77] = LF_ONEMETHOD, public, STATIC, index = 0x61B7, name = 'get_polys_per_landcell'
     list[78] = LF_ONEMETHOD, public, STATIC, index = 0x61B9, name = 'cell_polygon_index'
     list[79] = LF_ONEMETHOD, public, STATIC, index = 0x61BA, name = 'pseudorand'
     list[80] = LF_ONEMETHOD, public, STATIC, index = 0x61BB, name = 'heading'
     list[81] = LF_ONEMETHOD, public, STATIC, index = 0x61BC, name = 'get_dir'
     list[82] = LF_ONEMETHOD, public, STATIC, index = 0x61BE, name = 'parse_lbi_name'
     list[83] = LF_ONEMETHOD, public, STATIC, index = 0x61C0, name = 'get_lbi_name'
     list[84] = LF_ONEMETHOD, public, STATIC, index = 0x61C2, name = 'determine_block_id'
     list[85] = LF_ONEMETHOD, public, STATIC, index = 0x61B7, name = 'get_max_region_num'
     list[86] = LF_ONEMETHOD, public, STATIC, index = 0x618F, name = 'get_cell_map_offset'
     list[87] = LF_ONEMETHOD, public, STATIC, index = 0x61C4, name = 'WithinBlocks'
     list[88] = LF_ONEMETHOD, public, STATIC, index = 0x61C5, name = 'CellidToCoordinateString'
     list[89] = LF_ONEMETHOD, public, STATIC, index = 0x61CA, name = 'BlockRayClip'
     list[90] = LF_ONEMETHOD, public, STATIC, index = 0x61CE, name = 'ClipRayToLandCell'
     list[91] = LF_ONEMETHOD, public, STATIC, index = 0x61CF, name = 'MoveVectorToBeInBlock'
     list[92] = LF_STATICMEMBER, protected, type = 0x61D0        member name = 'Land_Height_Table'
     */
}
