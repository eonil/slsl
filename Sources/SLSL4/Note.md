SLSL4
======
Eonil, 2020.

Current implementation is revision 4.

- Unlike Key-Value based B-Tree, items in vector don't stack up sequentially.
- We can specify insertion point therefore unbalancing can be inserted at any place.
- We need to prevent expanding tree until a bucket fully gets filled.
- Split to siblings only until buckets gets fullt filled.
- Once it becomes full, split it into two to siblings.




Insertion Balancing Illustrated
-----------------------------------
When we insert an element into a 4-way bucket,

    insert here.
         |   
    a b c d     e f 

Secure the space first.
Choose a side to move by relative offset in its capacity.
In this case it's `e f` side.
We first treat `e f` are positioned at right the end.

    a b c d                             e f 

Move out `d` to next sibling`.

    a b c _                           d e f
    
Place new element `1`.

    a b c 1                           d e f
    
Inserting more items can be place sequentially by creating new buckets.

    a b c 1     2 3 4 5     6 7       d e f
    
Sparse empty slots may degrade performance
For example, see these buckets. 
As this example is 4-way tree, we cannot create new buckets anymore.

    a b c d     e f g h     i j k l     m n o
    
If we insert after `c`, all elements need to be moved one-by-one through all siblings.
        
    a b c _     d e f g     h i j k     l m n o
        
Anyway, this is node-local, therefore takes constant time.

Just like inserting, deleting should be balanced.

If we delete same position repeatedly, we'll get unbalanced tree by deleting big part of a branch.
**Tree should pull elements from its siblings before erasing a depth.**




Late Depth Decrement Issue on Delete
-------------------------------------
- Currently, post-delete balancing algorithm implementation does not inspect 2 depths for merge.
- This causes a sort of "late depth decrement".
- This is not a big deal as decrement works well. 
- It just keeps nodes with fewer elements longer.
- It's possible to change this behavior to decrease eagerly.
    - But it needs deeper navigation on merge check after delete.
    - I'm not sure that's better, as this is not always bad. 
    - Especially for many random insert/remove scenario.

Slow Delete Issue
----------------------
- Currently, delete is very slow.
- It seems taking about 10 times slower than insert.
- I haven't benchmarked delete so it's unclear how it actually slow now.
- It needs benchmark and profiling. Do not make decision without them.
