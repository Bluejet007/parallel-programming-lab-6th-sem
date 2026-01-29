#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
    int rank, size, m;
    float *mat, *arr, res;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(!rank) {
        scanf("%d", &m);
        mat = calloc(size * m, sizeof(float));

        for(int i = 0; i < size * m; i++)
            scanf("%f", &mat[i]);
    }

    MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
    arr = calloc(m, sizeof(float));
    MPI_Scatter(mat, m, MPI_FLOAT, arr, m, MPI_FLOAT, 0, MPI_COMM_WORLD);

    for(int i = 1; i < m; i++)
        arr[0] += arr[i];
    arr[0] /= m;
    MPI_Reduce(&arr[0], &res, 1, MPI_FLOAT, MPI_SUM, 0, MPI_COMM_WORLD);

    if(!rank) {
        res /= size;
        printf("Final val: %f\n", res);
        printf("Rachit 230962294\n");
    }

    MPI_Finalize();
    return 0;
}