#include <stdio.h>

#include "xestionErros.h"

#define ROJO "\x1b[31m"
#define RESET "\x1b[0m"


// Función que dado un código de erro imprime por pantalla unha mensaxe concreta
void lanzarErro(int codigo) {
    switch (codigo) {
        case FICHEIRO_NON_ATOPADO:
            printf(ROJO"\nErro: non se atopou o ficheiro indicado.\n\n"RESET);
            break;
        case LEXEMA_DESCONOCIDO:
            printf(ROJO"\nErro: lexame non recoñecido.\n\tDetalles: o lexema non corresponde a ningún compoñente léxico.\n\n"RESET);
            break;
        case VARIABLE_NON_DEFINIDA:
            printf(ROJO"\nErro: variable non definida.\n\tDetalles: non se visualizar o contido dunha variable sen antes asignarlle un valor.\n\n"RESET);
            break;
        case DIV_CERO:
            printf(ROJO"\nErro: divisón por cero.\n\tDetalles: non se pode realizar unha división na cal o divisor sexa 0.\n\n"RESET);
            break;
        case MOD_CERO:
            printf(ROJO"\nErro: módulo por cero.\n\tDetalles: non se pode realizar un módulo no cal o divisor sexa 0.\n\n"RESET);
            break;
    }
}