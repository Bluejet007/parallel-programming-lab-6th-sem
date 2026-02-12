#include <stdio.h>
#include <cuda.h>

#define N 50

__global__ void mySin(float *a, float *b) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;

    b[tid] = sinf(a[tid]);
}

int main() {
    float a[N], b[N];
    float *dA, *dB;
    size_t size = sizeof(float) * N;
    for(int i = 0; i < N; i++)
        a[i] = i;

    cudaMalloc((void **) &dA, size);
    cudaMalloc((void **) &dB, size);

    cudaMemcpy(dA, a, size, cudaMemcpyHostToDevice);

    mySin<<<(N - 1) / 256 + 1, 256>>>(dA, dB);
    cudaMemcpy(b, dB, size, cudaMemcpyDeviceToHost);
    
    printf("Result:\n");
    for(int i = 0; i < N; i++)
        printf("%f ", b[i]);
    printf("\n");

    cudaFree(dA);
    cudaFree(dB);

    printf("Rachit 54\n");
    return 0;
}