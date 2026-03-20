#include <cuda.h>
#include <stdio.h>

#define M 3
#define N 3

__global__ void mulCSR(float *matData, float *vec, float *res, uint *cols, uint *rows, uint rLen) {
    uint i = blockDim.x * blockIdx.x + threadIdx.x;

    if(i < rLen - 1) {
        float acc = 0.0f;
        for(uint k = rows[i]; k < rows[i + 1]; k++)
            acc += matData[k] * vec[cols[k]];

        res[i] = acc;
    }
}

void printArrf(float *arr, unsigned int len) {
    for(unsigned int i = 0; i < len; i++)
        printf("%.0f ", arr[i]);
    printf("\n");
}

int main() {
    float matData[] = {1, 2, 3, 4, 5, 6},
    vec[] = {2, 3, 4},
    res[N];
    uint cols[] = {0, 2, 0, 1, 2, 2},
    rows[] = {0, 2, 5, 6};

    float *dMatData, *dVec, *dRes;
    uint *dCols, *dRows;

    size_t sData = sizeof(float),
    sVec = sData * N,
    sCols = sizeof(int),
    sRows = sCols * 4;
    sData *= 6;
    sCols *= 6;

    cudaMalloc((void **) &dMatData, sData);
    cudaMalloc((void **) &dVec, sVec);
    cudaMalloc((void **) &dRes, sVec);
    cudaMalloc((void **) &dCols, sData);
    cudaMalloc((void **) &dRows, sCols);

    cudaMemcpy(dMatData, matData, sData, cudaMemcpyHostToDevice);
    cudaMemcpy(dVec, vec, sVec, cudaMemcpyHostToDevice);
    cudaMemcpy(dCols, cols, sCols, cudaMemcpyHostToDevice);
    cudaMemcpy(dRows, rows, sRows, cudaMemcpyHostToDevice);

    mulCSR<<<1, M>>>(dMatData, dVec, dRes, dCols, dRows, 4);
    cudaMemcpy(res, dRes, sVec, cudaMemcpyDeviceToHost);
    printf("Result: ");
    printArrf((float *) res, N);

    cudaFree(dMatData);
    cudaFree(dVec);
    cudaFree(dRes);
    cudaFree(dCols);
    cudaFree(dRows);

    printf("Rachit 54\n");
    return 0;
}