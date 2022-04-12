#ifndef XESTIONERROS_H
#define XESTIONERROS_H


#define FICHEIRO_NON_ATOPADO 1
#define LEXEMA_DESCONOCIDO 2
#define FLOAT_EXPO_MAL_FORMADO 3
#define IMAGINARY_MAL_FORMADO 4
#define RUNA_MOITOS_CARACTERES 5
#define RUNA_NON_PECHADA 6
#define STRING_NON_PECHADO 7
#define COMENTARIO_MULTILINEA_NON_PECHADO 8


// Función que dado un código de erro imprime por pantalla unha mensaxe concreta
void lanzarErro(int linea, int codigo);


#endif
