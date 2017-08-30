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
        
        let textureData = TextureData(handle: TextureDataHandle(index: 1), width: 320, height: 200, format: .p8(ColorTableHandle(index: 1)), data: ByteBuffer(count: 1))
        XCTAssertEqual(textureData.description, "textureData(06000001)")
        
        XCTAssertEqual(hex(UInt8(0xFF)), "FF")
        
        let indexFile = try! IndexFile.openForReading(at: "Data/client_portal.dat")
        let handles = try! indexFile.handles(matching: { TextureListHandle(rawValue: $0) != nil })
        let portalFile = PortalFile(indexFile: indexFile)

        let highresFile = HighresFile(indexFile: try! IndexFile.openForReading(at: "Data/client_highres.dat"))
        let textureLoader = TextureLoader(portalFile: portalFile, highresFile: highresFile)
        textureLoader.quality = .high
        print(handles.count)
        
        for handle in handles {
            let listHandle = TextureListHandle(rawValue: handle)!
            let textureData = try! textureLoader.fetchTextureData(handle: listHandle)
            print(textureData)
        }
        
        let cellIndexFile = try! IndexFile.openForReading(at: "Data/client_cell_1.dat")
        let cellFile = CellFile(indexFile: cellIndexFile)

        var blocks = [[LandBlock]]()
        let maxRow = 17
        let maxCol = 17
        
        for row in 0..<maxRow {
            var array = [LandBlock]()
            
            for col in 0..<maxCol {
                array.append(try! cellFile.fetchLandBlock(handle: LandBlockHandle(row: row, col: col)))
            }
            
            blocks.append(array)
        }
        
        var string = ""
        let size = LandBlock.size
        
        for blockCol in 0..<maxCol {
            for col in 0..<size {
                for blockRow in 0..<maxRow {
                    let block = blocks[blockRow][blockCol]

                    for row in 0..<size {
                        string += hex(block.getHeightIndex(row: row, col: col))
                    }
                }
                
                string += "\n"
            }
        }
        
        print(string)
        
        for row in 0..<Int(UInt8.max) {
            for col in 0..<Int(UInt8.max) {
                let block = try! cellFile.fetchLandBlock(handle: LandBlockHandle(row: row, col: col))
                
                if block.hasStructures {
                    print(block)
                }
            }
        }
    }
    
    func testRandom() {
        let random = Random(seed: .cellDiagonal)

        let a = random.generate(for: GridPosition(row: 64, col: 64))
        let b = random.generate(for: GridPosition(row: 64, col: 65))

        print(random.generate(for: GridPosition(row: 64, col: 64)))
        print(random.generate(for: GridPosition(row: 64, col: 65)))

        XCTAssertEqualWithAccuracy(a, 0.852051935124223, accuracy: 0.000000000000001)
        XCTAssertEqualWithAccuracy(b, 0.472334243932817, accuracy: 0.000000000000001)
    }

    func testGridPosition() {
        let a = GridPosition(cellPosition: CellPosition(row: 64, col: 64), rowOffset: 1, colOffset: 1)
        let b = GridPosition(row: 65, col: 65)

        XCTAssertEqual(a, b)
    }

    func testWorldRegion() {
        let indexFile = try! IndexFile.openForReading(at: "Data/client_portal.dat")
        let portalFile = PortalFile(indexFile: indexFile)
        let worldRegionHandle = WorldRegionHandle(index: 0)
        let worldRegion = try! portalFile.fetchWorldRegion(handle: worldRegionHandle)
        print(worldRegion.hours)
        print(worldRegion.weekdays)
        print(worldRegion.months)
        print(worldRegion.unknown10)
        print(worldRegion.unknown11)
        print(worldRegion.unknown12)
    }

    static var allTests : [(String, (AsheronTests) -> () throws -> Void)] {
        return [
            ("testRandom", testRandom),
            ("testGridPosition", testGridPosition),
            ("testWorldRegion", testWorldRegion),
            //("testExample", testExample),
        ]
    }
}
