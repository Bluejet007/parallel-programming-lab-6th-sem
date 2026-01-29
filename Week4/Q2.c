#include <stdio.h>
#include <mpi.h>
#define MCW MPI_COMM_WORLD

int main(int argc, char* argv[]) {
    int rank, val, final, count = 0;
    int mat[3][3], arr[3];
    int stat;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MCW, &rank);

    if(!rank) {
        for(int i = 0; i < 3; i++)
            for(int j = 0; j < 3; j++)
                scanf("%d", &mat[i][j]);

        scanf("%d", &val);
    }
    
    MPI_Bcast(&val, 1, MPI_INT, 0, MCW);
    MPI_Scatter(mat, 3, MPI_INT, arr, 3, MPI_INT, 0, MCW);

    for(int i = 0; i < 3; i++)
        if(arr[i] == val)
            count++;

    MPI_Reduce(&count, &final, 1, MPI_INT, MPI_SUM, 0, MCW);

    if(!rank) {
        printf("Amount: %d\n", final);
        printf("Rachit 230962294\n");
    }

    MPI_Finalize();
    return 0;
}