//
//  Palette.swift
//  AC
//
//  Created by Justin Kolb on 7/20/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getColor() -> Color {
        let b = getUInt8()
        let g = getUInt8()
        let r = getUInt8()
        let a = getUInt8()
        return Color(r, g, b, a)
    }
    
    public func getColor(count: Int) -> [Color] {
        return getArray(count, defaultValue: Color()) { self.getColor() }
    }
}

public struct Color : CustomStringConvertible {
    public let r: UInt8
    public let g: UInt8
    public let b: UInt8
    public let a: UInt8
    
    public init() {
        r = 0; g = 0; b = 0; a = 255;
    }
    
    public init(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: UInt8 = UInt8.max) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    public init(r: Float, g: Float, b: Float, a: Float = 1.0) {
        self.r = Color.clamp(r)
        self.g = Color.clamp(g)
        self.b = Color.clamp(b)
        self.a = Color.clamp(a)
    }
    
    public init (floatComponents: [Float]) {
        r = Color.clamp(floatComponents[0])
        g = Color.clamp(floatComponents[1])
        b = Color.clamp(floatComponents[2])
        a = Color.clamp(floatComponents[3])
    }
    
    public var components: [UInt8] {
    return [r, g, b, a]
    }
    
    public var floatComponents: [Float] {
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

    public var description: String { return "r:\(hex(r)) g:\(hex(g)) b:\(hex(b)) a:\(hex(a))" }
}

extension ByteBuffer {
    public func getPalette() -> Palette {
        let identifier = getUInt32()
        let size = getIntFrom32Bits()
        let color = getColor(size)
        return Palette(identifier: identifier, size: size, color: color)
    }
}

public struct Palette {
    public let identifier: UInt32
    public let size: Int
    public let color: [Color]
}
