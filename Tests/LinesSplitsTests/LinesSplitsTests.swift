import XCTest
@testable import LinesSplits

final class LinesSplitsTests: XCTestCase {

    func testDataLinesEmpty() throws {
        var ls = Lines(fromData: Data())

        XCTAssertEqual(ls.next(), nil)
    }

    func testDataLinesStub() throws {
        var ls = Lines(fromData: "\n".data(using: .utf8)!)

        XCTAssertEqual(ls.next(), "")
        XCTAssertEqual(ls.next(), nil)
    }

    func testDataLinesOne() throws {
        var ls = Lines(fromData: "single line".data(using: .utf8)!)

        XCTAssertEqual(ls.next(), "single line")
        XCTAssertEqual(ls.next(), nil)
    }

    func testDataLinesTwo() throws {
        var ls = Lines(fromData: "line 1\nline 2".data(using: .utf8)!)

        XCTAssertEqual(ls.next(), "line 1")
        XCTAssertEqual(ls.next(), "line 2")
        XCTAssertEqual(ls.next(), nil)
    }

    func testDataLinesTwoPlus() throws {
        var ls = Lines(fromData: "line 1\nline 2\n".data(using: .utf8)!)

        XCTAssertEqual(ls.next(), "line 1")
        XCTAssertEqual(ls.next(), "line 2")
        XCTAssertEqual(ls.next(), nil)
    }
}
