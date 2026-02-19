#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void oddEvenSort(float *arr, unsigned int len, bool isOdd) {
    int i =  blockDim.x * blockIdx.x + threadIdx.x;

    if(i < len && i % 2 == isOdd) {
        float temp;
        if(arr[i] > arr[i + 1]) {
            temp = arr[i];
            arr[i] = arr[i + 1];
            arr[i + 1] = temp;
        }
    }
}

void printArrf(float *arr, unsigned int len) {
    for(unsigned int i = 0; i < len; i++)
        printf("%.0f ", arr[i]);
    printf("\n");
}

int main() {
    float *arr;
    float *dArr;
    int n;

    printf("Array size: ");
    scanf("%d", &n);
    size_t len = sizeof(float) * n;

    arr = (float *) malloc(len);
    for(int i = 0; i < n; i++)
        arr[i] = rand() % 100;

    printf("Unsorted:\n");
    printArrf(arr, n);
    
    cudaMalloc((void **) &dArr, len);
    cudaMemcpy(dArr, arr, len, cudaMemcpyHostToDevice);

    for(int i = 0; i < n; i++) {
        oddEvenSort<<<(len - 1) / 256 + 1, 256>>>(dArr, n, i % 2);
        cudaDeviceSynchronize();
    }
    cudaMemcpy(arr, dArr, len, cudaMemcpyDeviceToHost);

    printf("Sorted:\n");
    printArrf(arr, n);

    cudaFree(dArr);

    printf("Rachit 54\n");
    return 0;
}