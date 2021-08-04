import SLSL4
import XCTest

final class SLSL4OffsetTranslationTest: XCTestCase {
    func testSegmentedOffsetFromContinuousOffset() {
        let x = SLSL4<Int>([10,20,100,200])
        XCTAssertEqual(x.sum, [10,20,100,200].reduce(0, +))
        
        let a = x.continuousOffset(at: SLSL4SegmentedOffset(segmentOffset: 2, inSegmentPoint: 0))
        XCTAssertEqual(a, 10 + 20)
        
        let b = x.continuousOffset(at: SLSL4SegmentedOffset(segmentOffset: 2, inSegmentPoint: 30))
        XCTAssertEqual(b, 10 + 20 + 30)
        
        let c = x.continuousOffset(at: SLSL4SegmentedOffset(segmentOffset: 0, inSegmentPoint: 0))
        XCTAssertEqual(c, 0)
        
        let d = x.continuousOffset(at: SLSL4SegmentedOffset(segmentOffset: 3, inSegmentPoint: 200))
        XCTAssertEqual(d, 10 + 20 + 100 + 200)
    }
    func testContinuousOffsetFromSegmentedOffset() {
        let x = SLSL4<Int>([10,20,100,200])
        XCTAssertEqual(x.sum, [10,20,100,200].reduce(0, +))
        
        let a = x.segmentedOffset(at: 10 + 20)
        XCTAssertEqual(a, SLSL4SegmentedOffset(segmentOffset: 2, inSegmentPoint: 0))
        
        let b = x.segmentedOffset(at: 10 + 20 + 30)
        XCTAssertEqual(b, SLSL4SegmentedOffset(segmentOffset: 2, inSegmentPoint: 30))
        
        let c = x.segmentedOffset(at: 0)
        XCTAssertEqual(c, SLSL4SegmentedOffset(segmentOffset: 0, inSegmentPoint: 0))
        
        let d = x.segmentedOffset(at: 10 + 20 + 100 + 200)
        XCTAssertEqual(d, SLSL4SegmentedOffset(segmentOffset: 3, inSegmentPoint: 200))

    }
}
