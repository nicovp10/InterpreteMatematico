#ifndef ANALIZADORSINTACTICO_H
#define ANALIZADORSINTACTICO_H


#define ROJO "\x1b[31m    "
#define VERDE "\x1b[32m    "
#define CYAN "\x1b[36m"
#define RESET "\x1b[0m"

typedef struct {
    int comp_lexico;
    char *lexema;
    union {
        double var;
        double (*funcptr)();
    } valor;
} CompLexico;

// Función que invoca ao intérprete de expresións de cálculo matemático
void nicalc();


#endif
