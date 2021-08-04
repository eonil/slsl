extension Node {
    /// Lazy sequence of all contained values.
    var values: NodeDFSValueSequence<T> {
        NodeDFSValueSequence(node: self)
    }
}

struct NodeDFSValueSequence<T:BinaryInteger>: Sequence {
    var node: Node<T>
    func makeIterator() -> NodeDFSIterator<T> {
        NodeDFSIterator<T>(reversedStack: [node], leafIterator: nil)
    }
}

struct NodeDFSIterator<T:BinaryInteger>: IteratorProtocol {
    var reversedStack = [Node<T>]()
    var leafIterator = LeafValues<T>.Iterator?.none
    mutating func next() -> T? {
        AGAIN:
        do {
            if let x = leafIterator?.next() { return x }
            leafIterator = nil
            if reversedStack.isEmpty { return nil }
            let n = reversedStack.removeLast()
            switch n.content {
            case let .branch(b):
                reversedStack.append(contentsOf: b.nodes.reversed())
                continue AGAIN
            case let .leaf(f):
                leafIterator = f.values.makeIterator()
                continue AGAIN
            }
        }
    }
}
