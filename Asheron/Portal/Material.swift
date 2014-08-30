//
//  Material.swift
//  AC
//
//  Created by Justin Kolb on 7/20/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getMaterial() -> Material {
        let identifier = getUInt32()
        let flags = getUInt32()
        var color: Color
        var textureId: UInt32
        var paletteId: UInt32
        var light1: Float
        var light2: Float
        var light3: Float
        
        if (flags & MaterialFlag.Color.toRaw()) == MaterialFlag.Color.toRaw() {
            color = getColor()
            textureId = 0
            paletteId = 0
            light1 = getFloat32()
            light2 = getFloat32()
            light3 = getFloat32()
        } else {
            color = Color()
            textureId = getUInt32()
            paletteId = getUInt32()
            light1 = getFloat32()
            light2 = getFloat32()
            light3 = getFloat32()
        }
        
        assert(remaining == 0, "Not fully parsed")

        return Material(
            identifier: identifier,
            flags: flags,
            color: color,
            textureId: textureId,
            paletteId: paletteId,
            light1: light1,
            light2: light2,
            light3: light3
        )
    }
}

public enum MaterialFlag: UInt32 {
    case Color = 1
    case Texture = 2
    case Transparent = 4 // ?? How is this different from Solid off, where did these come from?
    case Unknown1 = 16
    case Unknown2 = 256
    case Unknown3 = 65536
}

public struct Material {
    public let identifier: UInt32
    public let flags: UInt32
    public let color: Color
    public let textureId: UInt32
    public let paletteId: UInt32
    public let light1: Float
    public let light2: Float
    public let light3: Float
    
    public var isColor: Bool { return (flags & MaterialFlag.Color.toRaw()) == MaterialFlag.Color.toRaw() }
    public var isTexture: Bool { return (flags & MaterialFlag.Texture.toRaw()) == MaterialFlag.Texture.toRaw() }
    public var isTransparent: Bool { return (flags & MaterialFlag.Transparent.toRaw()) == MaterialFlag.Transparent.toRaw() }
}
