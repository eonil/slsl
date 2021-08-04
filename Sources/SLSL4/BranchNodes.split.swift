extension BranchNodes {
    /// Splits a node at `offset` into two nodes.
    mutating func split(at offset:Int) {
        let node = self[offset]
        switch node.content {
        case let .branch(b):
            assert(b.nodes.count == BranchNodes<T>.capacity)
            let pivot = b.nodes.count / 2
            let part1 = b.nodes[..<pivot]
            let part2 = b.nodes[pivot...]
            let node1 = Node(content: .branch(Branch(nodes: part1)))
            let node2 = Node(content: .branch(Branch(nodes: part2)))
            replaceSubrange(offset..<offset+1, with: [node1, node2])

        case let .leaf(f):
            assert(f.values.count == LeafValues<T>.capacity)
            let pivot = f.values.count / 2
            let part1 = f.values[..<pivot]
            let part2 = f.values[pivot...]
            let node1 = Node(content: .leaf(Leaf(values: part1)))
            let node2 = Node(content: .leaf(Leaf(values: part2)))
            replaceSubrange(offset..<offset+1, with: [node1, node2])
        }
    }
}
