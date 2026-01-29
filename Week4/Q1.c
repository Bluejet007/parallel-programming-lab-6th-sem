#include <stdio.h>
#include <math.h>
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
    int rank, size, len, sum, fact = 1;
    int stat;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MCW, &rank);
    MPI_Comm_size(MCW, &size);
    MPI_Comm_set_errhandler(MCW, MPI_ERRORS_RETURN);

    for(int i = 1; i <= rank; i++)
        fact *= i;

    stat = MPI_Scan(&fact, &sum, 1, MPI_INT, MPI_SUM, MCW);
    errHandler(stat, rank);

    if(!rank)
        printf("Rachit 230962294\n");
    else if(rank == size - 1)
        printf("Sum of %d factorials: %d\n", size, sum);

    MPI_Finalize();
    return 0;
}