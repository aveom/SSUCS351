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

Thus, **`list.cpp` tends to be the slowest program**, due to the overhead of using `std::list` and `std::vector`, but it is **not always strictly the slowest**, especially for smaller lists where its performance is close to `new.cpp`.

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
