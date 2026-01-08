#include <stdio.h>
#include <mpi.h>

char inp[] = "HELLO";

int main(int argc, char* argv[]) {
    int rank;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if(inp[rank] > 96)
        inp[rank] -= 32;
    else
        inp[rank] += 32;

    printf("%s\n", inp);
    if(rank == 0)
        printf("Rachit 230962294\n");
    MPI_Finalize();
    return 0;
}