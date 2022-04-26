#ifndef XESTIONERROS_H
#define XESTIONERROS_H


#define SINTAXE_NON_VALIDA 1
#define FICHEIRO_NON_ATOPADO 2
#define FICHEIRO_NON_INDICADO 3
#define FICHEIRO_MAL_FORMATO 4
#define LIBRERIA_NON_ATOPADA 5
#define FUNCION_NON_ATOPADA 6
#define PARAMETROS_NON_INDICADOS 7
#define LEXEMA_DESCONOCIDO 8
#define NAN_DETECTADO 9
#define VARIABLE_NON_DEFINIDA 10
#define CONSTANTE_NON_MODIFICABLE 11
#define DIV_CERO 12
#define MOD_CERO 13


// Función que dado un código de erro imprime por pantalla unha mensaxe concreta
void lanzarErro(int codigo);


#endif
