#include <stdio.h>
#include <stdlib.h>

#include "analizadorSintactico.h"
#include "taboaSimbolos.h"


int main() {
    iniciarTS();
    imprimirTS();

    analizadorSintactico();

    imprimirTS();
    finalizarTS();

    exit(0);
}
