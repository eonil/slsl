extension BranchNodes {
    
    /// Returns `true` if all contained nodes can be merged into one within capacity limit.
    func canMerge(in range:Range<Int>) -> Bool {
        assert(!isEmpty)
        switch first!.content {
        case .branch:
            var tc = 0
            for n in self[range] { tc += n.content.branch!.nodes.count }
            return tc <= BranchNodes<T>.capacity
            
        case .leaf:
            var tc = 0
            for n in self[range] { tc += n.content.leaf!.values.count }
            return tc <= LeafValues<T>.capacity
        }
    }
    
    /// Merges all contained nodes into a new node-content and returns the newly created node-content.
    /// - You can replace container node content with returning content.
    func merged(in range:Range<Int>) -> NodeContent<T> {
        assert(!isEmpty)
        switch first!.content {
        case .branch:
            var newNodes = BranchNodes<T>()
            for n in self[range] { newNodes.append(contentsOf: n.content.branch!.nodes) }
            return .branch(Branch(nodes: newNodes))
            
        case .leaf:
            var newValues = LeafValues<T>()
            for n in self[range] { newValues.append(contentsOf: n.content.leaf!.values) }
            return .leaf(Leaf(values: newValues))
        }
    }
    
    /// Makes a mergeed node-content by calling `mergeed(in:)`,
    /// and replaces designated range with a new node with the mergeed content.
    /// - You must check mergeability by calling `canCompact(in:)`.
    mutating func merge(in range:Range<Int>) {
        let content = merged(in: range)
        let newNode = Node<T>(content: content)
        replaceSubrange(range, with: [newNode])
    }
    
    /// Performs `merge(in:)` for all of each consecutive pairs in this collection.
    /// - This checks mergeability automatically.
    mutating func mergeAllConsecutivePairsIfPossible<R:RangeExpression>(in range:R) where R.Bound == Int {
        let q = range.relative(to: self)
        for i in q.dropLast().reversed() {
            let i1 = i + 1
            if canMerge(in: i..<i1+1) {
                merge(in: i..<i1+1)
            }
        }
    }
    
    mutating func mergeAllConsecutivePairsIfPossible<R:RangeExpression>(around range:R) where R.Bound == Int {
        let q = range.relative(to: self)
        let start = Swift.max(0, q.lowerBound - 1)
        let end = Swift.min(count, q.upperBound + 1)
        mergeAllConsecutivePairsIfPossible(in: start..<end)
    }
    
    mutating func mergeAllConsecutivePairsIfPossible(around offset:Int) {
        mergeAllConsecutivePairsIfPossible(around: offset...offset)
    }
}
