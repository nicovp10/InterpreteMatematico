%{
#include <string.h>
#include <math.h>

#include "nicalc.h"
#include "bison.tab.h"
#include "definicions.h"
#include "taboaSimbolos.h"
#include "xestionErros.h"
%}



/*
 Indícase que só se lerá un ficheiro de entrada,
 que se creará un ficheiro cabeceira chamado lex.yy.h e
 que non se creará nin a función input nin yyunput.
 Estas dúas últimas opcións son para evitar warnings de compilación.
*/
%option noyywrap header-file="lex.yy.h" noinput nounput



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

NUM                 {ENTEIRO}|{DECIMAL}
FICHEIRO            ({LETRA}|{DIXITO})+\.({LETRA}|{DIXITO})+

%%

{IGNORAR}
{COMENTARIO_UNHA}
{COMENTARIO_MULTI}

{NUM}                   yylval.numero = atof(yytext); return NUM;
{IDENTIFICADOR}         {
                            yylval.cadea = strdup(yytext);
                            CompLexico comp = buscar(yylval.cadea);
                            if (comp.lexema == NULL) {
                                return VAR;
                            }
                            return comp.comp_lexico;
                        }

{INDIVIDUAL}            return (int) *yytext;
{_SUMAIGUAL}            return SUMAIGUAL;
{_RESTAIGUAL}           return RESTAIGUAL;
{_MULTIGUAL}            return MULTIGUAL;
{_DIVIGUAL}             return DIVIGUAL;
{FICHEIRO}              yylval.cadea = strdup(yytext); return FICHEIRO;

.                       lanzarErro(LEXEMA_DESCONOCIDO);

<<EOF>>		            executandoScript(0); fclose(yyin); yyrestart(stdin);

%%
