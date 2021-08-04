extension Node {
    /// Inserts a value at total-offset.
    /// - Space for insertion must be secured before calling this method.
    /// - This supports inserting at end-position to append a new value at the end.
    ///
    /// - Note:
    ///     This is a original form of insertion funciton and reference implementation of optimized version.
    ///     **Keep this separately with `insert(contentsOf:at:)` function.**
    ///
    mutating func insert(_ x:T, at totalOffset:Int) {
        assert(!isFull)
        
        switch content {
        case var .branch(b):
            assert(b.nodes.count < BranchNodes<T>.capacity)
            var (i, i1) = b.nodes.offsetPair(for: totalOffset)
            if b.nodes[i].isFull {
                /// Split target node into two pieces to secure a slot to insert within capacity limit.
                b.nodes.split(at: i)
                (i, i1) = b.nodes.offsetPair(for: totalOffset)
            }
            b.nodes[i].insert(x, at: i1)
            content = .branch(b)
            
        case var .leaf(f):
            assert(f.values.count < LeafValues<T>.capacity)
            f.values.insert(x, at: totalOffset)
            content = .leaf(f)
        }
    }
}

extension Node {
    /// Inserts multiple values within leaf node capacity and returns remained values.
    /// - This works exactly same with single insertion function except this fills leaf node.
    /// - Changes in node topology works exactly same with single insertion function.
    ///   Therefore you don't need to worry about unexpected topological changes.
    /// - Returns: Count of inserted elements. (consumed count)
    mutating func insertAsManyAsPossible(contentsOf xs:ArraySlice<T>, at totalOffset:Int) -> Int {
        assert(!isFull)
        
        switch content {
        case var .branch(b):
            var insertOffset = totalOffset
            var insertSource = xs[...]
            var totalConsumedCount = 0
            
            AGAIN:
            do {
                assert(b.nodes.count < BranchNodes<T>.capacity)
                var (i, i1) = b.nodes.offsetPair(for: insertOffset)
                if b.nodes[i].isFull {
                    /// Split target node into two pieces to secure a slot to insert within capacity limit.
                    b.nodes.split(at: i)
                    (i, i1) = b.nodes.offsetPair(for: insertOffset)
                }
                let consumedCount = b.nodes[i].insertAsManyAsPossible(contentsOf: insertSource, at: i1)
                assert(consumedCount > 0)
                totalConsumedCount += consumedCount
                content = .branch(b)
                
                let isRemained = consumedCount < insertSource.count
                let canInsertMore = b.nodes.count < BranchNodes<T>.capacity
                
                if isRemained, canInsertMore {
                    insertSource = insertSource.dropFirst(consumedCount)
                    insertOffset = insertOffset + consumedCount
                    continue AGAIN
                }
                assert(insertSource.count > 0)
            }
            return totalConsumedCount
            
        case var .leaf(f):
            assert(f.values.count < LeafValues<T>.capacity)
            let insertCount = min(LeafValues<T>.capacity - f.values.count, xs.count)
            let insertSourceStart = xs.startIndex
            let insertSourceEnd = xs.index(xs.startIndex, offsetBy: insertCount)
            let insertSourceRange = insertSourceStart..<insertSourceEnd
            let insertSource = xs[insertSourceRange]
            assert(insertCount > 0)
            f.values.insert(contentsOf: insertSource, at: totalOffset)
            content = .leaf(f)
            assert(xs.startIndex == insertSourceRange.lowerBound)
            assert(insertSourceRange.upperBound <= xs.endIndex)
            return insertCount
        }
    }
}
