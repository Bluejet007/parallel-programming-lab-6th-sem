#include <cuda.h>
#include <stdio.h>

#define M 3
#define N 4
#define L 3

__global__ void matMul(float *matA, float *matB, float *matRes, uint m, uint n, uint l) {
    uint j = blockDim.x * blockIdx.x + threadIdx.x,
    i = blockDim.y * blockIdx.y + threadIdx.y;

    if(i < m && j < l) {
        float acc = 0;
        for(uint k = 0; k < n; k++)
            acc += matA[k + n * i] * matB[j + l * k];
        matRes[j + l * i] = acc;
    }
}

void printMatf(float *mat, uint m, uint n) {
    for(uint i = 0; i < m; i++) {
        for(uint j = 0; j < n; j++)
            printf("%.0f ", mat[i * n + j]);
        printf("\n");
    }
}

int main() {
    float matA[M][N] = {
        {0, 1, 2, 3},
        {4, 5, 6, 7},
        {8, 9, 10, 11}
    },
    matB[N][L] = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9},
        {10, 11, 12}
    },
    matRes[M][L];
    float *dA, *dB, *dRes;

    size_t sA = sizeof(float),
    sB = sA * N * L,
    sRes = sA * M * L;
    sA *= M * N;

    cudaMalloc((void **) &dA, sA);
    cudaMalloc((void **) &dB, sB);
    cudaMalloc((void **) &dRes, sRes);

    cudaMemcpy(dA, matA, sA, cudaMemcpyHostToDevice);
    cudaMemcpy(dB, matB, sB, cudaMemcpyHostToDevice);
    
    matMul<<<dim3((M + 15) / 16, (N + 15) / 16), dim3(16, 16)>>>(dA, dB, dRes, M, N, L);
    cudaMemcpy(matRes, dRes, sRes, cudaMemcpyDeviceToHost);
    printf("Result:\n");
    printMatf((float *) matRes, M, L);

    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dRes);
    printf("Rachit 54\n");
    return 0;
}