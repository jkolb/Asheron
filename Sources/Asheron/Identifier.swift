/*
The MIT License (MIT)

Copyright (c) 2020 Justin Kolb

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

public struct DBType {
    public enum Source {
        case unknown
        case server
        case portal // & highres
        case cell
        case local
    }

    public static let landBlock = DBType(source: .cell, name: "LandBlock", enumCode: 1, idRange: nil, fileExtension: [])
    public static let lbi = DBType(source: .cell, name: "LandBlockInfo", enumCode: 2, idRange: nil, fileExtension: ["lbi"])
    public static let envCell = DBType(source: .cell, name: "EnvCell", enumCode: 3, idRange: UInt32(0x01010000)...UInt32(0x013EFFFF), fileExtension: [])
    public static let lbo = DBType(source: .unknown, name: "LandBlockObjects", enumCode: 4, idRange: nil, fileExtension: ["lbo"])
    public static let instantiation = DBType(source: .unknown, name: "Instantiation", enumCode: 5, idRange: nil, fileExtension: ["ins"])
    public static let gfxObj = DBType(source: .portal, name: "GraphicsObject", enumCode: 6, idRange: UInt32(0x01000000)...UInt32(0x0100FFFF), fileExtension: ["obj"])
    public static let setup = DBType(source: .portal, name: "Setup", enumCode: 7, idRange: UInt32(0x02000000)...UInt32(0x0200FFFF), fileExtension: ["set"])
    public static let anim = DBType(source: .portal, name: "Animation", enumCode: 8, idRange: UInt32(0x03000000)...UInt32(0x0300FFFF), fileExtension: ["anm"])
    public static let animationHook = DBType(source: .unknown, name: "AnimationHook", enumCode: 9, idRange: nil, fileExtension: ["hk"])
    public static let palette = DBType(source: .portal, name: "Palette", enumCode: 10, idRange: UInt32(0x04000000)...UInt32(0x0400FFFF), fileExtension: ["pal"])
    public static let surfaceTexture = DBType(source: .portal, name: "SurfaceTexture", enumCode: 11, idRange: UInt32(0x05000000)...UInt32(0x05FFFFFF), fileExtension: ["texture"])
    public static let renderSurface = DBType(source: .portal, name: "Texture", enumCode: 12, idRange: UInt32(0x06000000)...UInt32(0x07FFFFFF), fileExtension: ["bmp", "jpg", "dds", "tga", "iff", "256", "csi", "alp"])
    public static let surface = DBType(source: .portal, name: "Surface", enumCode: 13, idRange: UInt32(0x08000000)...UInt32(0x0800FFFF), fileExtension: ["surface"])
    public static let mtable = DBType(source: .portal, name: "MotionTable", enumCode: 14, idRange: UInt32(0x09000000)...UInt32(0x0900FFFF), fileExtension: ["dsc"])
    public static let wave = DBType(source: .portal, name: "Wave", enumCode: 15, idRange: UInt32(0x0A000000)...UInt32(0x0A00FFFF), fileExtension: ["wav", "mp3"])
    public static let environment = DBType(source: .portal, name: "Environment", enumCode: 16, idRange: UInt32(0x0A000000)...UInt32(0x0A00FFFF), fileExtension: ["env"])
    
    public var source: Source
    public var name: String
    public var enumCode: UInt32
    public var idRange: ClosedRange<UInt32>?
    public var fileExtension: [String]
    
    public init(source: Source, name: String, enumCode: UInt32, idRange: ClosedRange<UInt32>?, fileExtension: [String]) {
        self.source = source
        self.name = name
        self.enumCode = enumCode
        self.idRange = idRange
        self.fileExtension = fileExtension
    }
    
    public func matches(id: Identifier) -> Bool {
        guard let idRange = idRange else {
            return false
        }
        
        return idRange.contains(id.bits)
    }
}

public struct Identifier : Comparable, Hashable, CustomStringConvertible, Packable {
    public let bits: UInt32
    
    public init(_ bits: UInt32) {
        self.bits = bits
    }
    
    public static func <(a: Identifier, b: Identifier) -> Bool {
        return a.bits < b.bits
    }
    
    public var description: String {
        return String(format: "%08X", bits)
    }
    
    public init(from dataStream: DataStream) {
        self.bits = UInt32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        bits.encode(to: dataStream)
    }
}
