import XCTest
@testable import Asheron

class AsheronTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Asheron().text, "Hello, World!")
    }


    static var allTests : [(String, (AsheronTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
