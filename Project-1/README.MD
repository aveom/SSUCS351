## Mel Aveo
## Project-1

### 1. Which program is fastest? Is it always the fastest?

Based on trials, **`alloca.cpp` is consistently the fastest program** across all tested list sizes. The performance advantage comes from allocating nodes on the **stack** rather than the heap, which avoids dynamic memory management overhead.  

| Program      | NUM_BLOCKS = 1,000,000 | NUM_BLOCKS = 10,000,000 |
|-------------|------------------------|-------------------------|
| `alloca.out`  | avg 0.139 s           | avg 1.356 s             |
| `malloc.out`  | avg 0.163 s           | avg 1.553 s             |
| `new.out`     | avg 0.199 s           | avg 2.013 s             |
| `list.out`    | avg 0.206 s           | avg 2.031 s             |

While `alloca.cpp` is always the fastest, the **relative performance of `list.cpp` and `new.cpp` can vary slightly** depending on the number of nodes and system memory behavior.

### 2. Which program is slowest? Is it always the slowest?

For smaller list sizes (NUM_BLOCKS = 100,000), **`list.cpp` and `new.cpp` had similar average times**, with `list.cpp` slightly slower. For very large lists (NUM_BLOCKS = 10,000,000), **`list.cpp` remains slightly slower than `new.cpp`**, but the difference is minimal.  

**`list.cpp` tends to be the slowest program**, due to the overhead of using `std::list` and `std::vector`, but it is **not always strictly the slowest**, especially for smaller lists where its performance is close to `new.cpp`.

### Question 3: Trend with Node Size

| Node Size (bytes) | alloca (avg)  | list (avg)  | malloc (avg) | new (avg)  |
|------------------ |---------------|-------------|--------------|------------|
| 10                | 0.069         | 0.140       | 0.089        | 0.139      |
| 100               | 0.307         | 0.394       | 0.337        | 0.383      |
| 1000              | 2.855         | 2.860       | 2.685        | 2.781      |

**Observations:**
1. Execution time increases as the node size increases for all allocation methods.
2. `alloca` is fastest for small nodes due to stack allocation, while `malloc`/`new` are slightly slower but comparable for larger nodes.
3. `list` has additional overhead from storing links, making it slower for small nodes, but this overhead is less noticeable as node size grows.

### Question 4: Trend with Block Chain

| Range (bytes) | alloca (avg) | list (avg) | malloc (avg) | new (avg) |
|---------------|--------------|------------|--------------|-----------|
| 10–20         | 0.080 s      | 0.149 s    | 0.101 s      | 0.147 s   |
| 10–100        | 0.151 s      | 0.218 s    | 0.169 s      | 0.219 s   |
| 10–1000       | 0.968 s      | 1.045 s    | 1.008 s      | 1.067 s   |

**Observations:**

1. Allocation time increases as block size increases.
2. `alloca` consistently provides the fastest allocation, particularly for small blocks.
3. `malloc` is faster than `list` and `new` for most sizes, but the gap narrows for larger blocks.
4. `list` and `new` are slower than `alloca` and `malloc` across all block sizes.

### Question 5: Heap breaks and stack behavior

From the trials, the following observations can be made:

- **Heap vs Stack allocation**:
  - `alloca` uses **stack memory**. Memory usage increases quickly as block size grows, and very large blocks can approach the stack limit.  
  - `malloc` and `new` use the **heap**, which grows more gradually as the program allocates more memory.  
  - `list` also uses heap memory for its nodes, which adds extra overhead per block.

- **Heap breaks**:
  - Heap allocations (`malloc`/`new`) show noticeable increases in memory usage as the heap grows to accommodate new blocks. These increases reflect the movement of the heap break upward.  
  - Stack allocations (`alloca`) grow continuously with each allocation but are limited by the maximum stack size.

- **Effect of increasing block size**:
  - For all programs, increasing `MAX_BYTES` increases memory usage.  
  - Stack-allocated blocks (`alloca`) grow rapidly and can reach system limits faster than heap allocations.  
  - Heap allocations (`malloc`/`new`) handle larger memory requests more gracefully, though allocation overhead may vary slightly.

- **Similarities and differences**:
  - **Similarities**: Memory usage increases as block size grows in all programs.  
  - **Differences**: 
    - Stack allocation (`alloca`) is faster but limited in size.  
    - Heap allocation (`malloc/new`) is slower but can accommodate much larger allocations.  
    - `list` adds extra per-node overhead, causing higher memory usage for smaller block sizes.

### Question 6: Node Diagram for malloc.cpp

The relationships of `head`, `tail`, and `next` pointers are illustrated below.

#### Linked List Structure
```text
head
|
v
+--------+ +--------+
| Node1 | ----> | Node2 | ----> NULL
+--------+ +--------+
                  ^
                  |
                 tail
```


#### Node Structure
```text
Node1
+----------------+
| bytes: 0xAAA | ---> [6 bytes allocated]
| next: Node2   |
+----------------+

Node2
+----------------+
| bytes: 0xBBB | ---> [6 bytes allocated]
| next: NULL    |
+----------------+
```

#### Explanation

- `head` points to the first node (`Node1`), `tail` points to the last node (`Node2`).
- Each Node’s `next` pointer links it to the following Node, forming the linked list.
- The `bytes` pointer inside each Node points to the beginning of the dynamically allocated memory block.
- Memory size for each block is 6 bytes as specified in the program parameters.

### Question 7: Comparing Overheads

- **Memory Allocation:**  
  - `alloca` uses the stack — very fast, minimal bookkeeping.  
  - `malloc` and `new` use the heap — slower due to heap management.  
  - `list` allocates each Node on the heap, adding extra overhead for Node pointers and bookkeeping.

- **Initialization:**  
  - `alloca` does minimal initialization (just pointer arithmetic).  
  - `malloc` writes to memory to initialize bytes.  
  - `new` also calls constructors (if any), adding a small extra overhead.  
  - `list` initializes Node structures (pointers + data), slightly more work than plain memory allocation.

- **Processing (hashing):**  
  - Identical in all programs; once memory is allocated and initialized, hashing or computation occurs in the same way.

### Question 8: Significance of Node Allocation with Increasing Data Size

Each Node has a fixed overhead due to its structure (pointers, metadata) and allocator bookkeeping. When the data in a Node is small, this overhead is relatively significant. As the data size increases, the fixed overhead becomes a smaller fraction of the total memory per Node.

**Observation:**  
- Small data blocks → Node overhead is significant relative to data.  
- Large data blocks → Node overhead is negligible relative to data.
