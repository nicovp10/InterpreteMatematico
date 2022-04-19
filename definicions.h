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

#define ID 300
#define COMANDO_SEN_PARAMETRO 301
#define COMANDO_CON_PARAMETRO 302
#define NUM 303
#define VAR 304
#define FUNC 305

#define SUMAIGUAL 306           // +=
#define RESTAIGUAL 307          // -=
#define MULTIGUAL 308           // *=
#define DIVIGUAL 309            // /=


#endif