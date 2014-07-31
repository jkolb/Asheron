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
        let padding = getUInt32()
        assert(padding == 0, "Usually 0, want to find out if it is ever not")
        let backWindingOrder = getInt16()
        let frontWindingOrder = getInt16()
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
            padding: padding,
            backWindingOrder: backWindingOrder,
            frontWindingOrder: frontWindingOrder,
            vertexIndex: vertexIndex,
            texcoordIndex: texcoordIndex
        )
    }
    
    public func getPolygon(count: Int) -> Array<Polygon> {
        return getArray(count) { self.getPolygon() }
    }
}

public enum PolygonType: Int {
    case Textured = 0 // type 1 has same format
    case Colored = 4
}

public struct Polygon {
    public let index: Int
    public let count: Int
    public let type: Int
    public let padding: UInt32
    public let backWindingOrder: Int16
    public let frontWindingOrder: Int16
    public let vertexIndex: Array<Int>
    public let texcoordIndex: Array<Int>
}
