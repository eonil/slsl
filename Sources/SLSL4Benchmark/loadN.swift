import Foundation
import SLSL4

func loadN(_ N:Int) -> () -> Stat {
    return {
        precondition(N >= 80)
        let U = N / 80
        print("- Each dot is \(U) items.")
        print(String(repeating: ".", count: 80))
        
        var x = SLSL4<Int>()
        var accumulatedSumTable = [Int]()
        do {
            var n = 0
            for i in 0..<N {
                n += i
                accumulatedSumTable.append(n)
            }
        }
        let startTime = Date()
        for i in 0..<80 {
            let start = i * U
            let end = start + U
            x.append(contentsOf: Array(start..<end))
            print("|", terminator: "")
            fflush(stdout)
        }
        let endTime = Date()
        return Stat(timeTaken: endTime.timeIntervalSince(startTime))
    }
}
