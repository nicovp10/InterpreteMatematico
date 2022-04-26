#include <stdio.h>

#include "nicalc.h"
#include "lex.yy.h"
#include "bison.tab.h"
#include "system.h"


// Función que invoca ao intérprete de expresións de cálculo matemático
void nicalc(char *arg) {
    printf("\n---------------------------------------------------------------------------------\n"
           "\t\t\t\t  NICALC v1.0\n\n"
           "Nicalc é un intérprete matemático con opción a carga de scripts con operacións\n"
           "e de librerías de forma dinámica, podendo empregar desta maneira as funcións\nda mesma.\n\n"
           "Para máis información sobre o programa e os seus comandos, escriba 'axuda()'\n"
           "---------------------------------------------------------------------------------\n\n\n");

    if (arg != NULL) {
        if (strcmp(arg, "-h") == 0) {
            axuda();
        } else {
            cargar(arg);
        }
    }


    yyparse();
}