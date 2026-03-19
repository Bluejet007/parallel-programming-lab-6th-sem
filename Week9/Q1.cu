#include <cuda.h>
#include <stdio.h>

#define M 3
#define N 3

__global__ void mulCSR(float *aMat, float *bMat, float *resMat, uint m, uint n, uint p) {
    uint i = blockDim.x * blockIdx.x + threadIdx.x;

    if(i < m)
        for(uint j = 0; j < n; j++) {
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
    float matData[] = {1, 2, 3, 4, 5, 6},
    matCols[] = {0, 2, 0, 1, 2, 1},
    matRows[] = {0, 2, 5},
    vec[] = {2, 3, 4},
    matRes[M][N];
    float *dMatData, *dMatCols, *dMatRows, *dVec;

    size_t sA = sizeof(float),
    sB = sA * P * N,
    sRes = sA * M * N;
    sA *= M * P;

    cudaMalloc((void **) &dMatData, sA);
    cudaMalloc((void **) &dMatCols, sB);
    cudaMalloc((void **) &dMatRows, sRes);
    cudaMalloc((void **) &dVec, sRes);

    cudaMemcpy(dA, matA, sA, cudaMemcpyHostToDevice);
    cudaMemcpy(dB, matB, sB, cudaMemcpyHostToDevice);

    mulCSR<<<1, M>>>(dA, dB, dRes, M, N, P);
    cudaMemcpy(matRes, dRes, sRes, cudaMemcpyDeviceToHost);
    printf("Row-wise:\n");
    printMatf((float *) matRes, M, N);

    cudaFree(matA);
    cudaFree(matB);
    cudaFree(matRes);
    printf("Rachit 54\n");
    return 0;
}