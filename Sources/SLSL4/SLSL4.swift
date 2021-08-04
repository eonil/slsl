public struct SLSL4<T:BinaryInteger>:
    SLSL4Protocol,
    RandomAccessCollection,
    MutableCollection,
    RangeReplaceableCollection,
    ExpressibleByArrayLiteral
{
    private(set) var root: Root<T>
    
    public typealias SubSequence = SLSL4
    public typealias Iterator = SLSL4Iterator<T>
    
    public init() {
        root = Root()
    }
    private init(root x:Root<T>) {
        root = x
    }
    public init(arrayLiteral elements: T...) {
        root = Root()
        append(contentsOf: elements)
    }
    public init<C>(_ xs:C) where C:Collection, C.Element == T {
        root = Root()
        append(contentsOf: Array(xs))
    }
    
    public func makeIterator() -> SLSL4Iterator<T> {
        SLSL4Iterator(impl: root.makeIterator())
    }
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { root.totalCount }
    
    public subscript(_ i:Int) -> T {
        get { root.value(at: i) }
        set(x) { root.setValue(x, at: i) }
    }
    public subscript(_ r: Range<Int>) -> SLSL4<T> {
        SLSL4(root: root.slice(in: r))
    }

    public mutating func replaceSubrange(_ subrange:Range<Index>, with newElements:[T]) {
        assert(subrange.relative(to: self).startIndex >= startIndex)
        assert(subrange.relative(to: self).endIndex <= endIndex)
        root.replace(in: subrange, with: Array(newElements)[...])
    }
}

public extension SLSL4 {
//    mutating func insert<C>(contentsOf newElements: C, at i: Int) where C : Collection, Self.Element == C.Element {
//        replaceSubrange(i..<i, with: newElements)
//    }
//    mutating func append<S>(contentsOf newElements: S) where S : Sequence, Self.Element == S.Element {
//        assertionFailure("Do not use this overload (`Sequence` based) for better performance. Use `Collection` based overload.")
//        replaceSubrange(endIndex..<endIndex, with: Array(newElements))
//    }
    mutating func append<C>(contentsOf newElements: C) where C : Collection, Self.Element == C.Element {
        replaceSubrange(endIndex..<endIndex, with: newElements)
    }
//    mutating func removeSubrange<R>(_ bounds: R) where R : RangeExpression, Self.Index == R.Bound {
//        replaceSubrange(bounds, with: EmptyCollection())
//    }
}

public extension SLSL4 {
    var sum: T {
        root.totalSum
    }
    
    /// Finds offset in continuous space from offset in segmented space..
    func continuousOffset(at segmentedOffset:SLSL4SegmentedOffset<T>) -> T {
        root.continuousOffset(at: (segmentedOffset.segmentOffset, segmentedOffset.inSegmentPoint))
    }
    
    func continuousOffset(at segmentOffset:Int) -> T {
        continuousOffset(at: SLSL4SegmentedOffset(segmentOffset: segmentOffset, inSegmentPoint: .zero))
    }
    
    /// Finds offset in segmented space from offset in continuous space.
    func segmentedOffset(at continuousOffset:T) -> SLSL4SegmentedOffset<T> {
        assert(continuousOffset >= 0)
        assert(continuousOffset <= root.totalSum)
        let (i, k) = root.segmentedOffset(at: continuousOffset)
        return SLSL4SegmentedOffset(segmentOffset: i, inSegmentPoint: k)
    }
}

public struct SLSL4SegmentedOffset<T:BinaryInteger>: Hashable {
    public var segmentOffset: Int
    public var inSegmentPoint: T
    public init(segmentOffset i:Int, inSegmentPoint p: T) {
        segmentOffset = i
        inSegmentPoint = p
    }
}





public struct SLSL4Iterator<T:BinaryInteger>: IteratorProtocol {
    var impl: NodeDFSIterator<T>
    public typealias Element = T
    public mutating func next() -> Element? {
        impl.next()
    }
}
