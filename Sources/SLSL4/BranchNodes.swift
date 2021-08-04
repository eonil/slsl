
struct BranchNodes<T:BinaryInteger>:
    FastCollection,
    ExpressibleByArrayLiteral
{
    typealias Index = Int
    typealias Element = Node<T>
    typealias Iterator = Storage.Iterator
    
//    typealias Storage = FlatMemory<Node<T>>
    typealias Storage = [Node<T>]
//    typealias Storage = ContiguousArray<Node<T>>

    private var impl: Storage
    
    private(set) var totalCount = 0
    private(set) var totalSum = T.zero
    
    init() {
        impl = Storage()
    }
    
//    init(_ ns:Storage.SubSequence) {
//        assert(ns.count <= BranchNodes<T>.capacity)
//        impl = Storage(ns)
//        for n in ns {
//            totalCount += n.totalCount
//            totalSum += n.totalSum
//        }
//    }
    
    init(_ ns:ArraySlice<Node<T>>) {
        assert(ns.count <= BranchNodes<T>.capacity)
        impl = Storage(ns)
        for n in ns {
            totalCount += n.totalCount
            totalSum += n.totalSum
        }
    }

    init(arrayLiteral ns: Node<T>...) {
        assert(ns.count <= BranchNodes<T>.capacity)
        impl = Storage(ns[...])
        for n in ns {
            totalCount += n.totalCount
            totalSum += n.totalSum
        }
    }
    
    func makeIterator() -> Storage.Iterator {
        impl.makeIterator()
    }
    
    var startIndex: Int { 0 }
    var endIndex: Int { impl.count }
    
    subscript(_ i:Int) -> Node<T> {
        get {
            let n = impl.startIndex + i
            return impl[n]
        }
        set(x) {
            let n = impl.startIndex + i
            totalCount -= impl[n].totalCount
            totalSum -= impl[n].totalSum
            impl[n] = x
            totalCount += impl[n].totalCount
            totalSum += impl[n].totalSum
        }
    }
    
    subscript(_ r:Range<Int>) -> BranchNodes<T> {
        let q = r
        if q == indices { return self }
        let start = impl.startIndex + q.lowerBound
        let end = impl.startIndex + q.upperBound
        return BranchNodes(impl[start..<end])
    }
    
    mutating func replaceSubrange(_ subrange:Range<Int>, with newElements:ArraySlice<Node<T>>) {
        let q = subrange
        assert(count - q.count + newElements.count <= BranchNodes<T>.capacity)
        let start = impl.startIndex + q.lowerBound
        let end = impl.startIndex + q.upperBound
        let range = start..<end
        for n in impl[range] {
            totalCount -= n.totalCount
            totalSum -= n.totalSum
        }
        impl.replaceSubrange(range, with: newElements)
        for n in newElements {
            totalCount += n.totalCount
            totalSum += n.totalSum
        }
    }
}
