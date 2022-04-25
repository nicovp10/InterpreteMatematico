#ifndef XESTIONERROS_H
#define XESTIONERROS_H


#define FICHEIRO_NON_ATOPADO 1
#define FICHEIRO_NON_INDICADO 2
#define FICHEIRO_MAL_FORMATO 3
#define LEXEMA_DESCONOCIDO 4
#define NAN_DETECTADO 5
#define VARIABLE_NON_DEFINIDA 6
#define CONSTANTE_NON_MODIFICABLE 7
#define DIV_CERO 8
#define MOD_CERO 9


// Función que dado un código de erro imprime por pantalla unha mensaxe concreta
void lanzarErro(int codigo);


#endif
