#include <stdio.h>
#include <mpi.h>

int powi(int x, int y) {
    int res = 1;
    for(int i = 0; i < y; i++)
        res *= x;

    return res;
}

int main(int argc, char* argv[]) {
    int rank, size;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    printf("Val of P%d: %d\n", rank, powi(size, rank));
    
    if(rank % 2)
        printf("World\n");
    else
        printf("Hello\n");

    if(rank == 0)
        printf("Rachit 230962294\n");
    MPI_Finalize();
    return 0;
}