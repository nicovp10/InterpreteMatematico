%{
#include <math.h>
#include "lex.yy.h"
#include "taboaSimbolos.h"

CompLexico comp;
%}


%union {
    double numero;
    char *cadea;
}

%start entrada

%token <numero> NUM
%token <cadea> VAR FUNC

%type <numero> exp

%left '-' '+'
%left '*' '/'
%left NEG
%right '^'
%right '('


%%
entrada: %empty 
        | entrada linea
;

linea:   '\n'
        | ';'
        | exp '\n'
        | exp ';'
;

exp:    NUM
        | VAR                   {
                                    comp.lexema = malloc(strlen($1) * sizeof(char));
                                    strcpy(comp.lexema, $1);
                                    buscar_insertar(&comp);
                                }
        | VAR '=' exp           { $$ = $3; $1->valor.var=$3; }
        | FUNC '(' exp ')'      { $$ = (*($1->valor.funcptr))($3); }
        | '-' exp %prec NEG     { $$ = -$2; }
        | exp '+' exp           { $$ = $1 + $3; }
        | exp '-' exp           { $$ = $1 - $3; }
        | exp '*' exp           { $$ = $1 * $3; }
        | exp '/' exp           { $$ = $1 / $3; }
        | exp '^' exp           { $$ = pow($1, $3); }
        | '(' exp ')'           { $$ = $2; }
;
%%