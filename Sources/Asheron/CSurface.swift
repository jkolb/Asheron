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

public struct SurfaceType : OptionSet, CustomStringConvertible {
    public static let BASE1_SOLID   = SurfaceType(rawValue: 1 << 0)
    public static let BASE1_IMAGE   = SurfaceType(rawValue: 1 << 1)
    public static let BASE1_CLIPMAP = SurfaceType(rawValue: 1 << 2)

    public static let TRANSLUCENT   = SurfaceType(rawValue: 1 << 4)
    public static let DIFFUSE       = SurfaceType(rawValue: 1 << 5)
    public static let LUMINOUS      = SurfaceType(rawValue: 1 << 6)

    public static let ALPHA         = SurfaceType(rawValue: 1 << 8)
    public static let INVALPHA      = SurfaceType(rawValue: 1 << 9)

    public static let ADDITIVE      = SurfaceType(rawValue: 1 << 16)
    public static let DETAIL        = SurfaceType(rawValue: 1 << 17)

    public static let GOURAUD       = SurfaceType(rawValue: 1 << 28)
    
    public static let STIPPLED      = SurfaceType(rawValue: 1 << 30)
    public static let PERSPECTIVE   = SurfaceType(rawValue: 1 << 31)

    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public var description: String {
        var values = self
        var strings = [String]()
        
        while !values.isEmpty {
            if values.contains(.BASE1_SOLID) {
                strings.append("BASE1_SOLID")
                values.subtract(.BASE1_SOLID)
            }
            if values.contains(.BASE1_IMAGE) {
                strings.append("BASE1_IMAGE")
                values.subtract(.BASE1_IMAGE)
            }
            if values.contains(.BASE1_CLIPMAP) {
                strings.append("BASE1_CLIPMAP")
                values.subtract(.BASE1_CLIPMAP)
            }
            if values.contains(.TRANSLUCENT) {
                strings.append("TRANSLUCENT")
                values.subtract(.TRANSLUCENT)
            }
            if values.contains(.DIFFUSE) {
                strings.append("DIFFUSE")
                values.subtract(.DIFFUSE)
            }
            if values.contains(.LUMINOUS) {
                strings.append("LUMINOUS")
                values.subtract(.LUMINOUS)
            }
            if values.contains(.ALPHA) {
                strings.append("ALPHA")
                values.subtract(.ALPHA)
            }
            if values.contains(.INVALPHA) {
                strings.append("INVALPHA")
                values.subtract(.INVALPHA)
            }
            if values.contains(.ADDITIVE) {
                strings.append("ADDITIVE")
                values.subtract(.ADDITIVE)
            }
            if values.contains(.DETAIL) {
                strings.append("DETAIL")
                values.subtract(.DETAIL)
            }
            if values.contains(.GOURAUD) {
                strings.append("GOURAUD")
                values.subtract(.GOURAUD)
            }
            if values.contains(.STIPPLED) {
                strings.append("STIPPLED")
                values.subtract(.STIPPLED)
            }
            if values.contains(.PERSPECTIVE) {
                strings.append("PERSPECTIVE")
                values.subtract(.PERSPECTIVE)
            }
        }
        
        return "[\(strings.joined(separator: ", "))]"
    }
}
/*
 0x00010f0f : Length = 174, Leaf = 0x1203 LF_FIELDLIST
 list[0] = LF_ENUMERATE, public, value = 0, name = 'SH_UNKNOWN'
 list[1] = LF_ENUMERATE, public, value = 1, name = 'SH_DATABASE'
 list[2] = LF_ENUMERATE, public, value = 2, name = 'SH_PALSHIFT'
 list[3] = LF_ENUMERATE, public, value = 3, name = 'SH_TEXMERGE'
 list[4] = LF_ENUMERATE, public, value = 4, name = 'SH_CUSTOMDB'
 list[5] = LF_ENUMERATE, public, value = 5, name = 'NUM_SURFACE_HANDLER'
 list[6] = LF_ENUMERATE, public, value = (LF_ULONG) 2147483647, name = 'FORCE_SurfaceHandlerEnum_32_BIT'
 
 0x00010f10 : Length = 34, Leaf = 0x1507 LF_ENUM
 # members = 7,  type = T_INT4(0074) field list type 0x10f0f
 enum name = SurfaceHandlerEnum, UDT(0x00010f10)
 
 0x00010f11 : Length = 158, Leaf = 0x1203 LF_FIELDLIST
 list[0] = LF_ENUMERATE, public, value = 0, name = 'SurfaceInitObjDescChange'
 list[1] = LF_ENUMERATE, public, value = 1, name = 'SurfaceInitLoading'
 list[2] = LF_ENUMERATE, public, value = 2, name = 'SurfaceInitCadding'
 list[3] = LF_ENUMERATE, public, value = 4, name = 'SurfaceInitRestoring'
 list[4] = LF_ENUMERATE, public, value = (LF_ULONG) 2147483647, name = 'FORCE_SurfaceInitType_32_BIT'
 
 0x00010f12 : Length = 30, Leaf = 0x1507 LF_ENUM
 # members = 5,  type = T_INT4(0074) field list type 0x10f11
 enum name = SurfaceInitType, UDT(0x00010f12)
 */

public final class CSurface : PortalObject, CustomStringConvertible {
    public enum Value {
        case color(ColorARGB8888)
        case texture(PortalId<ImgTexRef>)
        case indexedTexture(PortalId<ImgTexRef>, PortalId<Palette>)
    }
    
    /*
     list[45] = LF_MEMBER, public, type = T_ULONG(0022), offset = 88 member name = 'type'
     list[46] = LF_MEMBER, public, type = 0x00010FC7, offset = 92 member name = 'handler'
     list[47] = LF_MEMBER, public, type = T_ULONG(0022), offset = 96 member name = 'color_value'
     list[48] = LF_MEMBER, public, type = T_INT4(0074), offset = 100 member name = 'solid_index'
     list[49] = LF_MEMBER, public, type = 0x124C, offset = 104 member name = 'indexed_texture_id'
     list[50] = LF_MEMBER, protected, type = 0x7920, offset = 108 member name = 'base1map'
     list[51] = LF_MEMBER, public, type = 0x796C, offset = 112 member name = 'base1pal'
     list[52] = LF_MEMBER, public, type = T_REAL32(0040), offset = 116 member name = 'translucency'
     list[53] = LF_MEMBER, public, type = T_REAL32(0040), offset = 120 member name = 'luminosity'
     list[54] = LF_MEMBER, public, type = T_REAL32(0040), offset = 124 member name = 'diffuse'
     list[55] = LF_MEMBER, public, type = 0x124C, offset = 128 member name = 'orig_texture_id'
     list[56] = LF_MEMBER, public, type = 0x124C, offset = 132 member name = 'orig_palette_id'
     list[57] = LF_MEMBER, public, type = T_REAL32(0040), offset = 136 member name = 'orig_luminosity'
     list[58] = LF_MEMBER, public, type = T_REAL32(0040), offset = 140 member name = 'orig_diffuse'
     */
    public static let kind = PortalKind.cSurface
    public var portalId: PortalId<CSurface>
    public var type: SurfaceType
    public var value: Value
    public var translucency: Float
    public var luminosity: Float
    public var diffuse: Float
    
    public init(portalId: PortalId<CSurface>, type: SurfaceType, value: Value, translucency: Float, luminosity: Float, diffuse: Float) {
        self.portalId = portalId
        self.type = type
        self.value = value
        self.translucency = translucency
        self.luminosity = luminosity
        self.diffuse = diffuse
    }
    
    public var description: String {
        switch value {
            
        case .color(let argb):
            return "\(portalId): \(type) - \(argb)"
            
        case .texture(let texture):
            return "\(portalId): \(type) - \(texture)"
            
        case .indexedTexture(let texture, let colorMap):
            return "\(portalId): \(type) - \(texture) : \(colorMap)"
        }
    }
}
