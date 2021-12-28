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

    func testDataLinesThree() throws {
        var ls = Lines(fromData: "line 1\nline 2\nline 3".data(using: .utf8)!)

        XCTAssertEqual(ls.next(), "line 1")
        XCTAssertEqual(ls.next(), "line 2")
        XCTAssertEqual(ls.next(), "line 3")
        XCTAssertEqual(ls.next(), nil)
    }

    func testDataLinesTwoFileBuf4() throws {
        var ls = try Lines(fromFile: "Tests/LinesSplitsTests/test-data-2-lines.txt",
                           chunkSize:4)

        XCTAssertEqual(ls.next(), "line 1")
        XCTAssertEqual(ls.next(), "line 2")
        XCTAssertEqual(ls.next(), nil)
    }

    func testDataLinesTwoFileBuf1() throws {
        var ls = try Lines(fromFile: "Tests/LinesSplitsTests/test-data-2-lines.txt",
                           chunkSize:1)

        XCTAssertEqual(ls.next(), "line 1")
        XCTAssertEqual(ls.next(), "line 2")
        XCTAssertEqual(ls.next(), nil)
    }

    func testDataLinesTwoFileBuf6() throws {
        var ls = try Lines(fromFile: "Tests/LinesSplitsTests/test-data-2-lines.txt",
                           chunkSize:6)

        XCTAssertEqual(ls.next(), "line 1")
        XCTAssertEqual(ls.next(), "line 2")
        XCTAssertEqual(ls.next(), nil)
    }

    func testDataLinesTwoFileBuf7() throws {
        var ls = try Lines(fromFile: "Tests/LinesSplitsTests/test-data-2-lines.txt",
                           chunkSize:7)

        XCTAssertEqual(ls.next(), "line 1")
        XCTAssertEqual(ls.next(), "line 2")
        XCTAssertEqual(ls.next(), nil)
    }

    func testDataLinesTwoFileBuf8() throws {
        var ls = try Lines(fromFile: "Tests/LinesSplitsTests/test-data-2-lines.txt",
                           chunkSize:8)

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
