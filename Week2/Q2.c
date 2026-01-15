#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
    int rank, size, val = 0;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status stat;

    if(rank == 0) {
        for(int i = 1; i < size; i++) {
            val += 2;
            MPI_Send(&val, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
        }
    }
    else {
        MPI_Recv(&val, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &stat);
        printf("P%d val: %d\n", rank, val);
    }

    if(rank == 0)
        printf("Rachit 230962294\n");
    MPI_Finalize();
    return 0;
}