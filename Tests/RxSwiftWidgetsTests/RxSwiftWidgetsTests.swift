import XCTest
@testable import RxSwiftWidgets

final class RxSwiftWidgetsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RxSwiftWidgets().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
