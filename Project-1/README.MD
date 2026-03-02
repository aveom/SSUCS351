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

While `alloca.cpp` is always the fastest in these experiments, the **relative performance of `list.cpp` and `new.cpp` can vary slightly** depending on the number of nodes and system memory behavior.

### 2. Which program is slowest? Is it always the slowest?

For smaller list sizes (NUM_BLOCKS = 100,000), **`list.cpp` and `new.cpp` had similar average times**, with `list.cpp` slightly slower. For very large lists (NUM_BLOCKS = 10,000,000), **`list.cpp` remains slightly slower than `new.cpp`**, but the difference is minimal.  

**`list.cpp` tends to be the slowest program**, due to the overhead of using `std::list` and `std::vector`, but it is **not always strictly the slowest**, especially for smaller lists where its performance is close to `new.cpp`.

### Question 3: Trend with Node Size

Ran each program with nodes of 10, 100, and 1000 bytes and measured average execution times:

| Node Size (bytes) | alloca | list  | malloc | new   |
|------------------|--------|-------|--------|-------|
| 10               | 0.069  | 0.140 | 0.089  | 0.139 |
| 100              | 0.307  | 0.394 | 0.337  | 0.383 |
| 1000             | 2.855  | 2.860 | 2.685  | 2.781 |

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

**Conclusion**:  
Increasing the stack size only affects programs using stack allocation (`alloca`) and does not impact heap memory. Heap allocations manage their own memory independently, and the heap break moves upward as more memory is allocated.
