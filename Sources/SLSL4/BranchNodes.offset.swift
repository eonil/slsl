extension BranchNodes {
    func offsetPair(for totalOffset:Int) -> (nodeOffset:Int, inNodeOffset:Int) {
        assert(totalOffset >= 0)
        assert(totalOffset <= totalCount)
        
        if totalOffset == 0 { return (0, 0) }
        if totalOffset == totalCount {
            /// Empty collection case has been excluded  by zero-check.
            return (count-1, last!.totalCount)
        }
        
        var accumCount = 0
        for i in indices {
            let n = self[i]
            let start = accumCount
            let end = start + n.totalCount
            let range = start..<end
            if range.contains(totalOffset) {
                return (i, totalOffset - start)
            }
            accumCount = end
        }
        fatalError(ErrorMessage.outOfRangeOffset)
    }
}
