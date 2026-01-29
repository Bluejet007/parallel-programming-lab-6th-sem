#include <stdio.h>
#include <mpi.h>
#define MCW MPI_COMM_WORLD

int main(int argc, char* argv[]) {
    int rank;
    int mat[4][4], arr[4], sumArr[4];
    int stat;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MCW, &rank);

    if(!rank)
        for(int i = 0; i < 4; i++)
            for(int j = 0; j < 4; j++)
                scanf("%d", &mat[i][j]);
    
    MPI_Scatter(mat, 4, MPI_INT, arr, 4, MPI_INT, 0, MCW);
    MPI_Scan(arr, sumArr, 4, MPI_INT, MPI_SUM, MCW);

    MPI_Gather(sumArr, 4, MPI_INT, mat, 4, MPI_INT, 0, MPI_COMM_WORLD);

    if(!rank) {
        printf("Result:\n");
        for(int i = 0; i < 4; i++) {
            for(int j = 0; j < 4; j++)
                printf("%d ", mat[i][j]);
            printf("\n");
        }
        printf("Rachit 230962294\n");
    }

    MPI_Finalize();
    return 0;
}