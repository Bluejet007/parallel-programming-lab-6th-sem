#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
    int rank, size;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status stat;

    if(rank == 0) {
        int data[4] = {1, 4, 2, 3}, _;
        int *buff = malloc(MPI_BSEND_OVERHEAD + 4 * sizeof(int));
        MPI_Buffer_attach(buff, 4);

        for(int i = 1; i < size; i++)
            MPI_Bsend(data + (i - 1) % 4, 1, MPI_INT, i, 0, MPI_COMM_WORLD);

        MPI_Buffer_detach(buff, &_);
        free(buff);
    }
    else {
        int val;
        MPI_Recv(&val, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &stat);

        if(rank % 2)
            val *= val * val;
        else
            val *= val;

        printf("P%d val: %d\n", rank, val);
    }

    if(rank == 0)
        printf("Rachit 230962294\n");
    MPI_Finalize();
    return 0;
}