#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
    int rank, res = 1;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if(rank % 2) {
        if(rank < 3)
            res = rank;
        else {
            int a = 0, b = 1;

            for(int i = 2; i <= rank; i++) {
                res = a + b;
                a = b;
                b = res;
            }
        }
    }
    else {
        for(int i = 2; i <= rank; i++)
            res *= i;
    }

    printf("P%d: %d\n", rank, res);

    if(rank == 0)
        printf("Rachit 230962294\n");
    MPI_Finalize();
    return 0;
}