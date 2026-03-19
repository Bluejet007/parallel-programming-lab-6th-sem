#include <cuda.h>
#include <stdio.h>

#define M 3
#define N 4

__global__ void addRow(float *aMat, float *bMat, float *resMat, uint m, uint n) {
    uint i = blockDim.x * blockIdx.x + threadIdx.x;

    if(i < m)
        i *= n;
        for(uint j = 0; j < n; j++)
            resMat[i + j] = aMat[i + j] + bMat[i + j];
}

__global__ void addCol(float *aMat, float *bMat, float *resMat, uint m, uint n) {
    uint j = blockDim.x * blockIdx.x + threadIdx.x;

    if(j < n)
        for(uint i = 0; i < (m - 1) * n; i += n)
            resMat[i + j] = aMat[i + j] + bMat[i + j];
}

__global__ void addEle(float *aMat, float *bMat, float *resMat, uint m, uint n) {
    uint i = blockDim.x * blockIdx.x + threadIdx.x;

    if(i < n * m)
        resMat[i] = aMat[i] + bMat[i];
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
    },
    matB[][N] = {
        {2, 4, 6, 8},
        {10, 12, 14, 16},
        {18, 20, 22, 24}
    },
    matRes[M][N];
    float *dA, *dB, *dRes;
    size_t size = sizeof(float) * M * N;

    cudaMalloc((void **) &dA, size);
    cudaMalloc((void **) &dB, size);
    cudaMalloc((void **) &dRes, size);

    cudaMemcpy(dA, matA, size, cudaMemcpyHostToDevice);
    cudaMemcpy(dB, matB, size, cudaMemcpyHostToDevice);

    addRow<<<1, M>>>(dA, dB, dRes, M, N);
    cudaMemcpy(matRes, dRes, size, cudaMemcpyDeviceToHost);
    printf("Row-wise:\n");
    printMatf((float *) matRes, M, N);

    addCol<<<1, N>>>(dA, dB, dRes, M, N);
    cudaMemcpy(matRes, dRes, size, cudaMemcpyDeviceToHost);
    printf("Col-wise:\n");
    printMatf((float *) matRes, M, N);

    addEle<<<1, M * N>>>(dA, dB, dRes, M, N);
    cudaMemcpy(matRes, dRes, size, cudaMemcpyDeviceToHost);
    printf("Ele-wise:\n");
    printMatf((float *) matRes, M, N);

    cudaFree(matA);
    cudaFree(matB);
    cudaFree(matRes);
    printf("Rachit 54\n");
    return 0;
}