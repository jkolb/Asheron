//
//  Palette.swift
//  AC
//
//  Created by Justin Kolb on 7/20/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    func getColor() -> Color {
        return Color(bgra: getUInt32())
    }
    
    func getColor(count: Int) -> Array<Color> {
        return getArray(count, defaultValue: Color()) { self.getColor() }
    }
}

struct Color {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8
    
    init() {
        r = 0; g = 0; b = 0; a = 255;
    }
    
    init(bgra: UInt32) {
        b = UInt8((bgra & 0xFF000000) >> 24)
        g = UInt8((bgra & 0x00FF0000) >> 16)
        r = UInt8((bgra & 0x0000FF00) >> 08)
        a = UInt8((bgra & 0x000000FF) >> 00)
    }
    
    init(rgba: UInt32) {
        r = UInt8((rgba & 0xFF000000) >> 24)
        g = UInt8((rgba & 0x00FF0000) >> 16)
        b = UInt8((rgba & 0x0000FF00) >> 08)
        a = UInt8((rgba & 0x000000FF) >> 00)
    }
    
    init(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: UInt8 = UInt8.max) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    init(r: Float, g: Float, b: Float, a: Float = 1.0) {
        self.r = Color.clamp(r)
        self.g = Color.clamp(g)
        self.b = Color.clamp(b)
        self.a = Color.clamp(a)
    }
    
    init (floatComponents: Array<Float>) {
        r = Color.clamp(floatComponents[0])
        g = Color.clamp(floatComponents[1])
        b = Color.clamp(floatComponents[2])
        a = Color.clamp(floatComponents[3])
    }
    
    var components: Array<UInt8> {
    return [r, g, b, a]
    }
    
    var floatComponents: Array<Float> {
    return [
        Color.floatComponent(r),
        Color.floatComponent(g),
        Color.floatComponent(b),
        Color.floatComponent(a)
        ]
    }
    
    static func clamp(value: Float) -> UInt8 {
        let clamped = max(min(value, 1.0), 0.0)
        return UInt8(clamped * Float(UInt8.max))
    }
    
    static func floatComponent(value: UInt8) -> Float {
        return Float(value) / Float(UInt8.max)
    }
}

extension ByteBuffer {
    func getPalette() -> Palette {
        let identifier = getUInt32()
        let size = getIntFrom32Bits()
        let color = getColor(size)
        return Palette(identifier: identifier, size: size, color: color)
    }
    
    func getPalette(count: Int) -> Array<Palette> {
        return getArray(count) { self.getPalette() }
    }
}

struct Palette {
    let identifier: UInt32
    let size: Int
    let color: Array<Color>
}
