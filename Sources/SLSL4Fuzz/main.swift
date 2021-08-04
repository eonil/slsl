import Foundation
import SLSL4

let iterCount = 1_000_000
let minCount = 1_000
let maxCount = 100_000

var a = SLSL4<Int>()
var b = [Int]()
for i in 0..<iterCount {
    if i < 1000 || i % 1000 == 0 { print("iteration: \(i), current value count: \(a.count)") }
    check()
    if a.count < minCount {
        a.append(contentsOf: Array(0..<minCount))
        b.append(contentsOf: Array(0..<minCount))
        check()
    }
    if a.count > maxCount {
        a = a[..<maxCount]
        b = Array(b[..<maxCount])
        check()
    }
    
    let start = Int.random(in: 0..<a.count)
    let end = Int.random(in: start..<a.count)
    let newCount = Int.random(in: 0..<10_000)
    a.replaceSubrange(start..<end, with: Array(0..<newCount))
    b.replaceSubrange(start..<end, with: Array(0..<newCount))
    check()
}

func check() {
    precondition(a.count == b.count)
    precondition(Array(a) == b)
    precondition(a.sum == b.reduce(0, +))
    precondition(a.count == b.count)
    if a.count > 0 {
        let start = Int.random(in: 0..<a.count)
        let end = Int.random(in: start..<a.count)
        precondition(a[start..<end].sum == b[start..<end].reduce(0, +))
    }
}
