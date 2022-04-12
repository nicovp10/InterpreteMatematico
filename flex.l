%{
#include "definicions.h"
#include "taboaSimbolos.h"
#include "xestionErros.h"
#define MAX_STR_CONST 500
CompLexico comp = {0, NULL};
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
LETTER              [a-zA-Z]|_

DECIMAL_DIGIT       [0-9]
DECIMAL_DIGITS      {DECIMAL_DIGIT}(_?{DECIMAL_DIGIT})*
BINARY_DIGIT        [01]
BINARY_DIGITS       {BINARY_DIGIT}(_?{BINARY_DIGIT})*
OCTAL_DIGIT         [0-7]
OCTAL_DIGITS        {OCTAL_DIGIT}(_?{OCTAL_DIGIT})*
HEX_DIGIT           [0-9a-fA-F]
HEX_DIGITS          {HEX_DIGIT}(_?{HEX_DIGIT})*

DECIMAL_LIT         0|[1-9](_?{DECIMAL_DIGITS})?
BINARY_LIT          0[bB]_?{BINARY_DIGITS}
OCTAL_LIT           0[oO]?_?{OCTAL_DIGITS}
HEX_LIT             0[xX]_?{HEX_DIGITS}

DECIMAL_EXPONENT    [eE][+-]?{DECIMAL_DIGITS}
HEX_MANTISSA        _?{HEX_DIGITS}\.{HEX_DIGITS}?|_?{HEX_DIGITS}|\.{HEX_DIGITS}
HEX_EXPONENT        [pP][+-]?{DECIMAL_DIGITS}

DECIMAL_FLOAT_LIT   {DECIMAL_DIGITS}\.{DECIMAL_DIGITS}?{DECIMAL_EXPONENT}?|{DECIMAL_DIGITS}{DECIMAL_EXPONENT}|\.{DECIMAL_DIGITS}{DECIMAL_EXPONENT}?
HEX_FLOAT_LIT       0[xX]{HEX_MANTISSA}{HEX_EXPONENT}

UNICODE_VALUE       [^\"\\']|\\(u{HEX_DIGIT}{4}|U{HEX_DIGIT}{8}|([abfnrtv\\'"]))
BYTE_VALUE          \\({OCTAL_DIGIT}{3}|x{HEX_DIGIT}{2})


/* Comentarios */
LINE_COMMENT        \/\/.*$
GENERAL_COMMENTS    \/\*(.|\n)*\*\/


/* Compoñentes léxicos */
IGNORAR             [ \t\r\n]

IDENTIFIER          {LETTER}({LETTER}|{DECIMAL_DIGIT})*

INDIVIDUAL          [+\-\*/%&\|\^<>=!~([{,\.)\]};:]
_ANGULARESESQ       <<
_ANGULARESDER       >>
_AMPEREXP           &\^
_SUMAIGUAL          \+=
_RESTAIGUAL         -=
_MULTIGUAL          \*=
_DIVIGUAL           \/=
_MODIGUAL           %=
_AMPERIGUAL         &=
_VERTIGUAL          \|=
_EXPIGUAL           \^=
_ANGULARESESQIGUAL  <<=
_ANGULARESDERIGUAL  >>=
_AMPEREXPIGUAL      &\^=
_AMPERDOBLE         &&
_VERTDOBLE          \|\|
_FRECHAESQ          <-
_SUMADOBLE          \+\+
_RESTADOBLE         --
_IGUALDOBLE         ==
_EXCLAMACIONIGUAL   !=
_MENORIGUAL         <=
_MAIORIGUAL         >=
_DOUSPUNTOSIGUAL    :=
_PUNTOTRIPLE        \.\.\.

_INT                {DECIMAL_LIT}|{BINARY_LIT}|{OCTAL_LIT}|{HEX_LIT}
_FLOAT              {DECIMAL_FLOAT_LIT}|{HEX_FLOAT_LIT}
_IMAGINARY          ({DECIMAL_DIGITS}|{_INT}|{_FLOAT})i

_RUNE               '({UNICODE_VALUE}|{BYTE_VALUE})'
_STRING             `(.|\n)*`|\"({UNICODE_VALUE}|{BYTE_VALUE})*\"


/* Condicións de arranque e regras asociadas aos erros a tratar */
%x C_RUNA C_STRING C_COMENTARIO_MULTILINEA

_FLOAT_EXPO_MAL_FORMADO                     ({DECIMAL_DIGITS}\.{DECIMAL_DIGITS}?|{DECIMAL_DIGITS}|\.{DECIMAL_DIGITS})[eE][+-]?[^0-9]
_IMAGINARY_MAL_FORMADO                      0[89]_?{DECIMAL_DIGITS}*[^i]
_RUNA_MOITOS_CARACTERES                     '({UNICODE_VALUE}|{BYTE_VALUE}){2,}'



%%

{IGNORAR}
{LINE_COMMENT}
{GENERAL_COMMENTS}

{IDENTIFIER}            return ID;

{INDIVIDUAL}            return (int) *yytext;
{_ANGULARESESQ}         return ANGULARESESQ;
{_ANGULARESDER}         return ANGULARESDER;
{_AMPEREXP}             return AMPEREXP;
{_SUMAIGUAL}            return SUMAIGUAL;
{_RESTAIGUAL}           return RESTAIGUAL;
{_MULTIGUAL}            return MULTIGUAL;
{_DIVIGUAL}             return DIVIGUAL;
{_MODIGUAL}             return MODIGUAL;
{_AMPERIGUAL}           return AMPERIGUAL;
{_VERTIGUAL}            return VERTIGUAL;
{_EXPIGUAL}             return EXPIGUAL;
{_ANGULARESESQIGUAL}    return ANGULARESESQIGUAL;
{_ANGULARESDERIGUAL}    return ANGULARESDERIGUAL;
{_AMPEREXPIGUAL}        return AMPEREXPIGUAL;
{_AMPERDOBLE}           return AMPERDOBLE;
{_VERTDOBLE}            return VERTDOBLE;
{_FRECHAESQ}            return FRECHAESQ;
{_SUMADOBLE}            return SUMADOBLE;
{_RESTADOBLE}           return RESTADOBLE;
{_IGUALDOBLE}           return IGUALDOBLE;
{_EXCLAMACIONIGUAL}     return EXCLAMACIONIGUAL;
{_MENORIGUAL}           return MENORIGUAL;
{_MAIORIGUAL}           return MAIORIGUAL;
{_DOUSPUNTOSIGUAL}      return DOUSPUNTOSIGUAL;
{_PUNTOTRIPLE}          return PUNTOTRIPLE;

{_INT}                  return INT;
{_FLOAT}                return FLOAT;
{_IMAGINARY}            return IMAGINARY;

{_RUNE}                 return RUNE;
{_STRING}               return STRING;


{_FLOAT_EXPO_MAL_FORMADO}           erro = 1; lanzarErro(yylineno, FLOAT_EXPO_MAL_FORMADO);
{_IMAGINARY_MAL_FORMADO}            erro = 1; lanzarErro(yylineno, IMAGINARY_MAL_FORMADO);
{_RUNA_MOITOS_CARACTERES}           erro = 1; lanzarErro(yylineno, RUNA_MOITOS_CARACTERES);
'                                   BEGIN(C_RUNA);
<C_RUNA><<EOF>>                     erro = 1; lanzarErro(yylineno, RUNA_NON_PECHADA); BEGIN(INITIAL);
\"|`                                BEGIN(C_STRING);
<C_STRING><<EOF>>                   erro = 1; lanzarErro(yylineno, STRING_NON_PECHADO); BEGIN(INITIAL);
\/\*                                BEGIN(C_COMENTARIO_MULTILINEA);
<C_COMENTARIO_MULTILINEA><<EOF>>    erro = 1; lanzarErro(yylineno, COMENTARIO_MULTILINEA_NON_PECHADO); BEGIN(INITIAL);
.                                   erro = 1; lanzarErro(yylineno, LEXEMA_DESCONOCIDO);

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

    if (!erro && comp.comp_lexico == ID) {
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
