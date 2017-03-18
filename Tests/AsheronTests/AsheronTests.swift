/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Justin Kolb
 
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

import XCTest
@testable import Asheron

class AsheronTests: XCTestCase {
    func testExample() {
        let buffer24Bit = ByteStream(buffer: ByteBuffer(count: 3))
        buffer24Bit.putInt24(-8388608)
        buffer24Bit.reset()
        XCTAssertEqual(buffer24Bit.getInt24(), -8388608)
        buffer24Bit.reset()
        buffer24Bit.putInt24(8388607)
        buffer24Bit.reset()
        XCTAssertEqual(buffer24Bit.getInt24(), 8388607)
        buffer24Bit.reset()
        buffer24Bit.putUInt24(16777215)
        buffer24Bit.reset()
        XCTAssertEqual(buffer24Bit.getUInt24(), 16777215)
        
        let utf8Buffer = ByteStream(buffer: ByteBuffer(count: 6))
        utf8Buffer.putUTF8("ABCDEF")
        utf8Buffer.reset()
        XCTAssertEqual(utf8Buffer.getUTF8(count: 4), "ABCD")
        
        let arrayBuffer = ByteStream(buffer: ByteBuffer(count: 4))
        arrayBuffer.putUInt8([0, 1, 2, 3])
        arrayBuffer.reset()
        XCTAssertEqual(arrayBuffer.getUInt8(count: 4), [0, 1, 2, 3])
        
        let cStringBuffer = ByteStream(buffer: ByteBuffer(count: 4))
        cStringBuffer.putCString("ABC")
        XCTAssert(!cStringBuffer.hasRemaining)
        cStringBuffer.reset()
        XCTAssertEqual(cStringBuffer.getCString(), "ABC")
        
        let textureData = TextureData(handle: PortalHandle<TextureData>(index: 1), width: 320, height: 200, format: .p8(PortalHandle<Asheron.ColorTable>(index: 1)), data: ByteBuffer(count: 1))
        XCTAssertEqual(textureData.description, "textureData(06000001)")
        
        XCTAssertEqual(hex(UInt8(0xFF)), "FF")
//        let indexFile = try! IndexFile.openForReading(at: "/Users/jkolb/src/Dereth/Data/client_portal.dat")
//        let textureHandles = try! indexFile.handles(matching: { UInt16($0 >> 16) == PortalKind.texture.rawValue })
//        print(textureHandles)
//        let portalFile = PortalFile(indexFile: indexFile)
//        let texture = try! portalFile.fetchTexture(handle: PortalHandle(rawValue: textureHandles.first!)!)
//        print(texture)

        let cellIndexFile = try! IndexFile.openForReading(at: "/Users/jkolb/src/Dereth/Data/client_cell_1.dat")
        let cellFile = CellFile(indexFile: cellIndexFile)

        var blocks = [[TerrainBlock]]()
        let maxX = 17
        let maxY = 17
        
        for x in 0..<UInt8(maxX) {
            var array = [TerrainBlock]()
            
            for y in 0..<UInt8(maxY) {
                array.append(try! cellFile.fetchTerrainBlock(x: x, y: y))
            }
            
            blocks.append(array)
        }
        
        var string = ""
        let size = TerrainBlock.size
        
        for blockX in 0..<maxX {
            for x in 0..<size {
                for blockY in 0..<maxY {
                    let block = blocks[blockX][blockY]

                    for y in 0..<size {
                        string += hex(block.getHeight(x: x, y: y))
                    }
                }
                
                string += "\n"
            }
        }
        
        print(string)
    }


    static var allTests : [(String, (AsheronTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
