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

public struct SurfaceType : OptionSet, Hashable, CustomStringConvertible, Packable {
    public static let base1Solid    = SurfaceType(rawValue: 1 << 0)
    public static let base1Image    = SurfaceType(rawValue: 1 << 1)
    public static let base1ClipMap  = SurfaceType(rawValue: 1 << 2)

    public static let translucent   = SurfaceType(rawValue: 1 << 4)
    public static let diffuse       = SurfaceType(rawValue: 1 << 5)
    public static let luminous      = SurfaceType(rawValue: 1 << 6)

    public static let alpha         = SurfaceType(rawValue: 1 << 8)
    public static let invAlpha      = SurfaceType(rawValue: 1 << 9)

    public static let additive      = SurfaceType(rawValue: 1 << 16)
    public static let detail        = SurfaceType(rawValue: 1 << 17)

    public static let gouraud       = SurfaceType(rawValue: 1 << 28)
    
    public static let stippled      = SurfaceType(rawValue: 1 << 30)
    public static let perspective   = SurfaceType(rawValue: 1 << 31)

    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public var description: String {
        var values = self
        var strings = [String]()
        
        while !values.isEmpty {
            if values.contains(.base1Solid) {
                strings.append("base1Solid")
                values.subtract(.base1Solid)
            }
            if values.contains(.base1Image) {
                strings.append("base1Image")
                values.subtract(.base1Image)
            }
            if values.contains(.base1ClipMap) {
                strings.append("base1ClipMap")
                values.subtract(.base1ClipMap)
            }
            if values.contains(.translucent) {
                strings.append("translucent")
                values.subtract(.translucent)
            }
            if values.contains(.diffuse) {
                strings.append("diffuse")
                values.subtract(.diffuse)
            }
            if values.contains(.luminous) {
                strings.append("luminous")
                values.subtract(.luminous)
            }
            if values.contains(.alpha) {
                strings.append("alpha")
                values.subtract(.alpha)
            }
            if values.contains(.invAlpha) {
                strings.append("invAlpha")
                values.subtract(.invAlpha)
            }
            if values.contains(.additive) {
                strings.append("additive")
                values.subtract(.additive)
            }
            if values.contains(.detail) {
                strings.append("detail")
                values.subtract(.detail)
            }
            if values.contains(.gouraud) {
                strings.append("gouraud")
                values.subtract(.gouraud)
            }
            if values.contains(.stippled) {
                strings.append("stippled")
                values.subtract(.stippled)
            }
            if values.contains(.perspective) {
                strings.append("perspective")
                values.subtract(.perspective)
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
 list[6] = LF_ENUMERATE, public, value = (LF_ULONG) 2147483647, name = 'FORCE_SurfaceIdentifierrEnum_32_BIT'
 
 0x00010f10 : Length = 34, Leaf = 0x1507 LF_ENUM
 # members = 7,  type = T_INT4(0074) field list type 0x10f0f
 enum name = SurfaceIdentifierrEnum, UDT(0x00010f10)
 
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

public final class Surface : Identifiable, CustomStringConvertible {
    public enum Value {
        case color(ARGB8888)
        case texture(Identifier)
        case indexedTexture(Identifier, Identifier)
        
        public init(from dataStream: DataStream, type: SurfaceType) {
            if type.contains(.base1Solid) {
                let color = ARGB8888(from: dataStream)
                self = .color(color)
            }
            else if type.contains(.base1Image) || type.contains(.base1ClipMap) {
                let surfaceTextureId = Identifier(from: dataStream)
                let paletteIdentifier = Identifier(from: dataStream)
                
                if paletteIdentifier.bits == 0 {
                    self = .texture(surfaceTextureId)
                }
                else {
                    self = .indexedTexture(surfaceTextureId, paletteIdentifier)
                }
            }
            else {
                fatalError()
            }
        }
    }
    
    /*
     list[45] = LF_MEMBER, public, type = T_ULONG(0022), offset = 88 member name = 'type'
     list[46] = LF_MEMBER, public, type = 0x00010FC7, offset = 92 member name = 'identifierr'
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
    public var id: Identifier
    public var type: SurfaceType
    public var value: Value
    public var translucency: Float32
    public var luminosity: Float32
    public var diffuse: Float32
    
    public var description: String {
        switch value {
            
        case .color(let argb):
            return "\(id): \(type) - \(argb)"
            
        case .texture(let texture):
            return "\(id): \(type) - \(texture)"
            
        case .indexedTexture(let texture, let palette):
            return "\(id): \(type) - \(texture) : \(palette)"
        }
    }

    public init(from dataStream: DataStream, id: Identifier) {
        // Doesn't contain its own identifier unlike other objects
        self.id = id
        self.type = SurfaceType(from: dataStream)
        self.value = Value(from: dataStream, type: type)
        self.translucency = Float32(from: dataStream)
        self.luminosity = Float32(from: dataStream)
        self.diffuse = Float32(from: dataStream)
    }
}
