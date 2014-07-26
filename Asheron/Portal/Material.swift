//
//  Material.swift
//  AC
//
//  Created by Justin Kolb on 7/20/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    func getMaterial() -> Material {
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
    
    func getMaterial(count: Int) -> Array<Material> {
        return getArray(count) { self.getMaterial() }
    }
}

enum MaterialFlag: UInt32 {
    case Color = 0x00000001
    case Solid = 0x00000002
    case Transparent = 0x00000004 // ?? How is this different from Solid off, where did these come from?
}

struct Material {
    let identifier: UInt32
    let flags: UInt32
    let color: Color
    let textureId: UInt32
    let paletteId: UInt32
    let light1: Float
    let light2: Float
    let light3: Float
    
    var isColor: Bool { return (flags & MaterialFlag.Color.toRaw()) == MaterialFlag.Color.toRaw() }
    var isSolid: Bool { return (flags & MaterialFlag.Solid.toRaw()) == MaterialFlag.Solid.toRaw() }
    var isTransparent: Bool { return (flags & MaterialFlag.Transparent.toRaw()) == MaterialFlag.Transparent.toRaw() }
}
