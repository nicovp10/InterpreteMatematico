#ifndef TABOASIMBOLOS_H
#define TABOASIMBOLOS_H

#include "nicalc.h"


// Función que inicia a táboa de símbolos
void iniciarTS();

// Función que busca un lexema concreto na táboa de símbolos.
//  Se o lexema está na táboa, devolve o seu compoñente léxico.
//  Se o lexema non está na táboa, búscase se está nunha librería e,
//      de ser así, insértase na táboa de símbolos.
//  Se o lexema non está na táboa nin nunha librería, devolve NULL.
CompLexico buscarLexema(char *lexema);

// Función que busca unha función concreta na táboa de símbolos.
//  Se a función está na táboa, devolve o seu compoñente léxico.
//  Se o lexema non está na táboa, búscase se está na librería
//      indicada e, de ser así, insértase na táboa de símbolos.
//  Se o lexema non está na táboa nin na librería, devolve NULL.
CompLexico buscarFuncion(void *lib, char *lexema_funcion, char *libfunc);

// Función que inserta un compoñente léxico na táboa de símbolos
void insertar(CompLexico comp);

// Función que modifica o valor de variable dun compoñente léxico na táboa de símbolos
void modificarValorVariable(char *lexema, double valor);

// Función que elimina todas as variables da táboa de símbolos
void eliminarWS();

// Función que finaliza a táboa de símbolos
void finalizarTS();

// Función que imprime a táboa de símbolos por orde alfabético dos lexemas
void imprimirTS();

// Función que imprime as variables da táboa de símbolos por orde alfabético dos lexemas
void imprimirWS();


#endif