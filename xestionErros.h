#ifndef XESTIONERROS_H
#define XESTIONERROS_H


#define FICHEIRO_NON_ATOPADO 1
#define LEXEMA_DESCONOCIDO 2
#define VARIABLE_NON_DEFINIDA 3
#define DIV_CERO 4
#define MOD_CERO 5


// Función que dado un código de erro imprime por pantalla unha mensaxe concreta
void lanzarErro(int codigo);


#endif
