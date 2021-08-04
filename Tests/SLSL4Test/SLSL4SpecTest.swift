@testable import SLSL4
import XCTest

final class SLSL4SpecTest: XCTestCase {
    func testSliceZeroItems() {
        var a = SLSL4<Int>()
        a.append(contentsOf: [11,22,33,44,55])
        a.replaceSubrange(0..<5, with: [])
        XCTAssertEqual(Array(a[0..<0]), [])
    }
}
