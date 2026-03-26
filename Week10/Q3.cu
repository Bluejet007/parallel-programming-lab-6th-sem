#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void conv1D(float *arr, float *ker, float *res, uint mLen, uint len) {
    uint i = blockDim.x * blockIdx.x + threadIdx.x;
    
    if(i < len) {
        __shared__ float tile[35];
        int n = mLen / 2;

        int haloL = i - blockDim.x;
        if(threadIdx.x >= blockDim.x - n)
            tile[threadIdx.x - blockDim.x + n] = (haloL < 0) ? 0 : arr[haloL];

        tile[n + threadIdx.x] = arr[blockIdx.x * blockDim.x + threadIdx.x];

        int haloR = i + blockDim.x;
        if(threadIdx.x < n)
            tile[threadIdx.x + blockDim.x + n] = (haloR >= len) ? 0 : arr[haloR];

        __syncthreads();

        float val = 0;
        for (uint j = 0; j < mLen; j++)
            val += tile[threadIdx.x + j] * ker[j];

        res[i] = val;
    }
}

void printArrf(float *arr, uint len) {
    for (uint i = 0; i < len; i++)
        printf("%.0f ", arr[i]);
    printf("\n");
}

int main() {
    float *arr, *ker, *res;
    float *dArr, *dKer, *dRes;
    int n, m;

    printf("Array size: ");
    scanf("%d", &n);
    printf("Mask size: ");
    scanf("%d", &m);

    size_t nSize = sizeof(float) * n;
    size_t mSize = sizeof(float) * m;

    arr = (float *) malloc(nSize);
    ker = (float *) malloc(mSize);
    res = (float *) malloc(nSize);

    for (int i = 0; i < n; i++) {
        arr[i] = rand() % 10;
        if (i < m)
            ker[i] = rand() % 10;
    }

    printf("Array:\n");
    printArrf(arr, n);
    printf("Kernel:\n");
    printArrf(ker, m);

    cudaMalloc((void **) &dArr, nSize);
    cudaMalloc((void **) &dKer, mSize);
    cudaMalloc((void **) &dRes, nSize);

    cudaMemcpy(dArr, arr, nSize, cudaMemcpyHostToDevice);
    cudaMemcpy(dKer, ker, mSize, cudaMemcpyHostToDevice);

    conv1D<<<(n + 31) / 32, 32>>>(dArr, dKer, dRes, m, n);
    cudaMemcpy(res, dRes, nSize, cudaMemcpyDeviceToHost);

    printf("Result:\n");
    printArrf(res, n);

    cudaFree(dArr);
    cudaFree(dKer);
    cudaFree(dRes);
    free(arr);
    free(ker);
    free(res);

    printf("Rachit 54\n");
    return 0;
}