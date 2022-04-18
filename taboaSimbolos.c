#include <stdio.h>
#include <string.h>

#include "taboaSimbolos.h"
#include "avl.h"
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
            {NUM,                   "pi", .valor.var=3.14159265358979323846},
            {NUM,                   "e", .valor.var=2.7182818284590452354},
            {COMANDO_SEN_PARAMETRO, "sair()", .valor.funcptr=sair},
            {COMANDO_SEN_PARAMETRO, "axuda()", .valor.funcptr=axuda},
            {COMANDO_CON_PARAMETRO, "echo()", .valor.funcptr=echo},
            {COMANDO_SEN_PARAMETRO, "taboa()", .valor.funcptr=taboa},
            {COMANDO_SEN_PARAMETRO, "workspace()", .valor.funcptr=workspace},
            {COMANDO_SEN_PARAMETRO, "limpar()", .valor.funcptr=limpar},
            {COMANDO_CON_PARAMETRO, "cargar()", .valor.funcptr=cargar},
            {COMANDO_CON_PARAMETRO, "importar()", .valor.funcptr=importar},
    };

    crear(&TS);
    for (int i = 0; i < (sizeof(inicializacion) / sizeof(tipoelem)); i++) {
        insertar(&TS, inicializacion[i]);
    }
}

// Función que busca un compoñente léxico concreto na táboa de símbolos
//  Se este compoñente léxico non está na táboa, insértao
void buscar_insertar(CompLexico *comp) {
    tipoelem comp_busqueda = {0, NULL};

    // Busca na TS un lexema concreto devolvéndoo en comp_busqueda
    buscar_nodo(TS, comp->lexema, &comp_busqueda);
    if (comp_busqueda.lexema == NULL) { // Se non está na TS, insértase e devólvese
        comp->comp_lexico = VAR;
        insertar(&TS, *comp);
    } else {                            // Se está na TS, devólvese o atopado
        comp->comp_lexico = comp_busqueda.comp_lexico;
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