#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>
#define MCW MPI_COMM_WORLD

int main(int argc, char* argv[]) {
    int rank, size, len;
    char lett, inp[32], *subs, *final;
    int stat;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MCW, &rank);
    MPI_Comm_size(MCW, &size);

    if(!rank) {
        scanf("%s", inp);
        len = strlen(inp);
        final = calloc(size * len, sizeof(char));
    }

    MPI_Bcast(&len, 1, MPI_INT, 0, MCW);
    MPI_Scatter(inp, 1, MPI_CHAR, &lett, 1, MPI_CHAR, 0, MCW);

    subs = calloc(len, sizeof(char));
    for(int i = 0; i < len; i++)
        if(i <= rank)
            subs[i] = lett;

    MPI_Gather(subs, len, MPI_CHAR, final, len, MPI_CHAR, 0, MCW);

    if(!rank) {
        printf("Res: ");
        for(int i = 0; i < size * len; i++)
            final[i] ? printf("%c", final[i]) : 0;

        printf("\nRachit 230962294\n");
    }

    MPI_Finalize();
    return 0;
}