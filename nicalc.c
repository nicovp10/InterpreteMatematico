#include <stdio.h>

#include "nicalc.h"
#include "definicions.h"
#include "lex.yy.h"


// Función que invoca ao intérprete de expresións de cálculo matemático
void nicalc() {
    yyparse();
}