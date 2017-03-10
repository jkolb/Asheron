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
        
        let fileManager = IndexFileManager()
        let indexFile = try! fileManager.open(path: "/Users/jkolb/src/Dereth/Data/client_portal.dat")
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
