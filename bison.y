%{
#define YYSTYPE double
#include <math.h>
%}
%union {
    double valor;
    CompLexico *comp;
}

%token <valor> NUM
%token <comp> VAR FUNC

%type <valor> exp

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
        | VAR                   { $$ = $1->valor.var; }
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