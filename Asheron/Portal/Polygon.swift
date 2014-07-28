//
//  Polygon.swift
//  AC
//
//  Created by Justin Kolb on 7/20/14.
//  Copyright (c) 2014 Justin Kolb. All rights reserved.
//

import Lilliput

extension ByteBuffer {
    public func getPolygon() -> Polygon {
        let index = getIntFrom16Bits()
        let count = getIntFrom8Bits()
        let type = getIntFrom8Bits()
        let unknown1 = getUInt16()
        let unknown2 = getUInt16()
        let materialIndex = getIntFrom16Bits()
        let unknown3 = getUInt16()
        let vertexIndex = getIntFrom16Bits(count)
        var texcoordIndex: Array<Int>
        
        if type == PolygonType.Colored.toRaw() {
            texcoordIndex = Array<Int>()
            let padCount = count % 2
            getUInt16(padCount) // Skip padding
        } else {
            texcoordIndex = getIntFrom8Bits(count)
            let padCount = count % 4
            getUInt8(padCount) // Skip padding
        }
        
        return Polygon(
            index: index,
            count: count,
            type: type,
            unknown1: unknown1,
            unknown2: unknown2,
            materialIndex: materialIndex,
            unknown3: unknown3,
            vertexIndex: vertexIndex,
            texcoordIndex: texcoordIndex
        )
    }
    
    public func getPolygon(count: Int) -> Array<Polygon> {
        return getArray(count) { self.getPolygon() }
    }
}

public enum PolygonType: Int {
    case Textured = 0
    case Colored = 4
}

public struct Polygon {
    public let index: Int
    public let count: Int
    public let type: Int
    public let unknown1: UInt16
    public let unknown2: UInt16
    public let materialIndex: Int
    public let unknown3: UInt16
    public let vertexIndex: Array<Int>
    public let texcoordIndex: Array<Int>
}
