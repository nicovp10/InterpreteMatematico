#include <stdio.h>
#include <stdlib.h>

#include "nicalc.h"
#include "taboaSimbolos.h"


int main(int argc, char *argv[]) {
    iniciarTS();

    if (argc == 1) {
        nicalc(NULL);
    } else if (argc == 2) {
        nicalc(argv[1]);
    } else {
        printf(ROJO"Erro: número de parámetros incorrecto.\n\t"
                   "Detalles: débese chamar ao executable sen argumentos de entrada ou con un como máximo, o cal corresponderá"
                   "ao script a executar ao iniciar o intérprete."RESET"\n\n");
    }

    exit(EXIT_SUCCESS);
}
