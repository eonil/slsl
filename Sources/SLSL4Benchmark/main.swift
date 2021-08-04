import Foundation


//run("Load 1K Items", loadN(1_000))
//run("Load 100K Items", loadN(100_000))
//run("Load 1M Items", loadN(1_000_000))

//let sumN = 100_000_000
//run("Sum 100M using add.", sumUsingAdd(sumN))
//run("Sum 100M using reduce.", sumUsingReduce(sumN))
//run("Sum 100M using SIMD", sumUsingSIMD(sumN))

let n = Int.random(in: 100..<101)
run("Slice 100K items 10K times", sliceN(count: n * 1000, 100))

