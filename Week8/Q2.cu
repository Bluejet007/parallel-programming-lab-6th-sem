#include <cuda.h>
#include <stdio.h>

#define M 3
#define N 3
#define P 4

__global__ void powRow(float *aMat, float *bMat, float *resMat, uint m, uint n, uint p) {
    uint i = blockDim.x * blockIdx.x + threadIdx.x;

    if(i < m)
        for(uint j = 0; j < n; j++) {
            float acc = 0.0f;
            for(uint k = 0; k < p; k++)
                acc += aMat[i * p + k] * bMat[k * n + j];

            resMat[i * n + j] = acc;
        }
}

__global__ void mulCol(float *aMat, float *bMat, float *resMat, uint m, uint n, uint p) {
    uint j = blockDim.x * blockIdx.x + threadIdx.x;

    if(j < n)
        for(uint i = 0; i < m; i++) {
            float acc = 0.0f;
            for(uint k = 0; k < p; k++)
                acc += aMat[i * p + k] * bMat[k * n + j];

            resMat[i * n + j] = acc;
        }
}

__global__ void mulEle(float *aMat, float *bMat, float *resMat, uint m, uint n, uint p) {
    uint i = blockDim.x * blockIdx.x + threadIdx.x,
    j = blockDim.y * blockIdx.y + threadIdx.y;

    if(i * n + j < n * m) {
        float acc = 0.0f;
        for(uint k = 0; k < p; k++)
            acc += aMat[i * p + k] * bMat[k * n + j];

        resMat[i * n + j] = acc;
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
    float matA[][P] = {
        {0, 1, 2, 3},
        {4, 5, 6, 7},
        {8, 9, 10, 11}
    },
    matB[][N] = {
        {2, 10, 18},
        {4, 12, 20},
        {6, 14, 22},
        {8, 16, 24},
    },
    matRes[M][N];
    float *dA, *dB, *dRes;

    size_t sA = sizeof(float),
    sB = sA * P * N,
    sRes = sA * M * N;
    sA *= M * P;

    cudaMalloc((void **) &dA, sA);
    cudaMalloc((void **) &dB, sB);
    cudaMalloc((void **) &dRes, sRes);

    cudaMemcpy(dA, matA, sA, cudaMemcpyHostToDevice);
    cudaMemcpy(dB, matB, sB, cudaMemcpyHostToDevice);

    powRow<<<1, M>>>(dA, dB, dRes, M, N, P);
    cudaMemcpy(matRes, dRes, sRes, cudaMemcpyDeviceToHost);
    printf("Row-wise:\n");
    printMatf((float *) matRes, M, N);

    mulCol<<<1, N>>>(dA, dB, dRes, M, N, P);
    cudaMemcpy(matRes, dRes, sRes, cudaMemcpyDeviceToHost);
    printf("Col-wise:\n");
    printMatf((float *) matRes, M, N);

    mulEle<<<1, dim3(M, N)>>>(dA, dB, dRes, M, N, P);
    cudaMemcpy(matRes, dRes, sRes, cudaMemcpyDeviceToHost);
    printf("Ele-wise:\n");
    printMatf((float *) matRes, M, N);

    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dRes);
    printf("Rachit 54\n");
    return 0;
}