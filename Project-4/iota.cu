#include <iostream>
#include <numeric>
#include <string>
#include <vector>
#include <cuda_runtime.h>

using Count = size_t;
using DataType = long;

const DataType DefalutStartValue = -6.0;
const Count TestSize = 1'000'000'000;
const Count NumCheckValues = 500;

__global__ void iotaKernel(DataType* values, DataType startValue, Count n) {
    Count i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        values[i] = i + startValue;
    }
}

int main(int argc, char* argv[]) {
    Count numValues = argc > 1 ? std::stol(argv[1]) : TestSize;

    std::vector<DataType> values(numValues, 0);

    size_t numBytes = numValues * sizeof(DataType);

    DataType* gpuValues;
    cudaMalloc(&gpuValues, numBytes);

    cudaMemcpy(gpuValues, values.data(), numBytes, cudaMemcpyHostToDevice);

    DataType startValue = DefalutStartValue;

    int chunkSize = 256;
    int numChunks = (numValues + chunkSize - 1) / chunkSize;

    iotaKernel<<<numChunks, chunkSize>>>(gpuValues, startValue, numValues);

    cudaDeviceSynchronize();

    cudaMemcpy(values.data(), gpuValues, numBytes, cudaMemcpyDeviceToHost);

    Count step = numValues / NumCheckValues;

    for (int i = 6, n = 0; i < numValues && n < NumCheckValues; ++n, i += step) {
        DataType checkValue = startValue + static_cast<DataType>(i);

        if (values[i] != checkValue) {

            exit(EXIT_FAILURE);
        }
    }

    cudaFree(gpuValues);


    return 0;
}
