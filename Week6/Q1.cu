#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void conv1D(float *arr, float *ker, float *res, unsigned int mLen, unsigned int len) {
    int i =  blockDim.x * blockIdx.x + threadIdx.x;
    int start = i - mLen / 2;

    float val = 0;
    for(int j = 0; j < mLen; j++) {
        if(start + j >= 0 && start + j < len)
            val += arr[start + j] * ker[j];
    }

    res[i] = val;
}

void printArrf(float *arr, unsigned int len) {
    for(unsigned int i = 0; i < len; i++)
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
    size_t nSize = sizeof(float) * n, mSize = sizeof(float) * m;
    
    res = (float *) malloc(nSize);
    arr = (float *) malloc(nSize);
    ker = (float *) malloc(mSize);
    for(int i = 0; i < n; i++) {
        arr[i] = rand() % 10;
        if(i < m)
            ker[i] = rand() % 10;
    }

    printf("Array:\n");
    printArrf(arr, n);
    printf("Kernel:\n");
    printArrf(ker, m);
    
    cudaMalloc((void **) &dRes, nSize);
    cudaMalloc((void **) &dArr, nSize);
    cudaMalloc((void **) &dKer, mSize);

    cudaMemcpy(dArr, arr, nSize, cudaMemcpyHostToDevice);
    cudaMemcpy(dKer, ker, mSize, cudaMemcpyHostToDevice);

    conv1D<<<1, n>>>(dArr, dKer, dRes, m, n);
    cudaMemcpy(res, dRes, nSize, cudaMemcpyDeviceToHost);

    printf("Result:\n");
    printArrf(res, n);

    cudaFree(dArr);
    cudaFree(dKer);
    cudaFree(dRes);

    printf("Rachit 54\n");
    return 0;
}