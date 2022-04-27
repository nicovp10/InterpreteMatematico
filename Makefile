# Opcións de compilación: mostra todos os warnings (-Wall)
CC=gcc -Wall

# Inclúusión das librerías estándares
LIBS = -lm -ldl

# Carpeta das cabeceiras
HEADER_FILES_DIR = .

# Opcións de compilación: indica onde están os ficheiros .h
INCLUDES = -I $(HEADER_FILES_DIR)

# Nome do executable
OUTPUT = nicalc

# Nome do ficheiro de flex
FLEX_FILE = flex.l

# Nome do ficheiro de bison
BISON_FILE = bison.y

# Nome do arquivo comprimido
ZIP_FILE = VilelaPerezNicolas_P3.zip

# Ficheiros .h
LIB_HEADERS = definicions.h nicalc.h lex.yy.h bison.tab.h system.h taboaSimbolos.h avl.h xestionErros.h

# Ficheiros .c
SRCS = main.c nicalc.c lex.yy.c bison.tab.c system.c taboaSimbolos.c avl.c xestionErros.c

# Ficheros .o: todos os .o cun análogo .c en SRCS
OBJS = $(SRCS:.c=.o)


# REGRA 1: xera o executable, dependencia dos .o
# Tras xeralos borra os .o
$(OUTPUT): $(OBJS)
	$(CC) -o $(OUTPUT) $(OBJS) $(LIBS)
	rm *.o

# REGRA 2: xera os .o cando é necesario, dependencia dos .c e .h
# $@ é o nome do ficheiro que se xera coa regra (.o)
# $< é o nome do primeiro prerrequisito (o arquivo .c cuxo .o se está xerando)
%.o: %.c $(LIB_HEADERS)
	$(CC) -c -o $@ $< $(INCLUDES)

# REGRA 3: xera o código correspondente ao ficheiro de flex
flex:
	flex $(FLEX_FILE)

# REGRA 4: xera o código correspondente ao ficheiro de bison
bison:
	bison -Wall -d $(BISON_FILE)
	cp bison.tab_copia.h bison.tab.h

# REGRA 5: xera un arquivo comprimido ZIP a partir do código fonte
zip:
	zip $(ZIP_FILE) Makefile README.md $(SRCS) $(LIB_HEADERS) $(FLEX_FILE) $(BISON_FILE)

# REGRA 6: borra o executable e o zip
clean:
	rm -f $(OUTPUT)
