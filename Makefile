# Opcións de compilación: mostra todos os warnings (-Wall)
CC=gcc -Wall

# Carpeta das cabeceiras
HEADER_FILES_DIR = .

# Opcións de compilación: indica onde están os ficheiros .h
INCLUDES = -I $(HEADER_FILES_DIR)

# Nome do executable
OUTPUT = nicalc

# Nome do ficheiro de flex
FLEX_FILE = flex.l

# Ficheiros .h
LIB_HEADERS = definicions.h lex.yy.h nicalc.h taboaSimbolos.h avl.h xestionErros.h

# Ficheiros .c
SRCS = main.c lex.yy.c nicalc.c taboaSimbolos.c avl.c xestionErros.c

# Ficheros .o: todos os .o cun análogo .c en SRCS
OBJS = $(SRCS:.c=.o)


# REGRA 1: xera o executable, dependencia dos .o
# Tras xeralos borra os .o
$(OUTPUT): $(OBJS)
	$(CC) -o $(OUTPUT) $(OBJS)
	rm *.o

# REGRA 2: xera os .o cando é necesario, dependencia dos .c e .h
# $@ é o nome do ficheiro que se xera coa regra (.o)
# $< é o nome do primeiro prerrequisito (o arquivo .c cuxo .o se está xerando)
%.o: %.c $(LIB_HEADERS)
	$(CC) -c -o $@ $< $(INCLUDES)

# REGRA 3: xera o código correspondente ao ficheiro de flex
flex:
	flex $(FLEX_FILE)
	cp lex.yy_copia.h lex.yy.h

# REGRA 4: borra o executable
clean:
	rm -f $(OUTPUT)
