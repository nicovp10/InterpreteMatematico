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


#define NUM 300
#define VAR 301
#define FUNC 302

#define SUMAIGUAL 302           // +=
#define RESTAIGUAL 304          // -=
#define MULTIGUAL 305           // *=
#define DIVIGUAL 306            // /=


#endif