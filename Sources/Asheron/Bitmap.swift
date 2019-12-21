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

public struct BitmapFileHeader : Packable {
    public static var byteSize: UInt32 = 14
    public var size: UInt32
    public var offBits: UInt32

    public init() {
        self.size = 0
        self.offBits = 0
    }
    
    public init(from dataStream: DataStream) {
        let bmBytes = [UInt8](from: dataStream, count: 2) // BM
        let bmString = String(bytes: bmBytes, encoding: .utf8)!
        precondition(bmString == "BM")
        self.size = UInt32(from: dataStream)
        let _ = UInt16(from: dataStream) // Reserved1
        let _ = UInt16(from: dataStream) // Reserved2
        self.offBits = UInt32(from: dataStream)
    }
    
    public func encode(to dataStream: DataStream) {
        "B".utf8.first!.encode(to: dataStream)
        "M".utf8.first!.encode(to: dataStream)
        size.encode(to: dataStream)
        UInt16(0).encode(to: dataStream) // Reserved1
        UInt16(0).encode(to: dataStream) // Reserved2
        offBits.encode(to: dataStream)
    }
}

public protocol BitmapInfoHeader : Packable {
    var size: UInt32 { get }
}

public struct BitmapV4Header : BitmapInfoHeader {
    public let size: UInt32 = 108 // The number of bytes required by the structure.
    
    public var width: Int32 // The width of the bitmap, in pixels.
    public var height: Int32 // The height of the bitmap, in pixels. If biHeight is positive, the bitmap is a bottom-up DIB and its origin is the lower-left corner. If biHeight is negative, the bitmap is a top-down DIB and its origin is the upper-left corner. If biHeight is negative, indicating a top-down DIB, biCompression must be either BI_RGB or BI_BITFIELDS. Top-down DIBs cannot be compressed.
    public var planes: UInt16 // The number of planes for the target device. This value must be set to 1.
    public var bitCount: BitmapBitCount
    public var compression: BitmapCompression
    public var sizeImage: UInt32 // The size, in bytes, of the image. This may be set to zero for BI_RGB bitmaps.
    public var xPelsPerMeter: Int32 // The horizontal resolution, in pixels-per-meter, of the target device for the bitmap. An application can use this value to select a bitmap from a resource group that best matches the characteristics of the current device.
    public var yPelsPerMeter: Int32 // The vertical resolution, in pixels-per-meter, of the target device for the bitmap.
    public var clrUsed: UInt32 // The number of color indexes in the color table that are actually used by the bitmap. If this value is zero, the bitmap uses the maximum number of colors corresponding to the value of the biBitCount member for the compression mode specified by biCompression. If biClrUsed is nonzero and the biBitCount member is less than 16, the biClrUsed member specifies the actual number of colors the graphics engine or device driver accesses. If biBitCount is 16 or greater, the biClrUsed member specifies the size of the color table used to optimize performance of the system color palettes. If biBitCount equals 16 or 32, the optimal color palette starts immediately following the three DWORD masks. When the bitmap array immediately follows the BITMAPINFO structure, it is a packed bitmap. Packed bitmaps are referenced by a single pointer. Packed bitmaps require that the biClrUsed member must be either zero or the actual size of the color table.
    public var clrImportant: UInt32 // The number of color indexes that are required for displaying the bitmap. If this value is zero, all colors are required.
    public var redMask: UInt32
    public var greenMask: UInt32
    public var blueMask: UInt32
    public var alphaMask: UInt32
    public var csType: UInt32 // Device-dependent RGB (everything following is not used)
    public var endpoints: CIEXYZTRIPLE
    public var gammaRed: UInt32
    public var gammaGreen: UInt32
    public var gammaBlue: UInt32
    
    public init() {
        self.width = 0
        self.height = 0
        self.planes = 1
        self.bitCount = .thirtytwo
        self.compression = .bitfields
        self.sizeImage = 0
        self.xPelsPerMeter = 0
        self.yPelsPerMeter = 0
        self.clrUsed = 0
        self.clrImportant = 0
        self.redMask = 0b0000_0000_1111_1111_0000_0000_0000_0000
        self.greenMask = 0b0000_0000_0000_0000_1111_1111_0000_0000
        self.blueMask = 0b0000_0000_0000_0000_0000_0000_1111_1111
        self.alphaMask = 0b1111_1111_0000_0000_0000_0000_0000_0000
        self.csType = 1
        self.endpoints = CIEXYZTRIPLE()
        self.gammaRed = 0
        self.gammaGreen = 0
        self.gammaBlue = 0
    }
    
    public init(from dataStream: DataStream) {
        let size = UInt32(from: dataStream)
        self.width = Int32(from: dataStream)
        self.height = Int32(from: dataStream)
        self.planes = UInt16(from: dataStream)
        self.bitCount = BitmapBitCount(from: dataStream)
        self.compression = BitmapCompression(from: dataStream)
        self.sizeImage = UInt32(from: dataStream)
        self.xPelsPerMeter = Int32(from: dataStream)
        self.yPelsPerMeter = Int32(from: dataStream)
        self.clrUsed = UInt32(from: dataStream)
        self.clrImportant = UInt32(from: dataStream)
        self.redMask = UInt32(from: dataStream)
        self.greenMask = UInt32(from: dataStream)
        self.blueMask = UInt32(from: dataStream)
        self.alphaMask = UInt32(from: dataStream)
        self.csType = UInt32(from: dataStream)
        self.endpoints = CIEXYZTRIPLE(from: dataStream)
        self.gammaRed = UInt32(from: dataStream)
        self.gammaGreen = UInt32(from: dataStream)
        self.gammaBlue = UInt32(from: dataStream)
        precondition(size == self.size)
    }
    
    public func encode(to dataStream: DataStream) {
        size.encode(to: dataStream)
        width.encode(to: dataStream)
        height.encode(to: dataStream)
        planes.encode(to: dataStream)
        bitCount.encode(to: dataStream)
        compression.encode(to: dataStream)
        sizeImage.encode(to: dataStream)
        xPelsPerMeter.encode(to: dataStream)
        yPelsPerMeter.encode(to: dataStream)
        clrUsed.encode(to: dataStream)
        clrImportant.encode(to: dataStream)
        redMask.encode(to: dataStream)
        greenMask.encode(to: dataStream)
        blueMask.encode(to: dataStream)
        alphaMask.encode(to: dataStream)
        csType.encode(to: dataStream)
        endpoints.encode(to: dataStream)
        gammaRed.encode(to: dataStream)
        gammaGreen.encode(to: dataStream)
        gammaBlue.encode(to: dataStream)
    }
}

public enum BitmapBitCount : UInt16 {
    case none = 0 // The number of bits-per-pixel is specified or is implied by the JPEG or PNG format.
    case one =  1 // The bitmap is monochrome, and the bmiColors member of BITMAPINFO contains two entries. Each bit in the bitmap array represents a pixel. If the bit is clear, the pixel is displayed with the color of the first entry in the bmiColors table; if the bit is set, the pixel has the color of the second entry in the table.
    case four = 4 // The bitmap has a maximum of 16 colors, and the bmiColors member of BITMAPINFO contains up to 16 entries. Each pixel in the bitmap is represented by a 4-bit index into the color table. For example, if the first byte in the bitmap is 0x1F, the byte represents two pixels. The first pixel contains the color in the second table entry, and the second pixel contains the color in the sixteenth table entry.
    case sixteen = 16 // The bitmap has a maximum of 2^16 colors. If the biCompression member of the BITMAPINFOHEADER is BI_RGB, the bmiColors member of BITMAPINFO is NULL. Each WORD in the bitmap array represents a single pixel. The relative intensities of red, green, and blue are represented with five bits for each color component. The value for blue is in the least significant five bits, followed by five bits each for green and red. The most significant bit is not used. The bmiColors color table is used for optimizing colors used on palette-based devices, and must contain the number of entries specified by the biClrUsed member of the BITMAPINFOHEADER. If the biCompression member of the BITMAPINFOHEADER is BI_BITFIELDS, the bmiColors member contains three DWORD color masks that specify the red, green, and blue components, respectively, of each pixel. Each WORD in the bitmap array represents a single pixel. When the biCompression member is BI_BITFIELDS, bits set in each DWORD mask must be contiguous and should not overlap the bits of another mask. All the bits in the pixel do not have to be used.
    case twentyfour = 24 // The bitmap has a maximum of 2^24 colors, and the bmiColors member of BITMAPINFO is NULL. Each 3-byte triplet in the bitmap array represents the relative intensities of blue, green, and red, respectively, for a pixel. The bmiColors color table is used for optimizing colors used on palette-based devices, and must contain the number of entries specified by the biClrUsed member of the BITMAPINFOHEADER.
    case thirtytwo = 32 // The bitmap has a maximum of 2^32 colors. If the biCompression member of the BITMAPINFOHEADER is BI_RGB, the bmiColors member of BITMAPINFO is NULL. Each DWORD in the bitmap array represents the relative intensities of blue, green, and red for a pixel. The value for blue is in the least significant 8 bits, followed by 8 bits each for green and red. The high byte in each DWORD is not used. The bmiColors color table is used for optimizing colors used on palette-based devices, and must contain the number of entries specified by the biClrUsed member of the BITMAPINFOHEADER. If the biCompression member of the BITMAPINFOHEADER is BI_BITFIELDS, the bmiColors member contains three DWORD color masks that specify the red, green, and blue components, respectively, of each pixel. Each DWORD in the bitmap array represents a single pixel. When the biCompression member is BI_BITFIELDS, bits set in each DWORD mask must be contiguous and should not overlap the bits of another mask. All the bits in the pixel do not need to be used.
}

public enum BitmapCompression : UInt32 {
    case rgb = 0 // An uncompressed format.
    case rle8 = 1 // A run-length encoded (RLE) format for bitmaps with 8 bpp. The compression format is a 2-byte format consisting of a count byte followed by a byte containing a color index. For more information, see Bitmap Compression.
    case rle4 = 2 // An RLE format for bitmaps with 4 bpp. The compression format is a 2-byte format consisting of a count byte followed by two word-length color indexes. For more information, see Bitmap Compression.
    case bitfields = 3 // Specifies that the bitmap is not compressed and that the color table consists of three DWORD color masks that specify the red, green, and blue components, respectively, of each pixel. This is valid when used with 16- and 32-bpp bitmaps.
}

public struct CIEXYZ : Packable {
    public let x: UInt32
    public let y: UInt32
    public let z: UInt32

    public init() {
        self.x = 0
        self.y = 0
        self.z = 0
    }
    
    public init(from dataStream: DataStream) {
        self.x = UInt32(from: dataStream)
        self.y = UInt32(from: dataStream)
        self.z = UInt32(from: dataStream)
    }

    public func encode(to dataStream: DataStream) {
        x.encode(to: dataStream)
        y.encode(to: dataStream)
        z.encode(to: dataStream)
    }
}

public struct CIEXYZTRIPLE : Packable {
    public let red: CIEXYZ
    public let green: CIEXYZ
    public let blue: CIEXYZ
    
    public init() {
        self.red = CIEXYZ()
        self.green = CIEXYZ()
        self.blue = CIEXYZ()
    }
    
    public init(from dataStream: DataStream) {
        self.red = CIEXYZ(from: dataStream)
        self.green = CIEXYZ(from: dataStream)
        self.blue = CIEXYZ(from: dataStream)
    }
    
    public func encode(to dataStream: DataStream) {
        red.encode(to: dataStream)
        green.encode(to: dataStream)
        blue.encode(to: dataStream)
    }
}

public class BitmapV4 : Packable {
    public var fileHeader: BitmapFileHeader
    public var infoHeader: BitmapV4Header
    public var bitmapData: Data
    
    public init() {
        self.fileHeader = BitmapFileHeader()
        self.infoHeader = BitmapV4Header()
        self.bitmapData = Data(count: 0)
    }

    public required init(from dataStream: DataStream) {
        self.fileHeader = BitmapFileHeader(from: dataStream)
        self.infoHeader = BitmapV4Header(from: dataStream)
        self.bitmapData = Data(from: dataStream)
    }
    
    public func encode(to dataStream: DataStream) {
        fileHeader.encode(to: dataStream)
        infoHeader.encode(to: dataStream)
        bitmapData.encode(to: dataStream)
    }
    
    public var byteSize: Int {
        return Int(BitmapFileHeader.byteSize) + Int(infoHeader.size) + bitmapData.count
    }
}
