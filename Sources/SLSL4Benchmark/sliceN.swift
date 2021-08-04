import Foundation
import SLSL4

func sliceN(count:Int, _ N:Int) -> () -> Stat {
    typealias I = Int32
    return {
        precondition(N >= 80)
        let U = N / 80
        print("- Each dot is \(U) sessions.")
        print(String(repeating: ".", count: 80))
        
        var xs = SLSL4Int32()
        for _ in 0..<(count / N) {
            for i in 0..<N {
                xs.append(Int32(i))
            }
        }
        var z = 0 as I
        let q = Int32.random(in: 1..<2)
        
        let startTime = Date()
        for _ in 0..<80 {
            for _ in 0..<U {
                for start in stride(from: 0, to: count, by: N) {
                    let end = min(start + N, count)
                    let subxs = xs[start..<end]
                    for x in subxs {
                        z += x + q
                    }
                    
//                    for i in start..<end {
//                        z += xs[i]
//                    }
                }
            }
            print("|", terminator: "")
            fflush(stdout)
        }
        let endTime = Date()
        print(z)
        return Stat(timeTaken: endTime.timeIntervalSince(startTime))
    }
}
