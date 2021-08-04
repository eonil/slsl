import SLSL4
import XCTest

final class SLSL4RegressionTest: XCTestCase {
    func test1() {
        let a = SLSL4(repeating: 1, count: 8)
        let b = a.segmentedOffset(at: 8)
        XCTAssertEqual(b.segmentOffset, 7)
        XCTAssertEqual(b.inSegmentPoint, 1)
    }
    func test2() {
        let a = SLSL4(repeating: 1, count: 9)
        let b = a.segmentedOffset(at: 9)
        XCTAssertEqual(b.segmentOffset, 8)
        XCTAssertEqual(b.inSegmentPoint, 1)
    }
    func test3() {
        do {
            let a = SLSL4([0])
            let b = a.segmentedOffset(at: 0)
            XCTAssertEqual(b.segmentOffset, 0)
            XCTAssertEqual(b.inSegmentPoint, 0)
        }
        do {
            let a = SLSL4([1])
            let b = a.segmentedOffset(at: 0)
            XCTAssertEqual(b.segmentOffset, 0)
            XCTAssertEqual(b.inSegmentPoint, 0)
            let c = a.segmentedOffset(at: 1)
            XCTAssertEqual(c.segmentOffset, 0)
            XCTAssertEqual(c.inSegmentPoint, 1)
        }
    }
}
