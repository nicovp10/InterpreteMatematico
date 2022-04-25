#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

#include "system.h"
#include "nicalc.h"
#include "lex.yy.h"
#include "bison.tab.h"
#include "xestionErros.h"
#include "taboaSimbolos.h"


int varEcho = 1;


double clear() {
    system("clear");
    return 0;
}

double sair() {
    printf("    Saíndo do programa...\n\n");
    finalizarTS();
    exit(EXIT_SUCCESS);
}

double axuda() {
    printf("    Aquí iría a axuda\n\n");
    return 0;
}

double echo() {
    if (varEcho == 1) {
        varEcho = 0;
    } else {
        varEcho = 1;
    }
    cambiarEcho(varEcho);
    return 0;
}

double taboa() {
    imprimirTS();
    return 0;
}

double workspace() {
    imprimirWS();
    return 0;
}

double limparws() {
    return 0;
}

double cargar(char *ficheiro) {
    yyin = fopen(ficheiro, "r");

    if (yyin == NULL) {
        lanzarErro(FICHEIRO_NON_ATOPADO);
        yyin = stdin;
    } else {
        executandoScript(1);
    }

    return 0;
}

double importar(char *libreria) {
    void *lib = dlopen(libreria, RTLD_LAZY);

    if (lib == NULL) {
        printf(ROJO"Erro: apertura de librería fallida.\n\tDetalles: %s"RESET"\n\n", dlerror());
    } else {
        engadirLib(lib);
    }

    return 0;
}