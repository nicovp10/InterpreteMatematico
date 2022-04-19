%{
#include <string.h>
#include <math.h>

#include "bison.tab.h"
#include "definicions.h"
#include "taboaSimbolos.h"
#include "xestionErros.h"
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

%%

{IGNORAR}
{COMENTARIO_UNHA}
{COMENTARIO_MULTI}

{_NUM}                  yylval.numero = atof(yytext); return NUM;
{IDENTIFICADOR}         {
                            yylval.cadea = strdup(yytext);
                            int comp = buscar(yylval.cadea);
                            if (comp == 0) {
                                retunr ID;
                            }
                            return comp;
                        }

{INDIVIDUAL}            return (int) *yytext;
{_SUMAIGUAL}            return SUMAIGUAL;
{_RESTAIGUAL}           return RESTAIGUAL;
{_MULTIGUAL}            return MULTIGUAL;
{_DIVIGUAL}             return DIVIGUAL;

.                       lanzarErro(yylineno, LEXEMA_DESCONOCIDO);

<<EOF>>		            fclose(yyin); yyrestart(stdin);

%%
