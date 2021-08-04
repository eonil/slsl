import Foundation

func sumUsingAdd(_ n:Int) -> () -> Stat {
    return {
        let xs = Array(0..<n)
        let startTime = Date()
        var z = 0 as Int
        for x in xs { z = wrapSum(z,x) }
        let endTime = Date()
        precondition(xs.reduce(0, wrapSum) == z)
        print(z)
        return Stat(timeTaken: endTime.timeIntervalSince(startTime))
    }
}
func sumUsingReduce(_ n:Int) -> () -> Stat {
    return {
        let xs = Array(0..<n)
        let startTime = Date()
        let z = xs.reduce(0, wrapSum)
        let endTime = Date()
        precondition(z == Array(0..<n).reduce(0, wrapSum))
        print(z)
        return Stat(timeTaken: endTime.timeIntervalSince(startTime))
    }
}
func sumUsingSIMD(_ n:Int) -> () -> Stat {
    return { 
        precondition(n % 64 == 0)
        var vs = [SIMD64<Int>]()
        for start in stride(from: 0, to: n, by: 64) {
            let end = min(n, start + 64)
            let v = SIMD64<Int>(start..<end)
            vs.append(v)
        }
        let startTime = Date()
        var z = 0 as Int
        for v in vs { z = wrapSum(z, v.wrappedSum()) }
        let endTime = Date()
        precondition(z == Array(0..<n).reduce(0, wrapSum))
        print(z)
        return Stat(timeTaken: endTime.timeIntervalSince(startTime))
    }
}


func wrapSum(_ a:Int, _ b:Int) -> Int {
    return a.addingReportingOverflow(b).partialValue
}
