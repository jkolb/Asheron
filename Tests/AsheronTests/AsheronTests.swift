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
        
        let indexFile = try! IndexFile.openForReading(at: "/Users/jkolb/src/Dereth/Data/client_portal.dat")
        let textureHandles = try! indexFile.handles(matching: { UInt16($0 >> 16) == PortalKind.texture.rawValue })
        print(textureHandles)
        let portalFile = PortalFile(indexFile: indexFile)
        let texture = try! portalFile.fetchTexture(handle: PortalHandle(rawValue: textureHandles.first!)!)
        print(texture)
//        XCTAssertEqual(Asheron().text, "Hello, World!")
    }


    static var allTests : [(String, (AsheronTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
