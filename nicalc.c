#include <stdio.h>

#include "nicalc.h"


// Función que invoca ao intérprete de expresións de cálculo matemático
void nicalc() {
    yyparse();
}