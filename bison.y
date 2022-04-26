%{
#include <math.h>

#include "lex.yy.h"
#include "taboaSimbolos.h"
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
%token <cadea> CONST VAR FUNC CMND0 CMND1 FICHEIRO LIB

%type <numero> exp asig cmnd fnc

%left '-' '+'
%left '*' '/'
%left '%'
%precedence NEG
%right '^'


%%
entrada: %empty         {
                            if (!script) {
                                printf(CYAN">"RESET" ");
                            }
                        }
        | entrada linea
;

linea:   '\n'           { printf(CYAN">"RESET" "); }
        | exp '\n'      {
                            if (!erro) {
                                if (isnan($1)) {
                                    lanzarErro(NAN_DETECTADO);
                                } else if (facerEcho) {
                                    printf(VERDE"%lf"RESET"\n\n", $1);
                                }
                            }
                            if (!script) {
                                printf(CYAN">"RESET" ");
                            }
                            erro = 0;
                        }
        | exp ';' '\n'  {
                            if (!erro) {
                                if (isnan($1)) {
                                    lanzarErro(NAN_DETECTADO);
                                } else if (facerEcho) {
                                    printf(VERDE"%lf"RESET"\n\n", $1);
                                }
                            }
                            if (!script) {
                                printf(CYAN">"RESET" ");
                            }
                            erro = 0;
                        }
        | asig '\n'     {
                            if (!erro) {
                                if (isnan($1)) {
                                    lanzarErro(NAN_DETECTADO);
                                } else if (facerEcho) {
                                    printf(VERDE"%lf"RESET"\n\n", $1);
                                }
                            }
                            if (!script) {
                                printf(CYAN">"RESET" ");
                            }
                            erro = 0;
                        }
        | asig ';' '\n' {
                            if (!erro) {
                                if (isnan($1)) {
                                    lanzarErro(NAN_DETECTADO);
                                } else if (facerEcho) {
                                    printf(VERDE"%lf"RESET"\n\n", $1);
                                }
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
                                if (!erro) {
                                    if (isnan($1)) {
                                        lanzarErro(NAN_DETECTADO);
                                    } else if (facerEcho) {
                                        printf(VERDE"%lf"RESET"\n\n", $1);
                                    }
                                }
                                if (!script) {
                                    printf(CYAN">"RESET" ");
                                }
                                erro = 0;
                            }
        | fnc ';' '\n'      {
                                if (!erro) {
                                    if (isnan($1)) {
                                        lanzarErro(NAN_DETECTADO);
                                    } else if (facerEcho) {
                                        printf(VERDE"%lf"RESET"\n\n", $1);
                                    }
                                }
                                if (!script) {
                                    printf(CYAN">"RESET" ");
                                }
                                erro = 0;
                            }
;

exp:    NUM
        | CONST         {
                            comp = buscarLexema($1);
                            $$ = comp.valor.var;
                        }
        | VAR           {
                            if ((comp = buscarLexema($1)).lexema != NULL) {
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
                           if ((comp = buscarLexema($1)).lexema != NULL) {
                               modificarValorVariable($1, $3);
                           } else if (!erro) {
                               comp.lexema = strdup($1);
                               comp.comp_lexico = VAR;
                               comp.valor.var = $3;
                               insertar(comp);
                           }
                           $$ = $3;
                        }
        | VAR '=' fnc   {
                           if ((comp = buscarLexema($1)).lexema != NULL) {
                               modificarValorVariable($1, $3);
                           } else if (!erro) {
                               comp.lexema = strdup($1);
                               comp.comp_lexico = VAR;
                               comp.valor.var = $3;
                               insertar(comp);
                           }
                           $$ = $3;
                        }
        | VAR '=' cmnd  {
                            lanzarErro(SINTAXE_NON_VALIDA);
                            erro = 1;
                            $$ = NAN;
                        }
        | CONST '=' exp {
                            lanzarErro(CONSTANTE_NON_MODIFICABLE);
                            erro = 1;
                            $$ = NAN;
                        }
        | CONST '=' fnc {
                            lanzarErro(CONSTANTE_NON_MODIFICABLE);
                            erro = 1;
                            $$ = NAN;
                        }
        | CONST '=' cmnd {
                            lanzarErro(CONSTANTE_NON_MODIFICABLE);
                            erro = 1;
                            $$ = NAN;
                        }
;

cmnd:   CMND0                       {
                                        comp = buscarLexema($1);
                                        (*(comp.valor.funcptr))();
                                    }
        | CMND0 '(' ')'             {
                                        comp = buscarLexema($1);
                                        (*(comp.valor.funcptr))();
                                    }
        | CMND0 exp                 {
                                        lanzarErro(SINTAXE_NON_VALIDA);
                                        erro = 1;
                                        $$ = NAN;
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
                                        comp = buscarLexema($1);
                                        (*(comp.valor.funcptr))($2);
                                    }
        | CMND1 '(' FICHEIRO ')'    {
                                        comp = buscarLexema($1);
                                        (*(comp.valor.funcptr))($3);
                                    }
        | CMND1 exp                 {
                                        lanzarErro(FICHEIRO_MAL_FORMATO);
                                        erro = 1;
                                        $$ = NAN;
                                    }
;

fnc:    LIB '/' FUNC '(' exp ')'            {
                                                comp = buscarLexema($1);
                                                CompLexico comp_func = buscarFuncion(comp.valor.libhandle, $3);
                                                if (comp_func.lexema != NULL) {
                                                    $$ = (*(comp_func.valor.funcptr))($5);
                                                } else {
                                                    lanzarErro(FUNCION_NON_ATOPADA);
                                                    erro = 1;
                                                    $$ = NAN;
                                                }
                                            }
        | LIB '/' FUNC '(' exp ',' exp ')'  {
                                                comp = buscarLexema($1);
                                                CompLexico comp_func = buscarFuncion(comp.valor.libhandle, $3);
                                                if (comp_func.lexema != NULL) {
                                                    $$ = (*(comp_func.valor.funcptr))($5, $7);
                                                } else {
                                                    lanzarErro(FUNCION_NON_ATOPADA);
                                                    erro = 1;
                                                    $$ = NAN;
                                                }
                                            }
        | LIB '/' FUNC '(' ')'              {
                                                lanzarErro(PARAMETROS_NON_INDICADOS);
                                                erro = 1;
                                                $$ = NAN;
                                            }
        | LIB '/' VAR '(' exp ')'           {
                                                comp = buscarLexema($1);
                                                CompLexico comp_func = buscarFuncion(comp.valor.libhandle, $3);
                                                if (comp_func.lexema != NULL) {
                                                    $$ = (*(comp_func.valor.funcptr))($5);
                                                } else {
                                                    lanzarErro(FUNCION_NON_ATOPADA);
                                                    erro = 1;
                                                    $$ = NAN;
                                                }
                                            }
        | LIB '/' VAR '(' exp ',' exp ')'   {
                                                comp = buscarLexema($1);
                                                CompLexico comp_func = buscarFuncion(comp.valor.libhandle, $3);
                                                if (comp_func.lexema != NULL) {
                                                    $$ = (*(comp_func.valor.funcptr))($5, $7);
                                                } else {
                                                    lanzarErro(FUNCION_NON_ATOPADA);
                                                    erro = 1;
                                                    $$ = NAN;
                                                }
                                            }
        | LIB '/' VAR '(' ')'               {
                                                lanzarErro(PARAMETROS_NON_INDICADOS);
                                                erro = 1;
                                                $$ = NAN;
                                            }
        | exp '(' exp ')'                   {
                                                lanzarErro(LIBRERIA_NON_ATOPADA);
                                                erro = 1;
                                                $$ = NAN;
                                            }
        | exp '(' exp ',' exp ')'           {
                                                lanzarErro(LIBRERIA_NON_ATOPADA);
                                                erro = 1;
                                                $$ = NAN;
                                            }
        | exp '(' ')'                       {
                                                lanzarErro(LIBRERIA_NON_ATOPADA);
                                                erro = 1;
                                                $$ = NAN;
                                            }
        | LIB '(' exp ')'                   {
                                                lanzarErro(SINTAXE_NON_VALIDA);
                                                erro = 1;
                                                $$ = NAN;
                                            }
        | LIB '(' exp ',' exp ')'           {
                                                lanzarErro(SINTAXE_NON_VALIDA);
                                                erro = 1;
                                                $$ = NAN;
                                            }
        | LIB '(' ')'                       {
                                                lanzarErro(SINTAXE_NON_VALIDA);
                                                erro = 1;
                                                $$ = NAN;
                                            }
        | FUNC '(' exp ')'                  {
                                                lanzarErro(SINTAXE_NON_VALIDA);
                                                erro = 1;
                                                $$ = NAN;
                                            }
        | FUNC '(' exp ',' exp ')'          {
                                                lanzarErro(SINTAXE_NON_VALIDA);
                                                erro = 1;
                                                $$ = NAN;
                                            }
        | FUNC '(' ')'                      {
                                                lanzarErro(SINTAXE_NON_VALIDA);
                                                erro = 1;
                                                $$ = NAN;
                                            }
;
%%
void yyerror(char *s) {
    printf("Erro na análise sintáctica: %s\n", s);
}

void cambiarEcho(int valor) {
    facerEcho = valor;
    if (facerEcho) {
        printf(VERDE"Echo activado."RESET"\n\n");
    } else {
        printf(ROJO"Echo desactivado."RESET"\n\n");
    }
}

void executandoScript(int valor) {
    script = valor;
    if (!script) {
        printf("\n"VERDE"Script executado correctamente."RESET"\n\n"CYAN">"RESET" ");
    }
}