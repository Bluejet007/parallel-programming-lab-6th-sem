#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
    int rank, size, len, *buff, acc = 0;
    char inp[32], *subs;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(!rank) {
        gets(inp);
        len = strlen(inp);
        buff = calloc(size, sizeof(int));
    }

    MPI_Bcast(&len, 1, MPI_INT, 0, MPI_COMM_WORLD);
    len /= size;

    subs = calloc(len, sizeof(char));
    MPI_Scatter(inp, len, MPI_CHAR, subs, len, MPI_CHAR, 0, MPI_COMM_WORLD);

    for(int i = 0; i < len; i++)
        switch (subs[i]) {
        case 'a':
        case 'e':
        case 'i':
        case 'o':
        case 'u':
            break;
        
        default:
            acc++;
            break;
        }

    MPI_Gather(&acc, 1, MPI_INT, buff, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if(!rank) {
        acc = 0;
        for(int i = 0; i < size; i++) {
            printf("P%d count: %d\n", i, buff[i]);
            acc += buff[i];
        }

        printf("Final val: %d\n", acc);
        printf("Rachit 230962294\n");
    }

    MPI_Finalize();
    return 0;
}