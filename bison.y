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
%token <cadea> CONST VAR FUNC CMND0 CMND1 FICHEIRO

%type <numero> exp asig metodo

%left '-' '+'
%left '*' '/'
%left '%'
%right '^'


%%
entrada: %empty         { printf("> "); }
        | entrada linea
;

linea:   '\n'           { printf("> "); }
        | exp '\n'      { printf("> "); }
        | exp ';' '\n'  { printf("    %lf\n\n> ", $1); }
        | asig '\n'     { printf("> "); }
        | asig ';' '\n' { printf("    %lf\n\n> ", $1); }
;

exp:    NUM
        | CONST         {
                            comp = buscar($1);
                            $$ = comp.valor.var;
                        }
        | VAR           {
                            if ((comp = buscar($1)).lexema != NULL) {
                                $$ = comp.valor.var;
                            } else {
                                lanzarErro(VARIABLE_NON_DEFINIDA);
                                $$ = NAN;
                            }
                        }
        | '-' exp       {
                             if (!isnan($2)) {
                                 $$ = -$2;
                             } else {
                                 $$ = NAN;
                             }
                         }
        | exp '+' exp   {
                            if (!isnan($1) && !isnan($3)) {
                                $$ = $1 + $3;
                            } else {
                                $$ = NAN;
                            }
                        }
        | exp '-' exp   {
                            if (!isnan($1) && !isnan($3)) {
                                $$ = $1 - $3;
                            } else {
                                $$ = NAN;
                            }
                        }
        | exp '*' exp   {
                            if (!isnan($1) && !isnan($3)) {
                                $$ = $1 * $3;
                            } else {
                                $$ = NAN;
                            }
                        }
        | exp '/' exp   {
                            if ($3 == 0) {
                                lanzarErro(DIV_CERO);
                                $$ = NAN;
                            } else {
                                if (!isnan($1) && !isnan($3)) {
                                    $$ = $1 / $3;
                                } else {
                                    $$ = NAN;
                                }
                            }
                        }
        | exp '%' exp   {
                            if ($3 == 0) {
                                lanzarErro(MOD_CERO);
                                $$ = NAN;
                            } else {
                                if (!isnan($1) && !isnan($3)) {
                                    $$ = fmod($1, $3);
                                } else {
                                    $$ = NAN;
                                }
                            }
                        }
        | exp '^' exp   {
                            if (!isnan($1) && !isnan($3)) {
                                $$ = pow($1, $3);
                            } else {
                                $$ = NAN;
                            }
                        }
        | '(' exp ')'   {
                             if (!isnan($2)) {
                                 $$ = $2;
                             } else {
                                 $$ = NAN;
                             }
                         }
        | metodo
;

asig:   VAR '=' exp     {
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
        | CONST '=' exp {
                            lanzarErro(CONSTANTE_NON_MODIFICABLE);
                            $$ = NAN;
                        }

metodo: FUNC '(' exp ')'            {

                                    }
        | CMND0 '(' ')'             {

                                    }
        | CMND1 '(' FICHEIRO ')'    {

                                    }
%%