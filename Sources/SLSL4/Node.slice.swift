extension Node {
    @inline(__always)
    func slice<R:RangeExpression>(in range:R) -> Node where R.Bound == Int {
        let q = range.relative(to: 0..<totalCount)
        switch content {
        case let .branch(b):
            let (start1, start2) = b.nodes.offsetPair(for: q.lowerBound)
            let (end1, end2) = b.nodes.offsetPair(for: q.upperBound)
            if start1 == end1 {
                let n = b.nodes[start1]
                return n.slice(in: start2..<end2)
            }
            else {
                /// `remove(...)` is expensive. Avoid it as much as possible.
                var ns = b.nodes[start1...end1]
//                ns[ns.startIndex] = ns[ns.startIndex].slice(in: start2...)
//                ns[ns.endIndex-1] = ns[ns.endIndex-1].slice(in: ..<end2)
                ns[ns.startIndex].remove(in: ..<start2)
                ns[ns.endIndex-1].remove(in: end2...)
                return Node(content: .branch(Branch(nodes: ns)))
            }
            
        case let .leaf(f):
            let xs = f.values[range]
            return Node(content: .leaf(Leaf(values: xs)))
        }
    }
    
    @inline(__always)
    func value(at totalOffset:Int) -> T {
        switch content {
        case let .branch(b):
            let (i, i1) = b.nodes.offsetPair(for: totalOffset)
            return b.nodes[i].value(at: i1)
            
        case let .leaf(f):
            return f.values[totalOffset]
        }
    }
    
    @inline(__always)
    mutating func setValue(_ x:T, at totalOffset:Int) {
        switch content {
        case var .branch(b):
            let (i, i1) = b.nodes.offsetPair(for: totalOffset)
            b.nodes[i].setValue(x, at: i1)
            content = .branch(b)
            
        case var .leaf(f):
            f.values[totalOffset] = x
            content = .leaf(f)
        }
    }
}
