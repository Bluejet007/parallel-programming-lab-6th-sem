#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <string.h>

int main(int argc, char* argv[]) {
    int rank, size, len;
    char *myStr;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;

    if(rank == 0) {
        myStr = strdup("Hello");
        len = strlen(myStr);

        MPI_Ssend(&len, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
        MPI_Ssend(myStr, len, MPI_CHAR, 1, 1, MPI_COMM_WORLD);

        MPI_Recv(myStr, len, MPI_CHAR, 1, 2, MPI_COMM_WORLD, &status);
        printf("%s\n", myStr);
    }
    else if(rank == 1) {
        MPI_Recv(&len, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
        myStr = calloc(len, sizeof(char));

        MPI_Recv(myStr, len, MPI_CHAR, 0, 1, MPI_COMM_WORLD, &status);
        for(int i = 0; i < len; i++) {
            if(myStr[i] > 96)
                myStr[i] -= 32;
            else
                myStr[i] += 32;
        }

        MPI_Ssend(myStr, len, MPI_CHAR, 0, 2, MPI_COMM_WORLD);
    }

    if(rank == 0)
        printf("Rachit 230962294\n");
    MPI_Finalize();
    return 0;
}