SLSL
=====
Eonil, 2020.

SLSL means *Segment Length Summation List*.
This is a persistent and ordered list (`Swift.Array`-like) with these features.

- You store lengths of segments.
- You can perform quick random subrange sum and offset for sum in O(log n) time.
- All random read/write/insert/remove/copy/merge/split operations take O(log n) time.
- Subsequences are same type and uses local offset.

This type also explicitly conforms these protocols.
- `RandomAccessCollection`.
- `MutableCollection`.
- `RangeReplaceableCollection`.

You can use `SLSL` just like `Swift.Array`.
There's two core differences.

- `segmentedOffset(at:)` function.
- `continuousOffset(at:)` function.



Design Choices
-------------------
- **Optimized for least maintenance cost.**
    - Simpler logic, less code size.
    - Suboptimal, but good enough performance.
- Persistent.
    - O(log n) copy.
    - Most nodes are memory shared.
- Follows standard Swift collection protocols.
- Treats in-cache primitve operations as O(1).
    - Fetching non-cached data from non-cache memory is 1000x slower.
    - Having many in-cache primitive operations is not a big problem.
    - Constant number can be treaked later.
- Indices = offsets.
    - Always `startIndex == 0`.
    - Always `endIndex == count`.
    - You don't need to care about offset/indexing inconsistency.
    - Also true for all subsequences and subsequences of the subsequences.
    - Implemented using classica B-Tree without key.
- This is an indexing structure and does not store actual elements.
    - Only segment lengths.
    - You need to store your elements in somewhere else.
    - This design gives us flexibility of storage.
    - You can choose optimal storage for your elements.





Concepts/Terms Illustrated
-------------------------------
There are several potentially confusing terms.
I define them here with illustrations.
Terms maybe not a best name, but I couldn't find a better one.

Let's say we have a big giant flat list.
Though I have only 7 elements here, please imagine a large one.

    +---+---+---+---+---+---+---+
    |                           |
    +---+---+---+---+---+---+---+

And we want to split it into multiple segments.
  
    +---+---+     +---+     +---+---+---+---+
    |       |     |   |     |               |
    +---+---+     +---+     +---+---+---+---+
    
And store the segments in a list.
Now we have list of segments.

    +---+---+---+---+---+---+---+
    |       |   |               |
    +---+---+---+---+---+---+---+
    
I call first one as *Continuous List*, and last one as *Segmented List*.
We can get original Continuous List back by joining all segments in Segmented List.

    Continuous List
    +---+---+---+---+---+---+---+
    |                           |
    +---+---+---+---+---+---+---+

    Segmented List
    +---+---+---+---+---+---+---+
    |       |   |               |
    +---+---+---+---+---+---+---+


`SLSL` is Segmented List.
And `SLSL` stores only segment lengths.
Therefore an `SLSL` instance for above list has these elements.

    2 1 4

Continuous List and Segmented List store same elements,
but with two different addressing methods.

    Continuous List
    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+
    |                           |
    +---+---+---+---+---+---+---+

    Segmented List
    0
    0   1
    .
    .       1
    .       0   1
    .       .
    .       .   2
    .       .   0   1   2   3
    +---+---+---+---+---+---+---+
    |       |   |               |
    +---+---+---+---+---+---+---+
    
I call offsets in Continuous List as *Continuous Offset*.
And offset pairs in Segmented List as *Segmented Offset*.

`SLSL` provides a way to translate two offsets vice versa.

- `continuousOffset(at:)`.
- `segmentedOffset(at:)`.

For example, let's say we want to point element at Joined Offset 4.
    
    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+
    |                 V         |
    +---+---+---+---+---+---+---+

Same element can be addressed using Segmented Offset (2,1).

    0             1           2
    0   1   2     0   1       0   1   2   3   4
    +---+---+     +---+       +---+---+---+---+
    |       |     |   |       |     V         |
    +---+---+     +---+       +---+---+---+---+
    


Credits
--------
Copyright(C) Eonil, 2020.
Licensed under "MIT License".

