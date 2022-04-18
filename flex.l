%{
#include "definicions.h"
#include "taboaSimbolos.h"
#include "xestionErros.h"
CompLexico comp = {0, NULL, 0};
int erro = 0;
%}



/*
 Indícase que só se lerá un ficheiro de entrada, 
 que se levará unha conta da liña de lectura actual do código,
 que se creará un ficheiro cabeceira chamado lex.yy.h e
 que non se creará nin a función input nin yyunput.
 Estas dúas últimas opcións son para evitar warnings de compilación.
*/
%option noyywrap yylineno header-file="lex.yy.h" noinput nounput



/* DEFINICIÓNS */
/* Auxiliares */
LETRA               [a-zA-Z]|_
IDENTIFICADOR       {LETRA}({LETRA}|{DIXITO})*

DIXITO              [0-9]
DIXITOS             {DIXITO}({DIXITO})*
EXPONENTE           [eE][+-]?{DIXITOS}
ENTEIRO             {DIXITOS}
DECIMAL             {DIXITOS}\.{DIXITOS}?{EXPONENTE}?|{DIXITOS}{EXPONENTE}|\.{DIXITOS}{EXPONENTE}?


/* Comentarios */
COMENTARIO_UNHA     \/\/.*$
COMENTARIO_MULTI    \/\*(.|\n)*\*\/


/* Compoñentes léxicos */
IGNORAR             [ \t]

INDIVIDUAL          [\+\-\*\/^=\(\);\r\n]
_SUMAIGUAL          \+=
_RESTAIGUAL         \-=
_MULTIGUAL          \*=
_DIVIGUAL           \/=

_NUM                 {ENTEIRO}|{DECIMAL}
_VAR                 {IDENTIFICADOR}
_FUNC                {IDENTIFICADOR}\(.\)

%%

{IGNORAR}
{COMENTARIO_UNHA}
{COMENTARIO_MULTI}

{_NUM}                  return NUM;
{_VAR}                  return VAR;
{_FUNC}                 return FUNC;

{INDIVIDUAL}            return (int) *yytext;
{_SUMAIGUAL}            return SUMAIGUAL;
{_RESTAIGUAL}           return RESTAIGUAL;
{_MULTIGUAL}            return MULTIGUAL;
{_DIVIGUAL}             return DIVIGUAL;

.                       erro = 1; lanzarErro(yylineno, LEXEMA_DESCONOCIDO);

<<EOF>>		yyterminate();

%%

void iniciarAnalizadorLexico(char *nomeFicheiro) {
    if ((yyin = fopen(nomeFicheiro, "r")) == NULL) {
        lanzarErro(0, FICHEIRO_NON_ATOPADO);
        exit(EXIT_FAILURE);
    }

    // Para que en caso de detectar un erro léxico non imprima os caracteres pendentes de procesar:
    yyout = fopen("/dev/null", "w");
}

CompLexico segCompLexico() {
    if (comp.lexema != NULL) {
        free(comp.lexema);
        comp.comp_lexico = 0;
        comp.lexema = NULL;
    }

    comp.comp_lexico = yylex();
    comp.lexema = malloc((yyleng + 1) * sizeof(char));
    strcpy(comp.lexema, yytext);
    comp.lexema[yyleng] = '\0';

    if (!erro && comp.comp_lexico == VAR) {
         buscar_insertar(&comp);
    } else {
        erro = 0;
    }

    return comp;
}

void finalizarAnalizadorLexico() {
    if (comp.lexema != NULL) {
        free(comp.lexema);
        comp.comp_lexico = 0;
        comp.lexema = NULL;
    }

    fclose(yyin);
    fclose(yyout);
	yylex_destroy();
}
