extension Node {
    mutating func remove(at totalOffset:Int) {
        remove(in: totalOffset...totalOffset)
    }
    
    mutating func remove<R:RangeExpression>(in totalRange:R) where R.Bound == Int {
        let q = totalRange.relative(to: 0..<totalCount)
        switch content {
        case var .branch(b):
            let (start1, start2) = b.nodes.offsetPair(for: q.lowerBound)
            let (end1, end2) = b.nodes.offsetPair(for: q.upperBound)
            if start1 == end1 {
                b.nodes[start1].remove(in: start2..<end2)
                if b.nodes[start1].isEmpty {
                    b.nodes.remove(at: start1)
                }
                else {
                    b.nodes.mergeAllConsecutivePairsIfPossible(around: start1)
                }
            }
            else {
                var firstNode = b.nodes[start1]
                var lastNode = b.nodes[end1]
                firstNode.remove(in: start2...)
                lastNode.remove(in: ..<end2)
                var replacementNodes = [Node]()
                if !firstNode.isEmpty { replacementNodes.append(firstNode) }
                if !lastNode.isEmpty { replacementNodes.append(lastNode) }
                b.nodes.replaceSubrange(start1..<end1+1, with: replacementNodes)
                /// Non-root cannot decrease depth.
                /// Keep an empty leaf at least.
                /// Root will decrease depth if it detect it decrease depth.
                if b.nodes.count == 0 {
                    b.nodes.append(Node(content: .leaf(Leaf())))
                }
                /// Please note that nodes in range `start1..<end1` has been deleted.
                /// Now we have nodes around `start1...(start1+replacementNodes.count)`.
                b.nodes.mergeAllConsecutivePairsIfPossible(around: start1..<(start1+replacementNodes.count))
            }
            if !b.nodes.isEmpty, b.nodes.canMerge(in: 0..<b.nodes.count) {
                b.nodes.merge(in: 0..<b.nodes.count)
            }
            content = .branch(b)
            
        case var .leaf(f):
            f.values.removeSubrange(q)
            content = .leaf(f)
        }
    }
}
