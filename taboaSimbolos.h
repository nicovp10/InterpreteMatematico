#ifndef TABOASIMBOLOS_H
#define TABOASIMBOLOS_H

#include "definicions.h"


// Función que inicia a táboa de símbolos
void iniciarTS();

// Función que busca un lexema concreto na táboa de símbolos.
//  Se o lexema está na táboa, devolve o seu compoñente léxico.
//  Se o lexema non está na táboa, devolve 0
CompLexico buscar(char *lexema);

// Función que busca un compoñente léxico concreto na táboa de símbolos
//  Se este compoñente léxico non está na táboa, insértao
void buscar_insertar(CompLexico *comp);

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


#endif