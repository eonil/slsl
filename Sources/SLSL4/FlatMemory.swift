struct FlatMemory<T>: Sequence, RandomAccessCollection {
    @inline(__always)
    fileprivate var storage = FlatMemoryStorage<T>()
    
    @inline(__always)
    init() {}
    
    @inline(__always)
    init(_ xs:Slice<FlatMemory<T>>) {
        replaceSubrange(0..<0, with: xs)
    }
    
    @inline(__always)
    init(_ xs:ArraySlice<T>) {
        replaceSubrange(0..<0, with: xs)
    }
    
    @inline(__always)
    func makeIterator() -> FlatMemoryIterator<T> {
        FlatMemoryIterator(base: self)
    }
    
    @inline(__always)
    var count: Int { storage.count }
    
    @inline(__always)
    var startIndex: Int { 0 }
    
    @inline(__always)
    var endIndex: Int { storage.count }
    
    @inline(__always)
    subscript(_ i:Int) -> T {
        get { storage[i] }
        set(x) { storage[i] = x }
    }
    
    @inline(__always)
    mutating func replaceSubrange(_ range:Range<Int>, with xs:UnsafeBufferPointer<T>) {
        guard !(range.count == 0 && xs.count == 0) else { return }
        if !isKnownUniquelyReferenced(&storage) {
            storage = storage.clone()
        }
        storage.replaceSubrange(range, with: xs)
    }
    
    @inline(__always)
    mutating func replaceSubrange(_ range:Range<Int>, with xs:Slice<FlatMemory<T>>) {
        replaceSubrange(range, with: xs.base.storage[xs.indices])
    }
    
    @inline(__always)
    mutating func replaceSubrange(_ range:Range<Int>, with xs:ArraySlice<T>) {
        xs.withUnsafeBufferPointer { buffer in
            replaceSubrange(range, with: buffer)
        }
    }
}

struct FlatMemoryIterator<T>: IteratorProtocol {
    @inline(__always)
    fileprivate let base: FlatMemory<T>
    @inline(__always)
    fileprivate var offset = 0
    
    @inline(__always)
    mutating func next() -> T? {
        if offset == base.count { return nil }
        let z = base[offset]
        offset += 1
        return z
    }
}

private final class FlatMemoryStorage<T> {
    @inline(__always)
    private(set) var ptr: UnsafeMutablePointer<T>
    
    @inline(__always)
    private(set) var count = 0
    
    @inline(__always)
    init() {
        let rptr = UnsafeMutableRawPointer.allocate(
            byteCount: Limit<T>.cacheLineSize,
            alignment: MemoryLayout<T>.alignment)
        ptr = rptr.bindMemory(to: T.self, capacity: Limit<T>.bucketCapacity)
//        ptr = .allocate(capacity: Limit<T>.bucketCapacity)
    }
    
    @inline(__always)
    deinit {
        replaceSubrange(0..<count, with: UnsafeBufferPointer<T>(start: nil, count: 0))
        ptr.deallocate()
    }
    
    @inline(__always)
    subscript(_ i:Int) -> T {
        get {
            precondition(i < count)
            return ptr[i]
        }
        set(x) {
            precondition(i < count)
            (ptr + i).deinitialize(count: 1)
            (ptr + i).initialize(to: x)
        }
    }
    
    @inline(__always)
    subscript(_ range:Range<Int>) -> UnsafeBufferPointer<T> {
        precondition(0 <= range.lowerBound)
        precondition(range.lowerBound <= count)
        precondition(range.upperBound <= count)
        return UnsafeBufferPointer(start: ptr + range.lowerBound, count: range.count)
    }
    
    @inline(__always)
    func replaceSubrange(_ range:Range<Int>, with xs:UnsafeBufferPointer<T>) {
        precondition(0 <= range.lowerBound)
        precondition(range.lowerBound <= count)
        precondition(range.upperBound <= count)
        precondition(count - range.count + xs.count <= Limit<T>.bucketCapacity, "Insufficient space.")
        assert(xs.baseAddress == nil && xs.count == 0 || xs.baseAddress != nil)
        
        ptr.advanced(by: range.lowerBound).deinitialize(count: range.count)
        let srcptr = ptr.advanced(by: range.upperBound)
        let dstptr = ptr.advanced(by: range.lowerBound + xs.count)
        let c = count - range.upperBound
        dstptr.moveInitialize(from: srcptr, count: c)
        if let xsptr = xs.baseAddress {
            ptr.advanced(by: range.lowerBound).initialize(from: xsptr, count: xs.count)
        }
        count += -range.count + xs.count
    }
    
    @inline(__always)
    func clone() -> FlatMemoryStorage {
        let new = FlatMemoryStorage()
        new.replaceSubrange(0..<0, with: self[0..<count])
        return new
    }
}
