#ifndef DEFINICIONS_H
#define DEFINICIONS_H


typedef struct {
    int comp_lexico;
    char *lexema;
    union {
        double var;
        double (*funcptr)();
    } valor;
} CompLexico;

#define COMANDO_SEN_PARAMETRO 300
#define COMANDO_CON_PARAMETRO 301
#define NUM 302
#define VAR 303
#define FUNC 304

#define SUMAIGUAL 305           // +=
#define RESTAIGUAL 306          // -=
#define MULTIGUAL 307           // *=
#define DIVIGUAL 308            // /=


#endif