
struct LeafValues<T:BinaryInteger>:
    FastCollection,
    ExpressibleByArrayLiteral
{
    typealias Element = T
    typealias Iterator = Storage.Iterator

//    typealias Storage = FlatMemory<T>
    typealias Storage = [T]
//    typealias Storage = ContiguousArray<T>
    
    private var impl: Storage
    
    private(set) var sum = T.zero
    
    init() {
        impl = Storage()
    }
    
//    private init(_ xs:Storage.SubSequence) {
//        impl = Storage(xs)
//        sum = xs.reduce(0, +)
//    }
    
    init(_ xs:ArraySlice<T>) {
        impl = Storage(xs)
        sum = xs.reduce(.zero, +)
    }

    init(arrayLiteral xs: T...) {
        assert(xs.count <= LeafValues<T>.capacity)
        impl = Storage(xs[...])
        sum = xs.reduce(.zero, +)
    }
    
    func makeIterator() -> Storage.Iterator {
        impl.makeIterator()
    }
    
    var startIndex: Int { 0 }
    var endIndex: Int { impl.count }
    
    subscript(_ i:Int) -> T {
        get {
            let n = impl.startIndex + i
            return impl[n]
        }
        set(x) {
            let n = impl.startIndex + i
            sum -= impl[n]
            impl[n] = x
            sum += impl[n]
        }
    }
    
    subscript(_ r:Range<Int>) -> LeafValues<T> {
        if r == indices { return self }
        let start = impl.startIndex + r.lowerBound
        let end = impl.startIndex + r.upperBound
        let range = start..<end
        return LeafValues(impl[range])
    }

    mutating func replaceSubrange(_ subrange:Range<Int>, with newElements:ArraySlice<T>) {
        let q = subrange
        assert(count - q.count + newElements.count <= LeafValues<T>.capacity)
        let start = impl.startIndex + q.lowerBound
        let end = impl.startIndex + q.upperBound
        let range = start..<end
        sum -= impl[range].reduce(0, +)
        impl.replaceSubrange(range, with: newElements)
        sum += newElements.reduce(0, +)
    }
}

