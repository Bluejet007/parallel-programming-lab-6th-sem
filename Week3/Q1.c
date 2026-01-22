#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
    int rank, size, *arr, val, res = 1;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status stat;


    if(!rank) {
        arr = calloc(size, sizeof(int));
        for(int i = 0; i < size; i++)
            scanf("%d", &arr[i]);
    }

    MPI_Scatter(arr, 1, MPI_INT, &val, 1, MPI_INT, 0, MPI_COMM_WORLD);

    for(int i = 2; i <= val; i++)
        res *= i;

    MPI_Reduce(&res, &val, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    if(!rank) {
        printf("Final val: %d\n", val);
        printf("Rachit 230962294\n");
    }

    MPI_Finalize();
    return 0;
}