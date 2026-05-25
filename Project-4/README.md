# Project 4 - CUDA iota and Julia Set

## Overview

This project implements two independent CUDA programs:
1. A CUDA version of the standard `std::iota` function
2. A CUDA-based Julia set fractal generator

Both programs compare CPU and GPU performance and demonstrate when GPU acceleration is useful.

---

## 1. iota Implementation

The iota function fills an array such that:

iota[i] = i + startValue

### CPU Version
The CPU version runs in a simple loop and performs well for this task due to minimal overhead.

### CUDA Version
The CUDA version assigns one thread per array element. However, performance is not significantly better than the CPU version.

### Question: Are the results what you expected? Speculate as to why it looks like CUDA isn’t a great solution for this problem.

Yes, the results match expectations.

The CUDA version of iota does not significantly outperform the CPU version, and in many cases is slower.

This is because the iota operation is extremely simple (just a single addition per element), so there is not enough computation per thread to justify GPU overhead.

CUDA is not a good fit for this problem because:
- Kernel launch overhead is relatively expensive
- Memory transfer between CPU and GPU adds additional cost
- Each thread performs very little work (low compute-to-memory ratio)

As a result, the CPU version can be competitive or faster for small to moderate input sizes, despite having no parallelism.

---

## 2. Julia Set Implementation

The Julia set is generated using the iterative equation:

z = z² + c

Each pixel corresponds to a complex number, and each GPU thread computes the iteration independently.

### CPU Version
The CPU version computes each pixel sequentially using nested loops.

### CUDA Version
The CUDA version parallelizes computation by assigning one thread per pixel, making it highly suitable for GPU execution due to its large number of independent computations.

---

## Julia Set Image

Starting value used:
z₀ = (0, 0)

### Output:

![Julia Set](./Project-4/julia.ppm)

---

## Observations

Unlike iota, the Julia set benefits significantly from GPU acceleration because each thread performs many iterations of computation. This makes it a compute-heavy problem where CUDA is effective.

---

## Conclusion

CUDA is not beneficial for simple operations like iota due to overhead costs, but it is highly effective for compute-intensive tasks such as fractal generation.
