/// A root container of B-Tree.
/// - Only root node can increase/decrease the depth.
struct Root<T:BinaryInteger> {
    private var node = Node<T>()
}

private let useBulkOptimizations = true

extension Root {
    var totalCount: Int { node.totalCount }
    var totalSum: T { node.totalSum }
    
    func makeIterator() -> NodeDFSIterator<T> {
        NodeDFSIterator(reversedStack: [node], leafIterator: nil)
    }
    
    func slice<R:RangeExpression>(in range:R) -> Root where R.Bound == Int {
        Root(node: node.slice(in: range))
    }
    
    func value(at totalOffset:Int) -> T {
        node.value(at: totalOffset)
    }
    
    mutating func setValue(_ x:T, at totalOffset:Int) {
        node.setValue(x, at: totalOffset)
    }
    
    mutating func replace(in r:Range<Int>, with newElements:ArraySlice<T>) {
        let q = r.relative(to: 0..<totalCount)
        
        /// Remove.
        remove(in: q)
        
        /// Insert.
        if useBulkOptimizations {
            var insertSource = newElements
            var insertOffset = q.lowerBound
            while !insertSource.isEmpty {
                let oldTotalCount = totalCount
                let consumedCount = insertAsManyAsPossible(contentsOf: insertSource, at: insertOffset)
                assert(totalCount == oldTotalCount + consumedCount)
                insertOffset += consumedCount
                insertSource = insertSource.dropFirst(consumedCount)
            }
        }
        else {
            for (i,x) in newElements.enumerated() {
                insertOnce(x, at: q.lowerBound + i)
            }
        }
    }
    
    /// Inserts a value with consideration of increasing depth.
    /// - This is a reference implementation of insertion.
    /// - This need to be preserved to illustrate how to handle depth increment on root.
    mutating func insertOnce(_ x:T, at totalOffset:Int) {
        switch node.content {
        case let .branch(b):
            /// This determinant does not consider grand child's filling state.
            /// Therefore may wates single slot of memory, but I think it's worth to pay
            /// to avoid unnecessary look-up.
            if b.nodes.count == BranchNodes<T>.capacity {
                /// Increase depth.
                /// Become a new parent node and perform insertion there.
                node = Node(content: .branch(Branch(nodes: [node])))
            }
            node.insert(x, at: totalOffset)

        case let .leaf(f):
            if f.values.count == LeafValues<T>.capacity {
                /// Increase depth.
                /// Become a new parent node and perform insertion there.
                node = Node(content: .branch(Branch(nodes: [node])))
            }
            node.insert(x, at: totalOffset)
        }
    }
    
    mutating func insertAsManyAsPossible(contentsOf xs:ArraySlice<T>, at totalOffset:Int) -> Int {
        switch node.content {
        case let .branch(b):
            /// This determinant does not consider grand child's filling state.
            /// Therefore may wates single slot of memory, but I think it's worth to pay
            /// to avoid unnecessary look-up.
            if b.nodes.count == BranchNodes<T>.capacity {
                /// Increase depth.
                /// Become a new parent node and perform insertion there.
                node = Node(content: .branch(Branch(nodes: [node])))
            }
            return node.insertAsManyAsPossible(contentsOf: xs, at: totalOffset)

        case let .leaf(f):
            if f.values.count == LeafValues<T>.capacity {
                /// Increase depth.
                /// Become a new parent node and perform insertion there.
                node = Node(content: .branch(Branch(nodes: [node])))
            }
            return node.insertAsManyAsPossible(contentsOf: xs, at: totalOffset)
        }
    }
    
    /// Removes a value with consideration of decreasing depth.
    mutating func remove<R:RangeExpression>(in totalRange:R) where R.Bound == Int {
        let q = totalRange.relative(to: 0..<totalCount)
        guard !q.isEmpty else { return }
        node.remove(in: totalRange)
        
        AGAIN:
        do {
            switch node.content {
            case let .branch(b):
                if b.nodes.count == 1 {
                    /// Decrease depth if possible.
                    node = b.nodes[0]
                    continue AGAIN
                }
                
            case .leaf:
                break
            }
        }
    }
}

extension Root {
    func continuousOffset(at segmentedOffset: (Int,T)) -> T {
        node.continuousOffset(at: segmentedOffset)
    }
    func segmentedOffset(at continuousOffset: T) -> (Int,T) {
        node.segmentedOffset(at: continuousOffset)
    }
}

private extension Node {
    func continuousOffset(at segmentedOffset: (Int,T)) -> T {
        let start = slice(in: 0..<segmentedOffset.0).totalSum
        return start + segmentedOffset.1
    }
    func segmentedOffset(at continuousOffset: T) -> (Int,T) {
        assert(continuousOffset >= 0)
        assert(continuousOffset <= totalSum)
        
        if continuousOffset == 0 { return (0, .zero) }
        /// `.zero` case has been handled at first test.
        if continuousOffset == totalSum { return (totalCount-1, slice(in: totalCount-1..<totalCount).totalSum) }
        
        switch content {
        case let .branch(b):
            var accumSum = T.zero
            var accumCount = 0
            for x in b.nodes {
                let start = accumSum
                let end = start + x.totalSum
                let range = start..<end
                if range.contains(continuousOffset) {
                    let (k,k1) = x.segmentedOffset(at: continuousOffset - start)
                    return (accumCount + k, k1)
                }
                accumSum = end
                accumCount += x.totalCount
            }
            assert(accumSum == totalSum)
            fatalError(ErrorMessage.outOfRangeOffset)
            
        case let .leaf(f):
            assert(f.values.count > 0)
            var accumSum = T.zero
            for (i,x) in f.values.enumerated() {
                let start = accumSum
                let end = start + x
                let range = start..<end
                if range.contains(continuousOffset) {
                    return (i, continuousOffset - start)
                }
                accumSum = end
            }
            assert(accumSum == totalSum)
            fatalError(ErrorMessage.outOfRangeOffset)
        }
    }
}

#if DEBUG
extension Root {
    func countMaxDepth() -> Int {
        node.countMaxDepth()
    }
}
private extension Node {
    func countMaxDepth() -> Int {
        switch content {
        case let .branch(b):
            return 1 + (b.nodes.map({ n in n.countMaxDepth() }).max() ?? 0)
        case .leaf:
            return 1
        }
    }
}
#endif
