/*
 The MIT License (MIT)
 
 Copyright (c) 2018 Justin Kolb
 
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

public enum SidesType : UInt32 {
    case single = 0
    case double = 1
    case both = 2
}

public struct StipplingType : OptionSet {
    public static let NO_STIPPLING: StipplingType = []
    public static let POSITIVE_STIPPLING = StipplingType(rawValue: 1 << 0)
    public static let NEGATIVE_STIPPLING = StipplingType(rawValue: 1 << 1)
    public static let BOTH_STIPPLING: StipplingType = [.POSITIVE_STIPPLING, .NEGATIVE_STIPPLING]
    public static let NO_POS_UVS = StipplingType(rawValue: 1 << 2)
    public static let NO_NEG_UVS = StipplingType(rawValue: 1 << 3)
    public static let NO_UVS: StipplingType = [.NO_POS_UVS, .NO_NEG_UVS]

    public let rawValue: UInt8
    
    public init(rawValue: UInt8) {
        precondition(rawValue != 20) // NO_UVS == 20 ??
        self.rawValue = rawValue
    }
}

public struct CPolygon {
    public var polyId: UInt16
    public var stippling: StipplingType
    public var sidesType: SidesType
    public var posSurface: UInt16
    public var negSurface: UInt16
    public var vertexIds: [UInt16]
    public var posUVIndices: [UInt8]
    public var negUVIndices: [UInt8]
    
    public init(polyId: UInt16, stippling: StipplingType, sidesType: SidesType, posSurface: UInt16, negSurface: UInt16, vertexIds: [UInt16], posUVIndices: [UInt8], negUVIndices: [UInt8]) {
        self.polyId = polyId
        self.stippling = stippling
        self.sidesType = sidesType
        self.posSurface = posSurface
        self.negSurface = negSurface
        self.vertexIds = vertexIds
        self.posUVIndices = posUVIndices
        self.negUVIndices = negUVIndices
    }
}
