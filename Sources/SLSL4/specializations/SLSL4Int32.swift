public struct SLSL4Int32:
    SLSL4Protocol,
    RandomAccessCollection,
    MutableCollection,
    RangeReplaceableCollection,
    ExpressibleByArrayLiteral
{
    private var impl: SLSL4<Int32>
    
    public typealias SubSequence = SLSL4Int32
    public typealias Iterator = SLSL4Int32Iterator
    public typealias Element = Int32
    
    public init() {
        impl = SLSL4()
    }
    public init(_ xs:[Int32]) {
        impl = SLSL4()
        append(contentsOf: xs)
    }
    private init(_ xs:SLSL4<Int32>) {
        impl = xs
    }
    public init(arrayLiteral elements: Int32...) {
        impl = SLSL4()
        append(contentsOf: elements)
    }
    public init<C>(_ xs:C) where C:Collection, C.Element == Int32 {
        impl = SLSL4()
        append(contentsOf: xs)
    }
    
    public func makeIterator() -> SLSL4Int32Iterator {
        SLSL4Int32Iterator(impl: impl.makeIterator())
    }
    public var startIndex: Int { impl.startIndex }
    public var endIndex: Int { impl.endIndex }
    public subscript(_ i:Int) -> Int32 {
        get { impl[i] }
        set(x) { impl[i] = x }
    }
    public subscript(_ r: Range<Int>) -> SLSL4Int32 {
        SLSL4Int32(impl[r])
    }
    public mutating func replaceSubrange(_ subrange: Range<Int>, with newElements: [Int32]) {
        impl.replaceSubrange(subrange, with: newElements)
    }
}

public extension SLSL4Int32 {
    var sum: Int32 {
        impl.sum
    }
    func continuousOffset(at segmentedOffset:SLSL4SegmentedOffset<Int32>) -> Int32 {
        impl.continuousOffset(at: segmentedOffset)
    }
    func continuousOffset(at segmentOffset:Int) -> Int32 {
        impl.continuousOffset(at: segmentOffset)
    }
    func segmentedOffset(at continuousOffset:Int32) -> SLSL4SegmentedOffset<Int32> {
        impl.segmentedOffset(at: continuousOffset)
    }
}

public struct SLSL4Int32Iterator: IteratorProtocol {
    var impl: SLSL4Iterator<Int32>
    public typealias Element = Int32
    public mutating func next() -> Element? {
        impl.next()
    }
}

