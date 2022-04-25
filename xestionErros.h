#ifndef XESTIONERROS_H
#define XESTIONERROS_H


#define FICHEIRO_NON_ATOPADO 1
#define FICHEIRO_NON_INDICADO 2
#define FICHEIRO_MAL_FORMATO 3
#define FUNCION_NON_ATOPADA 4
#define LEXEMA_DESCONOCIDO 5
#define NAN_DETECTADO 6
#define VARIABLE_NON_DEFINIDA 7
#define CONSTANTE_NON_MODIFICABLE 8
#define DIV_CERO 9
#define MOD_CERO 10


// Función que dado un código de erro imprime por pantalla unha mensaxe concreta
void lanzarErro(int codigo);


#endif
