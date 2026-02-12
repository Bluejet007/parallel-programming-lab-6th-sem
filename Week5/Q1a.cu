#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void add(int *a, int *b, int *c) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;

    c[tid] = a[tid] + b[tid];
}

int main() {
    int *a, *b, *c;
    int *dA, *dB, *dC;
    int n;

    printf("Array size: ");
    scanf("%d", &n);
    size_t size = sizeof(int) * n;
    
    a = (int *) malloc(size);
    b = (int *) malloc(size);
    c = (int *) malloc(size);
    for(int i = 0; i < n; i++) {
        a[i] = i + 1;
        b[i] = 3 - 2 * i;
    }
    
    cudaMalloc((void **) &dA, size);
    cudaMalloc((void **) &dB, size);
    cudaMalloc((void **) &dC, size);

    cudaMemcpy(dA, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(dB, b, size, cudaMemcpyHostToDevice);

    add<<<1, n>>>(dA, dB, dC);
    cudaMemcpy(c, dC, size, cudaMemcpyDeviceToHost);
    
    printf("Result:\n");
    for(int i = 0; i < n; i++)
        printf("%d ", c[i]);
    printf("\n");

    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dC);

    printf("Rachit 54\n");
    return 0;
}