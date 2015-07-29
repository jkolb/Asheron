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
        let hasBackFace = getUInt16()
        let unknown1 = getUInt16()
        let frontMaterialIndex = getIntFrom16Bits()
        let backMaterialIndex = getIntFrom16Bits()
        let vertexIndex = getIntFrom16Bits(count)
        var texcoordIndex1: Array<Int>
        var texcoordIndex2: Array<Int>
        var unknown2: Array<UInt8>
        
        if type == 0 || type == 1 || type == 3 {
            texcoordIndex1 = getIntFrom8Bits(count)
        } else {
            texcoordIndex1 = Array<Int>()
        }

        if hasBackFace == 2 {
            texcoordIndex2 = getIntFrom8Bits(count)
        } else {
            texcoordIndex2 = Array<Int>()
        }

        let vertexIndexByteCount = vertexIndex.count * sizeof(UInt16)
        let texcoord1IndexByteCount = texcoordIndex1.count * sizeof(UInt8)
        let texcoord2IndexByteCount = texcoordIndex2.count * sizeof(UInt8)
        let byteCount = vertexIndexByteCount + texcoord1IndexByteCount + texcoord2IndexByteCount
        let padding = (4 - (byteCount % 4)) % 4
        unknown2 = getUInt8(padding);
        
        return Polygon(
            index: index,
            count: count,
            type: type,
            hasBackFace: hasBackFace,
            unknown1: unknown1,
            frontMaterialIndex: frontMaterialIndex,
            backMaterialIndex: backMaterialIndex,
            vertexIndex: vertexIndex,
            texcoordIndex1: texcoordIndex1,
            texcoordIndex2: texcoordIndex2,
            unknown2: unknown2
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

public struct Polygon : CustomStringConvertible {
    public let index: Int
    public let count: Int
    public let type: Int
    public let hasBackFace: UInt16
    public let unknown1: UInt16
    public let frontMaterialIndex: Int
    public let backMaterialIndex: Int
    public let vertexIndex: Array<Int>
    public let texcoordIndex1: Array<Int>
    public let texcoordIndex2: Array<Int>
    public let unknown2: Array<UInt8>

    public var description: String {
        return "\(index)\n\tcount: \(count)\n\ttype: \(type)\n\thasBackFace: \(hasBackFace)\n\tunknown1: \(unknown1)"
    }
}
