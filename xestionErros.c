#include <stdio.h>

#include "xestionErros.h"


// Función que dado un código de erro imprime por pantalla unha mensaxe concreta
void lanzarErro(int linea, int codigo) {
    switch (codigo) {
        case FICHEIRO_NON_ATOPADO:
            printf("\nErro: non se atopou o ficheiro de código fonte.\n\n");
            break;
        case LEXEMA_DESCONOCIDO:
            printf("\nErro na liña %d: lexame non recoñecido.\n\tDetalles: o lexema non corresponde a ningún compoñente léxico.\n\n", linea);
        case FLOAT_EXPO_MAL_FORMADO:
            printf("\nErro na liña %d: número en punto flotante mal formado.\n\tDetalles: expoñente mal formado\n\n", linea);
            break;
        case IMAGINARY_MAL_FORMADO:
            printf("\nErro na liña %d: número imaxinario mal formado.\n\tDetalles: esperábase a letra final 'i'\n\n", linea);
            break;
        case RUNA_MOITOS_CARACTERES:
            printf("\nErro na liña %d: runa con moitos caracteres.\n\tDetalles: as runas só poden conter un caracter\n\n", linea);
            break;
        case RUNA_NON_PECHADA:
            printf("\nErro na liña %d: runa non pechada.\n\tDetalles: esperábase o caracter de peche '\n\n", linea);
            break;
        case STRING_NON_PECHADO:
            printf("\nErro na liña %d: string non pechado.\n\tDetalles: esperábase o caracter de peche \" ou `\n\n", linea);
            break;
        case COMENTARIO_MULTILINEA_NON_PECHADO:
            printf("\nErro na liña %d: comentario multiliña non pechado.\n\tDetalles: esperábanse os caracteres de peche '*\\'\n\n", linea);
            break;
    }
}