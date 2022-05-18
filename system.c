#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

#include "system.h"
#include "lex.yy.h"
#include "bison.tab.h"
#include "xestionErros.h"
#include "taboaSimbolos.h"


int varEcho = 1;


double clear() {
    system("clear");
    return 0;
}

double sair() {
    printf(AMARILLO"Saíndo do programa..."RESET"\n\n");
    finalizarTS();
    yylex_destroy();
    exit(EXIT_SUCCESS);
}

double axuda() {
    printf("\n===================================================================================================================================================\n\n"
           "\t\t\t\t\t\t\t\t\tAXUDA\n\n"
           "---------------------------------------------------------------------------------------------------------------------------------------------------\n\n"
           "\tSOBRE O INTÉRPRETE\n"
           "\t\tCabe destacar que este intérprete está en fase beta, polo cal os erros de sintaxe non están xestionados de maneira óptima,\n"
           "\t\tfacendo que o intérprete deteña a execución en caso de que estes ocorran. Por outro lado, a sintaxe e o léxico son os que\n"
           "\t\tcabe esperar de calquera intérprete matemático.\n\n"
           "\t\tO intérprete ten definidas dúas constantes: 'pi' e 'e'. As constantes non se poden modificar.\n\n"
           "\t\tAs operacións permitidas por defecto son as seguintes: suma ('+'), resta ('-'), multiplicación ('*'), división ('/'),\n"
           "\t\tmódulo ('%%') e potencia ('^'). De todos modos pódense engadir máis operacións mediante a importación de librerías. Por\n"
           "\t\texemplo: para importar a librería matemática escríbese o comando 'importar libm.so.6', e para usar as súas funcións a\n"
           "\t\tsintaxe será 'libm/FUNC'.\n\n"
           "\t\tO intérprete admite como máximo funcións con dous parámetros, os cales irán entre paréntesis e separados por unha coma. Para\n"
           "\t\tusar as funcións das librerías usarase de prefixo a parte do nome do ficheiro de antes da primeira extensión, así ao importar\n"
           "\t\to ficheiro 'libx.so', as súas funcións serán accesibles a través de 'libx/FUNC'.\n\n\n"
           "\tCOMANDOS\n"
           "\t\tPara a execución de comandos hai dous tipos de sintaxe: con paréntesis ou sen eles. Nos comandos sen parámetros sería 'CMND'\n"
           "\t\tou 'CMND()', respectivamente; e nos comandos cun parámetro sería 'CMND PARAM' ou 'CMND(PARAM)', respectivamente.\n\n"
           "\t\tOs comandos dispoñibles son:\n\n"
           "\t\t\t- axuda\t\t\t\tMostra esta axuda. Tamén se pode mostar ao iniciar o propio intérprete indicando a\n"
           "\t\t\t\t\t\t\topción '-h': './nicalc -h'.\n\n"
           "\t\t\t- cargar FICHEIRO\t\tCarga e executa un ficheiro.\n"
           "\t\t\t\t\t\t\tEste ficheiro debe respectar a sintaxe do intérprete e non poderá cargar outros\n"
           "\t\t\t\t\t\t\tficheiros desde el (en caso de que o faga non se asegura o correcto funcionamento\n"
           "\t\t\t\t\t\t\tdo intérprete).\n"
           "\t\t\t\t\t\t\tTamén se poden executar ficheiros ao iniciar o propio intérprete inidicándoo como\n"
           "\t\t\t\t\t\t\targumento: './nicalc FICHEIRO'.\n\n"
           "\t\t\t- clear\t\t\t\tLimpa a terminal de saída.\n\n"
           "\t\t\t- echo\t\t\t\tActiva/Desactiva a impresión da información de saída. Por defecto está activada.\n\n"
           "\t\t\t- importar LIBRERIA\t\tImporta unha librería de forma dinámica a través do seu ficheiro .so.\n"
           "\t\t\t\t\t\t\tSe se indica só o nome, buscarase por orde nas rutas /lib e /usr/lib, non obstante\n"
           "\t\t\t\t\t\t\tpódense importar librerías indicando a ruta completa do seu ficheiro .so.\n\n"
           "\t\t\t- limparws\t\t\tLimpa o espazo de traballo.\n\n"
           "\t\t\t- sair\t\t\t\tSae do intérprete.\n\n"
           "\t\t\t- taboa\t\t\t\tMostra a táboa de símbolos, que contén os comandos, constantes, funcións usadas\n"
           "\t\t\t\t\t\t\talgunha vez, librerías importadas e variables.\n\n"
           "\t\t\t- ws\t\t\t\tMostrar o espazo de traballo actual, que contén as variables definidas ata o momento.\n\n"
           "\n===================================================================================================================================================\n\n");
    return 0;
}

double echo() {
    if (varEcho == 1) {
        varEcho = 0;
    } else {
        varEcho = 1;
    }
    cambiarEcho(varEcho);
    return 0;
}

double taboa() {
    imprimirTS();
    return 0;
}

double ws() {
    imprimirWS();
    return 0;
}

double limparws() {
    eliminarWS();
    printf(AMARILLO"Espazo de traballo limpado correctamente.\n\n"RESET);
    return 0;
}

double cargar(char *ficheiro) {
    yyin = fopen(ficheiro, "r");

    if (yyin == NULL) {
        lanzarErro(FICHEIRO_NON_ATOPADO);
        yyin = stdin;
    } else {
        executandoScript(1);
    }

    return 0;
}

double importar(char *libreria) {
    void *lib = dlopen(libreria, RTLD_LAZY);
    char *nome_lib = NULL, *lexema;
    if (lib == NULL) {
        printf(ROJO"Erro: apertura de librería fallida.\n\tDetalles: %s"RESET"\n\n", dlerror());
    } else {
        for (int i = ((int) (strlen(libreria) - 1)); i >= 0; i--) {
            if (libreria[i] == '/') {
                nome_lib = &libreria[i + 1];
                break;
            }
        }
        if (nome_lib == NULL) {
            nome_lib = libreria;
        }
        lexema = strtok(nome_lib, ".");
        CompLexico comp_lib = {LIB, lexema, .valor.libhandle=lib};
        insertar(comp_lib);
        printf(AMARILLO"Librería cargada correctamente.\n\n"RESET);
    }

    return 0;
}
