%{
#define YYSTYPE double
#include <math.h>
%}


%token NUM
%left '-' '+'
%left '*' '/'
%left NEG
%right '^'
%right '('


%%
entrada:
        | entrada linea
;

line:   '\n'
        | exp '\n'
;

exp:    NUM
        | VAR                   { $$ = $1->valor.var; }
        | VAR '=' exp           { $$ = $1->valor.var = $3; }
        | FUNC '(' exp ')'      { $$ = (*($1->valor.funcptr))($3); }
        | '-' exp %prec NEG     { $$ = -$2; }
        | exp '+' exp           { $$ = $1 + $3; }
        | exp '-' exp           { $$ = $1 - $3; }
        | exp '*' exp           { $$ = $1 * $3; }
        | exp '/' exp           { $$ = $1 / $3; }
        | exp '^' exp           { $$ = pow($1, $3); }
        | '(' exp ')'           { $$ = $2; }