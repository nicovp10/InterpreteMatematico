# Intérprete matemático

## Introducción
Este intérprete matemático se ha realizado para aprender de forma didáctica la utilización de las herramientas `flex` y `bison` en un contexto específico. Los comandos del sistema y la ayuda del intérprete están, de momento, solamente en gallego.

Cabe destacar que este intérprete está en fase beta, por lo que los errores de sintaxis no están gestionados de forma óptima. La sintaxis y el léxico de este intérprete son los que cabe esperar de cualquier intérprete matemático.

El intérprete tiene definidas dos constantes: `pi` y `e`. Las constantes no se pueden modificar.

Las operaciones permitidas por defecto son las siguientes: suma (`+`), resta (`-`), multiplicación (`*`), división (`/`), módulo (`%`) y potencia (`^`). De todos modos se pueden añadir más operaciones mediante la importación de librerías. Por ejemplo: para importar la librería matemática se escribe el comando `importar libm.so.6`, y para usar sus funciones la sintaxis será `libm/FUNC`.

El intérprete admite como máximo funciones de dos parámetros, los cuales irán entre paréntesis y separados por una coma. Para usar las funciones de las librerías se usará de prefijo la parte del nombre del fichero de antes de la primera extensión, así al importar el fichero `libx.so`, sus funciones serán accesibles a través de `libx/FUNC`.


## Comandos
Para la ejecución de comandos hay dos tipos de sintaxis: con paréntisis y sin ellos. En los comandos sin parámetros sería `CMND` o `CMND()`, respectivamente; y en los comandos con un parámetro sería `CMND PARAM` o `CMND(PARAM)`, respectivamente.

Los comandos disponibles son:
* `axuda`: muestra la ayuda del intérprete. También se puede mostrar al iniciar el propio intérprete indicando la opción `-h`: `./nicalc -h`
* `cargar FICHERO`: carga y ejecuta un fichero. Este fichero debe respetar la sintaxis del intérprete y no podrá cargar otros ficheros desde él (en caso de que lo haga no se asegura el correcto funcionamiento del intérprete). También se pueden ejecutar ficheros al iniciar el propio intérprete indicándolo como argumento: `./nicalc FICHERO`
* `clear`: limpia la terminal de salida.
* `echo`: activa/desactiva la impresión de información de salida. Por defecto está activada.
* `importar LIBRERIA`: importa una librería de forma dinámica a través de su fichero .so. Si se indica solo el nombre, se buscará por orden en las rutas `/lib` y `/usr/lib`, sin embargo se pueden importar librerías indicando la ruta completa de su fichero .so.
* `limparws`: limpia el espacio de traballo.
* `sair`: sale del intérprete.
* `taboa`: muestra la tabla de símbolos, que contiene los comandos, constantes, funciones usadas alguna vez, librerías importadas y variables.
* `ws`: muestra el espacio de trabajo actual, que contiene las variables definidas hasta el momento.


## Instrucciones de ejecución
Para la ejecución del intérprete matemático se colocaran todos los archivos en un mismo directorio. Una vez colocados, se abrirá una terminal de Linux, se accederá al directorio con los archivos y se executará el comando `make` para compilarlo. Una vez compilado, el intérprete matemático se executará por terminal con el siguiente comando: `./nicalc`.
