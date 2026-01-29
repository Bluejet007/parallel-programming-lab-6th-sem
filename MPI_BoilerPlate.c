#include <stdio.h>
#include <mpi.h>
#define MCW MPI_COMM_WORLD

int errHandler(int errCode, int rank) {
    char errStr[MPI_MAX_ERROR_STRING];
    int errClass, errLen;

    switch (errCode) {
    case MPI_SUCCESS:
        return 0;
    default:
        MPI_Error_class(errCode, &errClass);
        MPI_Error_string(errCode, errStr, &errLen);
        printf("P%d: %s\n", rank, errStr);
        return 1;
    }
}

int main(int argc, char *argv[]) {
    int rank, size;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MCW, &rank);
    MPI_Comm_size(MCW, &size);

    /* Code here */

    if(!rank)
        printf("Rachit 230962294\n");
    MPI_Finalize();
    return 0;
}