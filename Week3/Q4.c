#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
    int rank, size, len;
    char inp1[32], inp2[32], *subs, *final;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(!rank) {
        gets(inp1);
        gets(inp2);

        len = strlen(inp1);
        final = calloc(2 * len, sizeof(char));
    }

    MPI_Bcast(&len, 1, MPI_INT, 0, MPI_COMM_WORLD);
    len /= size;

    subs = calloc(2 * len, sizeof(char));
    MPI_Scatter(inp1, len, MPI_CHAR, subs, len, MPI_CHAR, 0, MPI_COMM_WORLD);
    MPI_Scatter(inp2, len, MPI_CHAR, subs + len, len, MPI_CHAR, 0, MPI_COMM_WORLD);

    MPI_Gather(subs, len * 2, MPI_CHAR, final, len * 2, MPI_CHAR, 0, MPI_COMM_WORLD);

    if(!rank) {
        printf("Str: %s\n", final);
        printf("Rachit 230962294\n");
    }

    MPI_Finalize();
    return 0;
}