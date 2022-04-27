#include <stdio.h>

#include "nicalc.h"
#include "lex.yy.h"
#include "bison.tab.h"
#include "system.h"


// Función que invoca ao intérprete matemático
void nicalc(char *arg) {
    printf("\n---------------------------------------------------------------------------------\n"
           "\t\t\t\t  NICALC v1.0\n\n"
           "Nicalc é un intérprete matemático coa opción de cargar ficheiros con operacións\n"
           "e importar librerías de forma dinámica, podendo empregar desta maneira as funcións\n"
           "da mesma.\n\n"
           "Para máis información sobre o programa e os seus comandos, escribe 'axuda()'.\n"
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