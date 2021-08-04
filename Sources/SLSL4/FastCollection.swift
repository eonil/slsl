protocol FastCollection:
    RandomAccessCollection
where
    Index == Int,
    SubSequence == Self
{
    init()
    init(_ xs:ArraySlice<Element>)
    
    func makeIterator() -> Iterator
    var startIndex: Index { get }
    var endIndex: Index { get }
    subscript(_ i:Index) -> Element { get set }
    subscript(_ r:Range<Index>) -> Self { get }
    mutating func replaceSubrange(_ subrange:Range<Index>, with newElements:ArraySlice<Element>)
    
    associatedtype Element
}

extension FastCollection {
    var isEmpty: Bool { count == 0 }
    var count: Int { endIndex - startIndex }
    var indices: Range<Index> { startIndex..<endIndex }
    
    var first: Element? { count == 0 ? nil : self[startIndex] }
    var last: Element? { count == 0 ? nil : self[endIndex - 1] }
    
    mutating func replaceSubrange(_ subrange:Range<Index>, with newElements:[Element]) {
        replaceSubrange(subrange, with: newElements[...])
    }
    mutating func replaceSubrange(_ subrange:Range<Index>, with newElements:Self) {
        replaceSubrange(subrange, with: Array(newElements))
    }
    mutating func insert(contentsOf xs:[Element], at i:Int) {
        replaceSubrange(i..<i, with: xs)
    }
    mutating func insert(contentsOf xs:ArraySlice<Element>, at i:Int) {
        replaceSubrange(i..<i, with: xs)
    }
    mutating func insert(contentsOf xs:Self, at i:Int) {
        replaceSubrange(i..<i, with: xs)
    }
    mutating func insert(_ x:Element, at i:Int) {
        replaceSubrange(i..<i, with: [x])
    }
    mutating func append(contentsOf xs:[Element]) {
        insert(contentsOf: xs, at: endIndex)
    }
    mutating func append(contentsOf xs:ArraySlice<Element>) {
        insert(contentsOf: xs, at: endIndex)
    }
    mutating func append(contentsOf xs:Self) {
        insert(contentsOf: xs, at: endIndex)
    }
    mutating func append(_ x:Element) {
        insert(x, at: endIndex)
    }
    
    mutating func removeSubrange(_ r:Range<Int>) {
        replaceSubrange(r, with: [])
    }
    mutating func remove(at i:Int) {
        removeSubrange(i..<i+1)
    }
}
