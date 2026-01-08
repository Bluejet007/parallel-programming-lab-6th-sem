#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
    int rank;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    printf("P%d: Hello world!\n", rank);

    if(rank == 0)
        printf("Rachit 230962294\n");
    MPI_Finalize();
    return 0;
}