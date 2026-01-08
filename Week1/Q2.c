#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
    int a = 6, b = 3, res;
    int rank;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    switch (rank) {
    case 0:
        res = a + b;
        break;
    case 1:
        res = a - b;
        break;
    case 2:
        res = a * b;
        break;
    case 3:
        res = a / b;
        break;
    }

    printf("P%d: %d\n", rank, res);
    if(rank == 0)
        printf("Rachit 230962294\n");
    MPI_Finalize();
    return 0;
}