%{
#include <math.h>
#include "lex.yy.h"
#include "taboaSimbolos.h"
#include "definicions.h"
#include "xestionErros.h"

CompLexico comp;
int facerEcho = 1;
int script = 0;
int erro = 0;

void yyerror (char *s);
%}


%union {
    double numero;
    char *cadea;
}

%start entrada

%token <numero> NUM
%token <cadea> CONST VAR FUNC CMND0 CMND1 FICHEIRO

%type <numero> exp asig cmnd fnc

%left '-' '+'
%left '*' '/'
%left '%'
%precedence NEG
%right '^'


%%
entrada: %empty         { printf(CYAN">"RESET" "); }
        | entrada linea
;

linea:   '\n'           { printf(CYAN">"RESET" "); }
        | exp '\n'      {
                            if (isnan($1) && !erro) {
                                lanzarErro(NAN_DETECTADO);
                            } else if (!erro && facerEcho) {
                                printf(VERDE"%lf"RESET"\n\n", $1);
                            }
                            if (!script) {
                                printf(CYAN">"RESET" ");
                            }
                            erro = 0;
                        }
        | exp ';' '\n'  {
                            if (isnan($1) && !erro) {
                                lanzarErro(NAN_DETECTADO);
                            } else if (!erro && facerEcho) {
                                printf(VERDE"%lf"RESET"\n\n", $1);
                            }
                            if (!script) {
                                printf(CYAN">"RESET" ");
                            }
                            erro = 0;
                        }
        | asig '\n'     {
                            if (isnan($1) && !erro) {
                                lanzarErro(NAN_DETECTADO);
                            } else if (!erro && facerEcho) {
                                printf(VERDE"%lf"RESET"\n\n", $1);
                            }
                            if (!script) {
                                printf(CYAN">"RESET" ");
                            }
                            erro = 0;
                        }
        | asig ';' '\n' {
                            if (isnan($1) && !erro) {
                                lanzarErro(NAN_DETECTADO);
                            } else if (!erro && facerEcho) {
                                printf(VERDE"%lf"RESET"\n\n", $1);
                            }
                            if (!script) {
                                printf(CYAN">"RESET" ");
                            }
                            erro = 0;
                        }
        | cmnd '\n'         {
                                if (isnan($1) && !erro) {
                                    lanzarErro(NAN_DETECTADO);
                                }
                                if (!script) {
                                    printf(CYAN">"RESET" ");
                                }
                                erro = 0;
                            }
        | cmnd ';' '\n'     {
                                if (isnan($1) && !erro) {
                                    lanzarErro(NAN_DETECTADO);
                                }
                                if (!script) {
                                    printf(CYAN">"RESET" ");
                                }
                                erro = 0;
                            }
        | fnc '\n'          {
                                if (isnan($1) && !erro) {
                                    lanzarErro(NAN_DETECTADO);
                                } else if (!erro && facerEcho) {
                                    printf(VERDE"%lf"RESET"\n\n", $1);
                                }
                                if (!script) {
                                    printf(CYAN">"RESET" ");
                                }
                                erro = 0;
                            }
        | fnc '\n' ';'      {
                                if (isnan($1) && !erro) {
                                    lanzarErro(NAN_DETECTADO);
                                } else if (!erro && facerEcho) {
                                    printf(VERDE"%lf"RESET"\n\n", $1);
                                }
                                if (!script) {
                                    printf(CYAN">"RESET" ");
                                }
                                erro = 0;
                            }
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
                                erro = 1;
                                $$ = NAN;
                            }
                        }
        | '-' exp %prec NEG {
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
                                erro = 1;
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
                                erro = 1;
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
                            erro = 1;
                            $$ = NAN;
                        }

cmnd:   CMND0                       {
                                        comp = buscar($1);
                                        (*(comp.valor.funcptr))();
                                    }
        | CMND0 '(' ')'             {
                                        comp = buscar($1);
                                        (*(comp.valor.funcptr))();
                                    }
        | CMND1                     {
                                        lanzarErro(FICHEIRO_NON_INDICADO);
                                        erro = 1;
                                        $$ = NAN;
                                    }
        | CMND1 '(' ')'             {
                                        lanzarErro(FICHEIRO_NON_INDICADO);
                                        erro = 1;
                                        $$ = NAN;
                                    }
        | CMND1 FICHEIRO            {
                                        comp = buscar($1);
                                        (*(comp.valor.funcptr))($2);
                                    }
        | CMND1 '(' FICHEIRO ')'    {
                                        comp = buscar($1);
                                        (*(comp.valor.funcptr))($3);
                                    }
        | CMND1 exp                 {
                                        lanzarErro(FICHEIRO_MAL_FORMATO);
                                        erro = 1;
                                        $$ = NAN;
                                    }
fnc:    FUNC '(' exp ')'            {
                                        comp = buscar($1);
                                        $$ = (*(comp.valor.funcptr))($3);
                                    }
%%
void yyerror(char *s) {
    printf("Erro na análise sintáctica: %s\n", s);
}

void cambiarEcho(int valor) {
    facerEcho = valor;
    if (facerEcho) {
        printf(VERDE"    Echo activado."RESET"\n\n");
    } else {
        printf(VERDE"    Echo desactivado."RESET"\n\n");
    }
}

void executandoScript(int valor) {
    script = valor;
    if (!script) {
        printf("\n"VERDE"Script executado correctamente."RESET"\n\n"CYAN">"RESET" ");
    }
}