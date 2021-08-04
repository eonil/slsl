public struct SLSL4Int:
    SLSL4Protocol,
    RandomAccessCollection,
    MutableCollection,
    RangeReplaceableCollection,
    ExpressibleByArrayLiteral
{
    private var impl: SLSL4<Int>
    
    public typealias SubSequence = SLSL4Int
    public typealias Iterator = SLSL4IntIterator
    public typealias Element = Int
    
    public init() {
        impl = SLSL4()
    }
    public init(_ xs:[Int]) {
        impl = SLSL4()
        append(contentsOf: xs)
    }
    private init(_ xs:SLSL4<Int>) {
        impl = xs
    }
    public init(arrayLiteral elements: Int...) {
        impl = SLSL4()
        append(contentsOf: elements)
    }
    public init<C>(_ xs:C) where C:Collection, C.Element == Int {
        impl = SLSL4()
        append(contentsOf: xs)
    }
    
    public func makeIterator() -> SLSL4IntIterator {
        SLSL4IntIterator(impl: impl.makeIterator())
    }
    public var startIndex: Int { impl.startIndex }
    public var endIndex: Int { impl.endIndex }
    public subscript(_ i:Int) -> Int {
        get { impl[i] }
        set(x) { impl[i] = x }
    }
    public subscript(_ r: Range<Int>) -> SLSL4Int {
        SLSL4Int(impl[r])
    }
    public mutating func replaceSubrange(_ subrange: Range<Int>, with newElements: [Int]) {
        impl.replaceSubrange(subrange, with: newElements)
    }
}

public extension SLSL4Int {
    var sum: Int {
        impl.sum
    }
    func continuousOffset(at segmentedOffset:SLSL4SegmentedOffset<Int>) -> Int {
        impl.continuousOffset(at: segmentedOffset)
    }
    func continuousOffset(at segmentOffset:Int) -> Int {
        impl.continuousOffset(at: segmentOffset)
    }
    func segmentedOffset(at continuousOffset:Int) -> SLSL4SegmentedOffset<Int> {
        impl.segmentedOffset(at: continuousOffset)
    }
}

public struct SLSL4IntIterator: IteratorProtocol {
    var impl: SLSL4Iterator<Int>
    public typealias Element = Int
    public mutating func next() -> Element? {
        impl.next()
    }
}

