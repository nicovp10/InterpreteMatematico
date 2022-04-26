#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

#include "system.h"
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
    printf(AMARILLO"Saíndo do programa..."RESET"\n\n");
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

double ws() {
    imprimirWS();
    return 0;
}

double limparws() {
    eliminarWS();
    printf(AMARILLO"Espazo de traballo limpado correctamente.\n\n"RESET);
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
    char *nome_lib = NULL, *lexema;
    if (lib == NULL) {
        printf(ROJO"Erro: apertura de librería fallida.\n\tDetalles: %s"RESET"\n\n", dlerror());
    } else {
        for (int i = ((int) (strlen(libreria) - 1)); i >= 0; i--) {
            if (libreria[i] == '/') {
                nome_lib = &libreria[i + 1];
                break;
            }
        }
        if (nome_lib == NULL) {
            nome_lib = libreria;
        }
        lexema = strtok(nome_lib, ".");
        CompLexico comp_lib = {LIB, lexema, .valor.libhandle=lib};
        insertar(comp_lib);
        printf(AMARILLO"Librería cargada correctamente.\n\n"RESET);
    }

    return 0;
}