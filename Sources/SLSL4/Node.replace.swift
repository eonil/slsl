//extension Node {
//    mutating func replace<R:RangeExpression,C:Collection>(in r:R, with xs:C) where R.Bound == Int, C.Element == T {
//        let q = r.relative(to: 0..<totalCount)
//        remove(in: q)
//        for (i,x) in xs.enumerated() {
//            insert(x, at: q.lowerBound + i)
//        }
//    }
//}
