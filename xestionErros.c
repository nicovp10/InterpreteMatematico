#include <stdio.h>

#include "xestionErros.h"
#include "nicalc.h"


// Función que dado un código de erro imprime por pantalla unha mensaxe concreta
void lanzarErro(int codigo) {
    switch (codigo) {
        case SINTAXE_NON_VALIDA:
            printf(ROJO"Erro: sintaxe non válida. Execute de novo o intérprete coa opción '-h' para máis información sobre o mesmo."RESET"\n\n");
            break;
        case FICHEIRO_NON_ATOPADO:
            printf(ROJO"Erro: non se atopou o ficheiro indicado."RESET"\n\n");
            break;
        case FICHEIRO_NON_INDICADO:
            printf(ROJO"Erro: non se indicou o ficheiro necesario para a execución do comando."RESET"\n\n");
            break;
        case FICHEIRO_MAL_FORMATO:
            printf(ROJO"Erro: ficheiro indicado con mal formato.\n\tDetalles: o ficheiro debe ter extensión e polo menos unha letra a cada lado do punto."RESET"\n\n");
            break;
        case LIBRERIA_NON_ATOPADA:
            printf(ROJO"Erro: non se atopou a librería indicada.\n\tDetalles: comproba se antes de invocar a función importaches dita librería."RESET"\n\n");
            break;
        case FUNCION_NON_ATOPADA:
            printf(ROJO"Erro: non se atopou a función indicada.\n\tDetalles: comproba se a función existe na librería indicada."RESET"\n\n");
            break;
        case PARAMETROS_NON_INDICADOS:
            printf(ROJO"Erro: parámetros non indicados.\n\tDetalles: non se indicaron parámetros para a función indicada."RESET"\n\n");
            break;
        case LEXEMA_DESCONOCIDO:
            printf(ROJO"Erro: lexema non recoñecido.\n\tDetalles: o lexema non corresponde a ningún compoñente léxico."RESET"\n\n");
            break;
        case NAN_DETECTADO:
            printf(ROJO"Erro: NaN detectado.\n\tDetalles: debido a algún fallo nalgunha operación da sentencia detectouse un NaN (Not a Number)."RESET"\n\n");
            break;
        case VARIABLE_NON_DEFINIDA:
            printf(ROJO"Erro: variable non definida.\n\tDetalles: non se pode usar unha variable sen antes asignarlle un valor."RESET"\n\n");
            break;
        case CONSTANTE_NON_MODIFICABLE:
            printf(ROJO"Erro: constante non modificable.\n\tDetalles: as constantes predifinidas non poden ser modificadas."RESET"\n\n");
            break;
        case DIV_CERO:
            printf(ROJO"Erro: divisón por cero.\n\tDetalles: non se pode realizar unha división na cal o divisor sexa 0."RESET"\n\n");
            break;
        case MOD_CERO:
            printf(ROJO"Erro: módulo por cero.\n\tDetalles: non se pode realizar un módulo no cal o divisor sexa 0."RESET"\n\n");
            break;
    }
}