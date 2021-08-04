public protocol SLSL4Protocol {
    var sum: Element { get }
    
    init()
    init(_ xs:[Element])
//    init<C>(_ xs:C) where C:Collection, C.Element == Element
    
    func makeIterator() -> Iterator
    var startIndex: Index { get }
    var endIndex: Index { get }
    subscript(_ i:Int) -> Element { get set }
    subscript(_ r:Range<Int>) -> Self { get }
    mutating func replaceSubrange(_ subrange:Range<Index>, with newElements:[Element])

    /// Finds offset in continuous space from offset in segmented space..
    func continuousOffset(at segmentedOffset:SLSL4SegmentedOffset<Element>) -> Element
    func continuousOffset(at segmentOffset:Int) -> Element
    /// Finds offset in segmented space from offset in continuous space.
    func segmentedOffset(at continuousOffset:Element) -> SLSL4SegmentedOffset<Element>
    
    associatedtype Element: BinaryInteger
    associatedtype Iterator: IteratorProtocol
    
    typealias Index = Int
    typealias SubSequence = Self
}

public extension SLSL4Protocol {
    subscript<R:RangeExpression>(_ r:R) -> Self where R.Bound == Index {
        self[r.relative(to: startIndex..<endIndex)]
    }
}
public extension SLSL4Protocol {
    mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, Self.Element == C.Element, Self.Index == R.Bound {
        let q = subrange.relative(to: startIndex..<endIndex) as Range<Index>
        let xs = Array(newElements)
        replaceSubrange(q, with: xs)
    }
}

public extension SLSL4Protocol {
    mutating func append<C>(contentsOf newElements: C) where C : Collection, Self.Element == C.Element {
        replaceSubrange(endIndex..<endIndex, with: Array(newElements))
    }
    mutating func append(contentsOf newElements: [Element]) {
        replaceSubrange(endIndex..<endIndex, with: newElements)
    }
    mutating func append(newElement: Element) {
        append(contentsOf: CollectionOfOne(newElement))
    }
}
