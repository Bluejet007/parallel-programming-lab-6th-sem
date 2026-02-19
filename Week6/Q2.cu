#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void selectSort(float *arr, float *res, unsigned int len) {
    int i =  blockDim.x * blockIdx.x + threadIdx.x;


    if(i < len) {
        unsigned int rank = 0;
        for(unsigned int j = 0; j < len; j++)
            if(arr[i] > arr[j] || (arr[i] == arr[j] && j < i))
                rank++;

        res[rank] = arr[i];
    }
}

void printArrf(float *arr, unsigned int len) {
    for(unsigned int i = 0; i < len; i++)
        printf("%.0f ", arr[i]);
    printf("\n");
}

int main() {
    float *arr;
    float *dArr, *dRes;
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
    cudaMalloc((void **) &dRes, len);

    cudaMemcpy(dArr, arr, len, cudaMemcpyHostToDevice);

    selectSort<<<(len - 1) / 256 + 1, 256>>>(dArr, dRes, n);
    cudaMemcpy(arr, dRes, len, cudaMemcpyDeviceToHost);

    printf("Sorted:\n");
    printArrf(arr, n);

    cudaFree(dArr);
    cudaFree(dRes);

    printf("Rachit 54\n");
    return 0;
}