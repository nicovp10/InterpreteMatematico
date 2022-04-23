#include <stdio.h>

#include "nicalc.h"
#include "bison.tab.h"


// Función que invoca ao intérprete de expresións de cálculo matemático
void nicalc() {
    // TODO opción de invocar o programa cun script de entrada

    yyparse();
}