#include <stdio.h>
#include <dlfcn.h>

#include "taboaSimbolos.h"
#include "bison.tab.h"
#include "avl.h"
#include "system.h"


avl TS;
void *lib;


// Función auxiliar que realiza un recorrido inorde da árbore, imprimindo tod o contido
void _auxImprimirTS(avl A) {
    tipoelem E;
    if (!vacia(A)) {
        _auxImprimirTS(izq(A));
        ler(A, &E);
        if (E.comp_lexico == VAR) {
            printf("    %-5s\t\t     %-5s\t\t%-5lf\n", "Variable", E.lexema, E.valor.var);
        } else if (E.comp_lexico == CONST) {
            printf("    %-5s\t\t     %-5s\t\t%-5lf\n", "Constante", E.lexema, E.valor.var);
        } else if (E.comp_lexico == FUNC) {
            printf("    %-5s\t\t     %-5s\t\t%-5s\n", "Función", E.lexema, "---");
        } else if (E.comp_lexico == LIB) {
            printf("    %-5s\t\t     %-5s\t\t%-5s\n", "Librería", E.lexema, "---");
        } else {
            printf("    %-5s\t\t     %-5s\t\t%-5s\n", "Comando", E.lexema, "---");
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
            {CMND0, "workspace", .valor.funcptr=workspace},
            {CMND0, "limparws", .valor.funcptr=limparws},
            {CMND1, "cargar", .valor.funcptr=cargar},
            {CMND1, "importar", .valor.funcptr=importar},
    };

    crear(&TS);
    for (int i = 0; i < (sizeof(inicializacion) / sizeof(tipoelem)); i++) {
        insertar_nodo(&TS, inicializacion[i]);
    }
}

// Función que engade unha librería para o manexo das súas funcións
void engadirLib(void *libreria, char *lexema) {
    lib = libreria;
    tipoelem E = {LIB, lexema, .valor.libhandle=libreria};
    insertar_nodo(&TS, E);
}

// Función que busca un lexema concreto na táboa de símbolos.
//  Se o lexema está na táboa, devolve o seu compoñente léxico.
//  Se o lexema non está na táboa, búscase se está nunha librería e,
//      de ser así, insértase na táboa de símbolos.
//  Se o lexema non está na táboa nin nunha librería, devolve NULL.
CompLexico buscar(char *lexema) {
    tipoelem comp_busqueda = {0, NULL};
    buscar_nodo(TS, lexema, &comp_busqueda);
    if (comp_busqueda.lexema == NULL && lib != NULL) {
        void (*funcion)(void);
        *(void **) (&funcion) = dlsym(lib, lexema);
        if (funcion) {
            comp_busqueda.comp_lexico = FUNC;
            comp_busqueda.lexema = lexema;
            comp_busqueda.valor.funcptr = (double (*)()) funcion;
            insertar(comp_busqueda);
        }
    }
    return comp_busqueda;
}

// Función que inserta un compoñente léxico na táboa de símbolos
void insertar(CompLexico comp) {
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

// Función que elimina un compoñente léxico concreto da táboa de símbolos
void eliminar(CompLexico compLexico) {
    eliminar_nodo(&TS, compLexico);
}

// Función que finaliza a táboa de símbolos
void finalizarTS() {
    destruir(&TS);
}

// Función que imprime a táboa de símbolos por orde alfabético dos lexemas
void imprimirTS() {
    printf("============================================================\n");
    printf("\t\t     TÁBOA DE SÍMBOLOS\n");
    printf("============================================================\n");
    printf("    %-5s\t\t     %-5s\t\t%-5s\n", "Tipo", "Lexema", "Valor");
    printf("============================================================\n");
    _auxImprimirTS(TS);
    printf("============================================================\n\n");
}

// Función que imprime a táboa de símbolos por orde alfabético dos lexemas
void imprimirWS() {
    printf("=======================================\n");
    printf("\t     WORKSPACE\n");
    printf("=======================================\n");
    printf("    %-5s\t\t%-5s\n", "Lexema", "Valor");
    printf("=======================================\n");
    _auxImprimirWS(TS);
    printf("=======================================\n\n");
}