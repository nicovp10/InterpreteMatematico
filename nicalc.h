#ifndef NICALC_H
#define NICALC_H


#define ROJO "\x1b[31m    "
#define VERDE "\x1b[32m    "
#define CYAN "\x1b[36m"
#define AMARILLO  "\x1b[33m    "
#define RESET "\x1b[0m"

typedef struct {
    int comp_lexico;
    char *lexema;
    union {
        double var;
        double (*funcptr)();
        void *libhandle;
    } valor;
} CompLexico;


// Función que invoca ao intérprete matemático
void nicalc(char *arg);


#endif
