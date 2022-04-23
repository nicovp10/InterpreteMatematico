#include <stdio.h>
#include <string.h>

#include "taboaSimbolos.h"
#include "avl.h"
#include "bison.tab.h"
#include "system.h"


avl TS;


// Función auxiliar que realiza un recorrido inorde da árbore
void _auxImprimir(avl A) {
    tipoelem E;
    if (!vacia(A)) {
        _auxImprimir(izq(A));
        ler(A, &E);
        if (E.comp_lexico == NUM || E.comp_lexico == VAR) {
            printf("\t< %d, %s\tValor = %lf >\n", E.comp_lexico, E.lexema, E.valor.var);
        } else if (E.comp_lexico == FUNC){
            printf("\t< %d, %s\tFunción>\n", E.comp_lexico, E.lexema);
        } else {
            printf("\t< %d, %s\tComando do sistema>\n", E.comp_lexico, E.lexema);
        }
        _auxImprimir(der(A));
    }
}

// Función que inicia a táboa de símbolos
void iniciarTS() {
    tipoelem inicializacion[] = {
            {CONST,                   "pi", .valor.var=3.14159265358979323846},
            {CONST,                   "e", .valor.var=2.7182818284590452354},
            {CMND0, "sair", .valor.funcptr=sair},
            {CMND0, "axuda", .valor.funcptr=axuda},
            {CMND1, "echo", .valor.funcptr=echo},
            {CMND0, "taboa", .valor.funcptr=taboa},
            {CMND0, "workspace", .valor.funcptr=workspace},
            {CMND0, "limpar", .valor.funcptr=limpar},
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
//  Se o lexema non está na táboa, devolve NULL
CompLexico buscar(char *lexema) {
    tipoelem comp_busqueda = {0, NULL};
    buscar_nodo(TS, lexema, &comp_busqueda);
    return comp_busqueda;
}

// Función que busca un compoñente léxico concreto na táboa de símbolos
//  Se este compoñente léxico non está na táboa, insértao
void buscar_insertar(CompLexico *comp) {
    tipoelem comp_busqueda = {0, NULL};

    // Busca na TS un lexema concreto devolvéndoo en comp_busqueda
    buscar_nodo(TS, comp->lexema, &comp_busqueda);
    if (comp_busqueda.lexema == NULL) { // Se non está na TS, insértase e devólvese
        comp->comp_lexico = VAR;
        insertar_nodo(&TS, *comp);
    } else {                            // Se está na TS, devólvese o atopado
        comp->comp_lexico = comp_busqueda.comp_lexico;
        switch (comp->comp_lexico) {
            case FUNC:
            case CMND0:
            case CMND1:
                comp->valor.funcptr = comp_busqueda.valor.funcptr;
                break;
            case VAR:
            case NUM:
                comp->valor.var = comp_busqueda.valor.var;
                break;
        }
    }
}

// Función que inserta un compoñente léxico na árbore
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
    printf("\n\n----- TÁBOA DE SÍMBOLOS -----\n");
    _auxImprimir(TS);
    printf("-----------------------------\n\n\n");
}