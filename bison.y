%{
#include <math.h>
#include "lex.yy.h"
#include "taboaSimbolos.h"
#include "definicions.h"
#include "xestionErros.h"

CompLexico comp;

void yyerror (char *s) {
    printf("Erro na análise sintáctica: %s\n", s);
}
%}


%union {
    double numero;
    char *cadea;
}

%start entrada

%token <numero> NUM
%token <cadea> ID VAR FUNC CMND0 CMND1 FICHEIRO

%type <numero> exp

%left '-' '+'
%left '*' '/'
%left '%'
%precedence NEG
%right '^'


%%
entrada: %empty 
        | entrada linea
;

linea:   '\n'
        | ';'
        | exp '\n'
        | exp ';' { printf("%lf\n", $1); }
;

exp:    VAR                     {
                                    if ((comp = buscar($1)).lexema != NULL) {
                                        $$ = comp.valor.var;
                                    } else {
                                        lanzarErro(VARIABLE_NON_DEFINIDA);
                                    }
                                }
        | VAR '=' exp           {
                                    if ((comp = buscar($1)).lexema != NULL) {
                                        modificarValorVariable($1, $3);
                                    } else {
                                        comp.lexema = strdup($1);
                                        comp.comp_lexico = VAR;
                                        comp.valor.var = $3;
                                        insertar(comp);
                                    }
                                    $$ = $3;
                                }
        | FUNC '(' exp ')'      { }
        | CMND0 '(' ')'             { }
        | CMND1 '(' FICHEIRO ')'    { }
        | '-' exp %prec NEG     { $$ = -$2; }
        | exp '+' exp           { $$ = $1 + $3; }
        | exp '-' exp           { $$ = $1 - $3; }
        | exp '*' exp           { $$ = $1 * $3; }
        | exp '/' exp           {
                                    if ($3 == 0) {
                                        lanzarErro(DIV_CERO);
                                    } else {
                                        $$ = $1 / $3;
                                    }
                                }
        | exp '%' exp           {
                                    if ($3 == 0) {
                                        lanzarErro(MOD_CERO);
                                    } else {
                                        $$ = fmod($1, $3);
                                    }
                                }
        | exp '^' exp           { $$ = pow($1, $3); }
        | '(' exp ')'           { $$ = $2; }
;
%%