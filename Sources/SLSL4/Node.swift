struct Node<T:BinaryInteger> {
    var content = NodeContent<T>.leaf(Leaf())
    
    init(content x: NodeContent<T> = .leaf(Leaf())) {
        content = x
    }
    
    var totalCount: Int {
        switch content {
        case let .branch(b): return b.nodes.totalCount
        case let .leaf(f): return f.values.count
        }
    }
    
    var totalSum: T {
        switch content {
        case let .branch(b): return b.nodes.totalSum
        case let .leaf(f): return f.values.sum
        }
    }
    
    var isEmpty: Bool {
        totalCount == 0
    }
    
    var isFull: Bool {
        switch content {
        case let .branch(b): return b.nodes.count == BranchNodes<T>.capacity
        case let .leaf(f): return f.values.count == LeafValues<T>.capacity
        }
    }
}

@frozen
enum NodeContent<T:BinaryInteger> {
    case branch(Branch<T>)
    case leaf(Leaf<T>)
    
    var branch: Branch<T>? {
        if case let .branch(b) = self { return b }
        return nil
    }
    var leaf: Leaf<T>? {
        if case let .leaf(f) = self { return f }
        return nil
    }
    var isBranch: Bool {
        if case .branch = self { return true }
        return false
    }
    var isLeaf: Bool {
        if case .leaf = self { return true }
        return false
    }
}

struct Branch<T:BinaryInteger> {
    var nodes = BranchNodes<T>()
}

struct Leaf<T:BinaryInteger> {
    var values = LeafValues<T>()
}
