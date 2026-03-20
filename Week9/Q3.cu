#include <cuda.h>
#include <stdio.h>

#define M 4
#define N 4

__global__ void onesRow(float *aMat, uint m, uint n) {
    uint i = blockDim.x * blockIdx.x + threadIdx.x,
    j = blockDim.y * blockIdx.y + threadIdx.y;

    if(i * j > 0 && i < m - 1 && j < n - 1) {
        uint p = 1, bin = 0, val = aMat[i * n + j];

        while(val > 0) {
            uint bit = val & 1;
            bin += (bit ? 0 : 1) * p;
            
            val >>= 1;
            p *= 10;
        }

        aMat[i * n + j] = bin;
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
        {1, 2, 3, 4},
        {6, 5, 8, 3},
        {2, 4, 10, 1},
        {9, 1, 2, 5}
    };
    float *dA;

    size_t sA = sizeof(float) * M * N;

    cudaMalloc((void **) &dA, sA);

    cudaMemcpy(dA, matA, sA, cudaMemcpyHostToDevice);

    onesRow<<<1, dim3(M, N)>>>(dA, M, N);
    cudaMemcpy(matA, dA, sA, cudaMemcpyDeviceToHost);
    printf("Result:\n");
    printMatf((float *) matA, M, N);

    cudaFree(dA);
    printf("Rachit 54\n");
    return 0;
}