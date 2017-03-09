import XCTest
@testable import Asheron

class AsheronTests: XCTestCase {
    func testExample() {
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
