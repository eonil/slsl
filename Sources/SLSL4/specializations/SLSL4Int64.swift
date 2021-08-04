public struct SLSL4Int64:
    SLSL4Protocol,
    RandomAccessCollection,
    MutableCollection,
    RangeReplaceableCollection,
    ExpressibleByArrayLiteral
{
    private var impl: SLSL4<Int64>
    
    public typealias SubSequence = SLSL4Int64
    public typealias Iterator = SLSL4Int64Iterator
    public typealias Element = Int64
    
    public init() {
        impl = SLSL4()
    }
    public init(_ xs:[Int64]) {
        impl = SLSL4()
        append(contentsOf: xs)
    }
    private init(_ xs:SLSL4<Int64>) {
        impl = xs
    }
    public init(arrayLiteral elements: Int64...) {
        impl = SLSL4()
        append(contentsOf: elements)
    }
    public init<C>(_ xs:C) where C:Collection, C.Element == Int64 {
        impl = SLSL4()
        append(contentsOf: xs)
    }
    
    public func makeIterator() -> SLSL4Int64Iterator {
        SLSL4Int64Iterator(impl: impl.makeIterator())
    }
    public var startIndex: Int { impl.startIndex }
    public var endIndex: Int { impl.endIndex }
    public subscript(_ i:Int) -> Int64 {
        get { impl[i] }
        set(x) { impl[i] = x }
    }
    public subscript(_ r: Range<Int>) -> SLSL4Int64 {
        SLSL4Int64(impl[r])
    }
    public mutating func replaceSubrange(_ subrange: Range<Int>, with newElements: [Int64]) {
        impl.replaceSubrange(subrange, with: newElements)
    }
}

public extension SLSL4Int64 {
    var sum: Int64 {
        impl.sum
    }
    func continuousOffset(at segmentedOffset:SLSL4SegmentedOffset<Int64>) -> Int64 {
        impl.continuousOffset(at: segmentedOffset)
    }
    func continuousOffset(at segmentOffset:Int) -> Int64 {
        impl.continuousOffset(at: segmentOffset)
    }
    func segmentedOffset(at continuousOffset:Int64) -> SLSL4SegmentedOffset<Int64> {
        impl.segmentedOffset(at: continuousOffset)
    }
}

public struct SLSL4Int64Iterator: IteratorProtocol {
    var impl: SLSL4Iterator<Int64>
    public typealias Element = Int64
    public mutating func next() -> Element? {
        impl.next()
    }
}

