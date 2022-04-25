#ifndef TABOASIMBOLOS_H
#define TABOASIMBOLOS_H

#include "nicalc.h"


// Función que inicia a táboa de símbolos
void iniciarTS();

// Función que engade unha librería para o manexo das súas funcións
void engadirLib(void * libreria);

// Función que busca un lexema concreto na táboa de símbolos.
//  Se o lexema está na táboa, devolve o seu compoñente léxico.
//  Se o lexema non está na táboa, búscase se está nunha librería e,
//      de ser así, insértase na táboa de símbolos.
//  Se o lexema non está na táboa nin nunha librería, devolve NULL.
CompLexico buscar(char *lexema);

// Función que inserta un compoñente léxico na árbore
void insertar(CompLexico comp);

// Función que modifica o valor de variable dun compoñente léxico na táboa de símbolos
void modificarValorVariable(char *lexema, double valor);

// Función que elimina un compoñente léxico concreto da táboa de símbolos
void eliminar(CompLexico compLexico);

// Función que finaliza a táboa de símbolos
void finalizarTS();

// Función que imprime a táboa de símbolos por orde alfabético dos lexemas
void imprimirTS();

// Función que imprime o workspace por orde alfabético dos lexemas
void imprimirWS();


#endif