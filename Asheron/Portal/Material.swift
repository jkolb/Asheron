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
    case Color = 0x00000001
    case Solid = 0x00000002
    case Transparent = 0x00000004 // ?? How is this different from Solid off, where did these come from?
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
    public var isSolid: Bool { return (flags & MaterialFlag.Solid.toRaw()) == MaterialFlag.Solid.toRaw() }
    public var isTransparent: Bool { return (flags & MaterialFlag.Transparent.toRaw()) == MaterialFlag.Transparent.toRaw() }
}
