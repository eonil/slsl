@testable import SLSL4
import XCTest

final class SLSL4Test: XCTestCase {
    func test() {
        let x = SLSL4<Int>([4,6,8])
        XCTAssertEqual(Array(x), [4,6,8])
    }
    func testBalancing() {
        let N = 200
        var x = SLSL4<Int>()
        for i in 0..<N {
            x.append(i)
            print("count: \(x.count), max depth: \(x.root.countMaxDepth())")
            XCTAssertEqual(Array(x), Array(0...i))
            XCTAssertEqual(x.sum, (0...i).reduce(0, +))
            if i > LeafValues<Int>.capacity {
                XCTAssertLessThan(x.root.countMaxDepth(), x.count / LeafValues<Int>.capacity + 2)
            }
        }
        XCTAssertEqual(Array(x), Array(0..<N))
        
        x.removeSubrange(50..<120)
        print(x.root.countMaxDepth())
        XCTAssertLessThan(x.root.countMaxDepth(), x.count / LeafValues<Int>.capacity + 2)
        
        x.removeSubrange(10..<120)
        print(x.root.countMaxDepth())
        XCTAssertEqual(x.count, 20)
        XCTAssertEqual(x.root.countMaxDepth(), 5)
            
        x.removeSubrange(1..<19)
        print(x.root.countMaxDepth())
        XCTAssertEqual(x.count, 2)
        XCTAssertEqual(x.root.countMaxDepth(), 4)
        
        x.removeSubrange(1..<2)
        print(x.root.countMaxDepth())
        XCTAssertEqual(x.count, 1)
        XCTAssertEqual(x.root.countMaxDepth(), 1)
        
        x.removeAll()
        print(x.root.countMaxDepth())
        XCTAssertEqual(x.root.countMaxDepth(), 1)
    }
    func testInsertsAndRemoves() {
        var x = SLSL4<Int>()
        x.append(contentsOf: [11,22,33,44,55,66,77,88,99])
        XCTAssertEqual(Array(x), [11,22,33,44,55,66,77,88,99])
        XCTAssertEqual(x.sum, [11,22,33,44,55,66,77,88,99].reduce(0, +))
        
        x.remove(at: 2)
        XCTAssertEqual(Array(x), [11,22,44,55,66,77,88,99])
        XCTAssertEqual(x.sum, [11,22,44,55,66,77,88,99].reduce(0, +))
        
        x.removeSubrange(2..<6)
        XCTAssertEqual(Array(x), [11,22,88,99])
        XCTAssertEqual(x.sum, [11,22,88,99].reduce(0, +))
        
        x.insert(contentsOf: [4,5,6,7], at: 1)
        XCTAssertEqual(Array(x), [11,4,5,6,7,22,88,99])
        XCTAssertEqual(x.sum, [11,4,5,6,7,22,88,99].reduce(0, +))
        
        XCTAssertEqual(Array(x[0..<4]), [11,4,5,6])
        XCTAssertEqual(x[0..<4].sum, [11,4,5,6].reduce(0, +))
        
        XCTAssertEqual(Array(x[3..<6]), [6,7,22])
        XCTAssertEqual(x[3..<6].sum, [6,7,22].reduce(0, +))
    }
}
