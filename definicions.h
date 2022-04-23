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


#define SUMAIGUAL 306           // +=
#define RESTAIGUAL 307          // -=
#define MULTIGUAL 308           // *=
#define DIVIGUAL 309            // /=


#endif