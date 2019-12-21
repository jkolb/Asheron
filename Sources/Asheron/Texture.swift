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

import Foundation

public final class Texture : Identifiable {
    public enum Category: UInt32, Packable {
        case unknown   = 0
        case foilage   = 1
        case terrain   = 2
        case sky       = 3
        case player    = 4
        case monster   = 5
        case icon      = 6
        case detail    = 7
        case dungeon   = 8
        case particle  = 9
        case font      = 10
    }
    
    public var id: Identifier
    public var category: Category
    public var width: Int
    public var height: Int
    public var format: PixelFormat
    public var palette: Identifier?
    public var data: Data

    public init(from dataStream: DataStream, id: Identifier) {
        let diskId = Identifier(from: dataStream)
        precondition(diskId == id)
        self.id = id
        self.category = Category(from: dataStream)
        self.width = numericCast(Int32(from: dataStream))
        self.height = numericCast(Int32(from: dataStream))
        self.format = PixelFormat(from: dataStream)
        let count: Int = numericCast(UInt32(from: dataStream))
        self.data = Data(from: dataStream, count: count)
        self.palette = format.hasPalette ? Identifier(from: dataStream) : nil
    }

    public func makeBitmap(palette: Palette? = nil) -> BitmapV4 {
        let bitmapData = makeBitmapData(palette: palette)
        let bitmap = BitmapV4()
        bitmap.bitmapData = bitmapData
        bitmap.infoHeader.width = numericCast(width)
        bitmap.infoHeader.height = numericCast(-height)
        bitmap.infoHeader.sizeImage = numericCast(bitmapData.count)
        bitmap.fileHeader.size = BitmapFileHeader.byteSize + bitmap.infoHeader.size + bitmap.infoHeader.sizeImage
        bitmap.fileHeader.offBits = BitmapFileHeader.byteSize + bitmap.infoHeader.size
        return bitmap
    }
    
    public func makeBitmapData(palette: Palette?) -> Data {
        switch format {
        case .r8g8b8:
            return convert(from: RGB888.self)

        case .a8r8g8b8:
            return data
            
        case .r5g6b5:
            return convert(from: RGB565.self)

        case .a4r4g4b4:
            return convert(from: ARGB4444.self)

        case .a8:
            return convert(from: A8.self)

        case .p8:
            return convert(from: UInt8.self, using: palette!)

        case .dxt1:
            return convert(from: DXT1Block.self)
            
        case .dxt3:
            return convert(from: DXT3Block.self)

        case .dxt5:
            return convert(from: DXT5Block.self)

        case .index16:
            return convert(from: UInt16.self, using: palette!)
            
        case .b8g8r8Landscape:
            return convert(from: BGR888.self)

        case .alphaLandscape:
            return convert(from: A8.self)

        case .rawJPEG:
            return data
        }
    }
    
    public func convert<Pixel : RGBA>(from pixelType: Pixel.Type) -> Data {
        let pixelCount = data.count / Pixel.byteCount
        let outputByteCount = pixelCount * ARGB8888.byteCount
        let dataStream = DataStream(data: data)
        let bitmapStream = DataStream(count: outputByteCount)
        
        while dataStream.remainingCount > 0 {
            Pixel(from: dataStream).argb8888.encode(to: bitmapStream)
        }
        
        precondition(dataStream.remainingCount == 0)
        precondition(bitmapStream.remainingCount == 0)
        return bitmapStream.data
    }
    
    public func convert<Index : UnsignedInteger & Packable>(from indexType: Index.Type, using palette: Palette) -> Data {
        let indicesCount = data.count / MemoryLayout<Index>.size
        let outputByteCount = indicesCount * ARGB8888.byteCount
        let dataStream = DataStream(data: data)
        let bitmapStream = DataStream(count: outputByteCount)
        
        while dataStream.remainingCount > 0 {
            palette[numericCast(Index(from: dataStream))].encode(to: bitmapStream)
        }
        
        precondition(dataStream.remainingCount == 0)
        precondition(bitmapStream.remainingCount == 0)
        return bitmapStream.data
    }
    
    public func convert<DXT : DXTBlock>(from dxtType: DXT.Type) -> Data {
        let dataStream = DataStream(data: data)
        let blockCount = data.count / DXT.byteCount
        let blocks = [DXT](from: dataStream, count: blockCount)
        let blockSize = 4
        let outputByteCount = blockCount * blockSize * blockSize * ARGB8888.byteCount
        let bitmapStream = DataStream(count: outputByteCount)
        
        let blocksWide = width / blockSize
        let blocksTall = height / blockSize
        var blockIndex = 0
        
        for _ in 0..<blocksTall {
            for row in 0..<blockSize {
                let colorIndex = row * blockSize
                
                for blockOffset in 0..<blocksWide {
                    let block = blocks[blockIndex + blockOffset]
                    
                    for colorOffset in 0..<blockSize {
                        block.color(at: colorIndex + colorOffset).encode(to: bitmapStream)
                    }
                }
            }
            
            blockIndex += blocksWide
        }
        
        precondition(dataStream.remainingCount == 0)
        precondition(bitmapStream.remainingCount == 0)
        return bitmapStream.data
    }
}
