#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__constant__ float dKer[1024];

__global__ void conv1D(float *arr, float *res, uint mLen, uint len) {
    uint i = blockDim.x * blockIdx.x + threadIdx.x;

    if(i < len) {
        int start = i - mLen / 2;
        float val = 0;

        for (int j = 0; j < mLen; j++) {
            int idx = start + j;
            if (idx >= 0 && idx < len) {
                val += arr[idx] * dKer[j];
            }
        }

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
    float *dArr, *dRes;
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
    cudaMalloc((void **) &dRes, nSize);

    cudaMemcpy(dArr, arr, nSize, cudaMemcpyHostToDevice);
    cudaMemcpyToSymbol(dKer, ker, mSize);

    conv1D<<<(n + 255) / 256, 256>>>(dArr, dRes, m, n);
    cudaMemcpy(res, dRes, nSize, cudaMemcpyDeviceToHost);

    printf("Result:\n");
    printArrf(res, n);

    cudaFree(dArr);
    cudaFree(dRes);
    free(arr);
    free(ker);
    free(res);

    printf("Rachit 54\n");
    return 0;
}