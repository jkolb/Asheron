//
//  File.swift
//  AC
//
//  Created by Justin Kolb on 7/20/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getTexture() -> Texture {
        let identifier = getUInt32()
        let type = getUInt32()
        let width = getIntFrom32Bits()
        let height = getIntFrom32Bits()
        
        var dataSize = 0
        
        if type == 2 || type == 11 {
            dataSize = width * height
        } else if type == 4 || type == 7 {
            dataSize = width * height * 2
        } else if type == 10 {
            dataSize = width * height * 3
        }
        
        let data = getUInt8(dataSize)
        var paletteID: UInt32 = 0
        
        if type == 2 {
            paletteID = getUInt32()
        }
        
        assert(remaining == 0, "Not fully parsed")
        
        return Texture(
            identifier: identifier,
            type: type,
            width: width,
            height: height,
            data: data,
            paletteID: paletteID
        )
    }
}

public enum TextureType: UInt32 {
    case Palette = 2    // Doesn't matter
    case PackedARGB = 4 // GL_BGRA, GL_UNSIGNED_SHORT_4_4_4_4_REV (swapped while reading)
    case PackedRGB = 7  // GL_RGB, GL_UNSIGNED_SHORT_5_6_5        (swapped while reading)
    case Planar = 10    // GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV   (p0 = r, p1 = g, p2 = b)
    case Luminance = 11 // GL_LUMINANCE, GL_UNSIGNED_BYTE
}

public struct Texture {
    public let identifier: UInt32
    public let type: UInt32
    public let width: Int
    public let height: Int
    public let data: [UInt8]
    public let paletteID: UInt32
}
