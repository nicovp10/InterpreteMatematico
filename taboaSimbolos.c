#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

#include "taboaSimbolos.h"
#include "bison.tab.h"
#include "avl.h"
#include "system.h"


avl TS;

int num_variables = 0;


// Función auxiliar que realiza un recorrido inorde da árbore, imprimindo tod o contido
void _auxImprimirTS(avl A) {
    tipoelem E;
    if (!vacia(A)) {
        _auxImprimirTS(izq(A));
        ler(A, &E);
        switch (E.comp_lexico) {
            case VAR:
                printf("    %-5s\t\t     %-5s\t\t%-5lf\n", "Variable", E.lexema, E.valor.var);
                break;
            case CONST:
                printf("    %-5s\t\t     %-5s\t\t%-5lf\n", "Constante", E.lexema, E.valor.var);
                break;
            case FUNC:
                printf("    %-5s\t\t     %-5s\t\t%-5s\n", "Función", E.lexema, "---");
                break;
            case LIB:
                printf("    %-5s\t\t     %-5s\t\t%-5s\n", "Librería", E.lexema, "---");
                break;
            default:
                printf("    %-5s\t\t     %-5s\t\t%-5s\n", "Comando", E.lexema, "---");
                break;
        }
        _auxImprimirTS(der(A));
    }
}

// Función auxiliar que realiza un recorrido inorde da árbore, imprimindo só as variables
void _auxImprimirWS(avl A) {
    tipoelem E;
    if (!vacia(A)) {
        _auxImprimirWS(izq(A));
        ler(A, &E);
        if (E.comp_lexico == VAR) {
            printf("    %-5s\t\t%-5lf\n", E.lexema, E.valor.var);
        }
        _auxImprimirWS(der(A));
    }
}

// Función auxiliar que realiza a eliminación recursiva dunha variable da táboa de símbolos
void _auxEliminarVariable(avl A, int *atopada) {
    tipoelem E;
    if (!vacia(A) && !*atopada) {
        _auxEliminarVariable(izq(A), atopada);
        ler(A, &E);
        if (E.comp_lexico == VAR && !*atopada) {
            eliminar_nodo(&TS, E);
            *atopada = 1;
        }
        if (!*atopada) {
            _auxEliminarVariable(der(A), atopada);
        }
    }
}

// Función auxiliar que realiza a chamada á función recursiva para eliminar unha variable da táboa de símbolos
void _eliminarVariable() {
    int atopada = 0;
    _auxEliminarVariable(TS, &atopada);
}


// Función que inicia a táboa de símbolos
void iniciarTS() {
    tipoelem inicializacion[] = {
            {CONST, "pi", .valor.var=3.14159265358979323846},
            {CONST, "e", .valor.var=2.7182818284590452354},
            {CMND0, "clear", .valor.funcptr=clear},
            {CMND0, "sair", .valor.funcptr=sair},
            {CMND0, "axuda", .valor.funcptr=axuda},
            {CMND0, "echo", .valor.funcptr=echo},
            {CMND0, "taboa", .valor.funcptr=taboa},
            {CMND0, "ws", .valor.funcptr=ws},
            {CMND0, "limparws", .valor.funcptr=limparws},
            {CMND1, "cargar", .valor.funcptr=cargar},
            {CMND1, "importar", .valor.funcptr=importar},
    };

    crear(&TS);
    for (int i = 0; i < (sizeof(inicializacion) / sizeof(tipoelem)); i++) {
        insertar_nodo(&TS, inicializacion[i]);
    }
}

// Función que busca un lexema concreto na táboa de símbolos.
//  Se o lexema está na táboa, devolve o seu compoñente léxico.
//  Se o lexema non está na táboa, devolve NULL.
CompLexico buscarLexema(char *lexema) {
    tipoelem comp_busqueda = {0, NULL};
    buscar_nodo(TS, lexema, &comp_busqueda);
    return comp_busqueda;
}

// Función que busca unha función concreta na táboa de símbolos.
//  Se a función está na táboa, devolve o seu compoñente léxico.
//  Se a función non está na táboa, búscase se está na librería
//      indicada e, de ser así, insértase na táboa de símbolos.
//  Se a función non está na táboa nin na librería, devolve NULL.
CompLexico buscarFuncion(void *lib, char *lexema_funcion, char *libfunc) {
    tipoelem comp_busqueda = {0, NULL};
    buscar_nodo(TS, lexema_funcion, &comp_busqueda);
    if (comp_busqueda.lexema == NULL) {
        void (*funcion)(void);
        *(void **) (&funcion) = dlsym(lib, lexema_funcion);
        if (funcion) {
            comp_busqueda.comp_lexico = FUNC;
            comp_busqueda.lexema = libfunc;
            comp_busqueda.valor.funcptr = (double (*)()) funcion;
            insertar_nodo(&TS, comp_busqueda);
        }
    }
    return comp_busqueda;
}

// Función que inserta un compoñente léxico na táboa de símbolos
void insertar(CompLexico comp) {
    if (comp.comp_lexico == VAR) {
        num_variables++;
    }
    insertar_nodo(&TS, comp);
}

// Función que modifica o valor de variable dun compoñente léxico na táboa de símbolos
void modificarValorVariable(char *lexema, double valor) {
    tipoelem comp_busqueda = {0, NULL};

    // Busca na TS un lexema concreto devolvéndoo en comp_busqueda
    buscar_nodo(TS, lexema, &comp_busqueda);
    if (comp_busqueda.lexema != NULL) { // Se está na TS, modifícase o valor
        modificar_nodo(&TS, lexema, valor);
    }
}

// Función que elimina todas as variables da táboa de símbolos
void eliminarWS() {
    for (int i = 0; i < num_variables; i++) {
        _eliminarVariable();
    }
    num_variables = 0;
}

// Función que finaliza a táboa de símbolos
void finalizarTS() {
    destruir(&TS);
}

// Función que imprime a táboa de símbolos por orde alfabético dos lexemas
void imprimirTS() {
    printf("============================================================\n"
           "\t\t     TÁBOA DE SÍMBOLOS\n"
           "============================================================\n"
           "    %-5s\t\t     %-5s\t\t%-5s\n"
           "============================================================\n", "Tipo", "Lexema", "Valor");
    _auxImprimirTS(TS);
    printf("============================================================\n\n");
}

// Función que imprime as variables da táboa de símbolos por orde alfabético dos lexemas
void imprimirWS() {
    printf("=======================================\n"
           "\t     WORKSPACE\n"
           "=======================================\n"
           "    %-5s\t\t%-5s\n"
           "=======================================\n", "Lexema", "Valor");
    _auxImprimirWS(TS);
    printf("=======================================\n\n");
}