#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
    int rank, size, val;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status stat;

    if(!rank) {
        scanf("%d", &val);
        val++;
        MPI_Ssend(&val, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);

        MPI_Recv(&val, 1, MPI_INT, size - 1, 0, MPI_COMM_WORLD, &stat);
        printf("Final val: %d\n", val);
    }
    else {
        MPI_Recv(&val, 1, MPI_INT, rank - 1, 0, MPI_COMM_WORLD, &stat);
        val++;
        MPI_Ssend(&val, 1, MPI_INT, (rank + 1) % size, 0, MPI_COMM_WORLD);
    }

    if(rank == 0)
        printf("Rachit 230962294\n");
    MPI_Finalize();
    return 0;
}