#include <cuda.h>
#include <stdio.h>

#define M 3
#define N 4

__global__ void powRow(float *aMat, uint m, uint n) {
    uint i = blockDim.x * blockIdx.x + threadIdx.x,
    j = blockDim.y * blockIdx.y + threadIdx.y;

    if(i < m && j < n)
        aMat[i * n + j] = powf(aMat[i * n + j], i + 1);
}

void printMatf(float *mat, uint m, uint n) {
    for(uint i = 0; i < m; i++) {
        for(uint j = 0; j < n; j++)
            printf("%.0f ", mat[i * n + j]);
        printf("\n");
    }
}

int main() {
    float matA[][N] = {
        {0, 1, 2, 3},
        {4, 5, 6, 7},
        {8, 9, 10, 11}
    };
    float *dA;

    size_t sA = sizeof(float) * M * N;

    cudaMalloc((void **) &dA, sA);

    cudaMemcpy(dA, matA, sA, cudaMemcpyHostToDevice);

    powRow<<<1, dim3(M, N)>>>(dA, M, N);
    cudaMemcpy(matA, dA, sA, cudaMemcpyDeviceToHost);
    printf("Result:\n");
    printMatf((float *) matA, M, N);

    cudaFree(dA);
    printf("Rachit 54\n");
    return 0;
}