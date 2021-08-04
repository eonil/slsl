enum Limit<T> {
    static var cacheLineSize: Int { 16 * 1024 }
}

#if DEBUG
extension Limit {
    static var bucketCapacity: Int { 4 }
}
#else
extension Limit {
    static var bucketCapacity: Int { cacheLineSize / MemoryLayout<T>.stride / 2 }
}
#endif

extension BranchNodes {
    static var capacity: Int {
        Limit<Node<T>>.bucketCapacity
    }
}
extension LeafValues {
    static var capacity: Int {
        Limit<T>.bucketCapacity
    }
}
