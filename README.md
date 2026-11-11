# cmc — compilador de MenosC con Flex y Bison

Front-end de compilador para **MenosC**, un subconjunto de C con enteros, lógicos,
arrays, funciones, `if`/`else`, `for`, `read` y `print`. Lee un programa fuente,
hace el análisis léxico, sintáctico y semántico, y devuelve cada error con su
número de línea.

Proyecto de la asignatura *Lenguajes de Programación y Procesadores de Lenguajes*
(LPPL), Universitat Politècnica de València.

## Ejemplo

```c
// Errores que antes pasaban sin detectar: 6 errores
//--------------------------------------------------
int main()
{ int x; bool b; int a[3]; int c[3];

  read(z);
  x = x[1];
  x = x(1);
  a = c;
  b = !5;
  x = -true;

  return 0;
}
```

```
$ ./cmc tests/b06.c

Error en 6: Variable no declarada

Error en 7: El identificador no es un array

Error en 8: El identificador no es una función

Error en 9: La variable debe ser de tipo simple

Error en 10: Error de tipos en la expresión unaria, '!' requiere un lógico

Error en 11: Error de tipos en la expresión unaria, '+'/'-' requieren un entero

Numero de errores:      6
```

Con `-t` muestra la tabla de símbolos de cada función (niveles, desplazamientos,
tipos de los arrays y dominio de los parámetros). Con `-v` hace eco del fuente
mientras lo analiza.

## Cómo funciona

```
fuente.c ──► src/alex.l ──tokens──► src/asin.y ──────────► errores por línea
             (Flex)                 (Bison, LALR(1))
                                    acciones semánticas ◄──► tabla de símbolos
                                                             (libtds)
```

- **Léxico** ([src/alex.l](src/alex.l)): palabras reservadas, operadores,
  identificadores, constantes (las reales se truncan a entero, como pide la
  especificación) y comentarios `//`.
- **Sintáctico** ([src/asin.y](src/asin.y)): gramática LALR(1) sin conflictos, con
  la precedencia de operadores expresada por niveles, de menor a mayor: lógica
  (`&&`, `||`), igualdad, relacional, aditiva, multiplicativa, unaria y sufijo
  (índices y llamadas).
- **Semántico** (acciones en `asin.y`): cada expresión sintetiza su tipo y
  `T_ERROR` se propaga sin generar errores en cascada. Se comprueba:
  - declaraciones repetidas en el mismo ámbito (global / local de la función),
  - uso de identificadores no declarados, indexar algo que no es un array,
    llamar a algo que no es una función, usar una función como variable o
    asignar un array completo,
  - tipos en asignaciones, operadores, condiciones de `if`/`for`, `read` y `print`,
  - talla de los arrays y tipo entero del índice,
  - número y tipo de los argumentos frente a la declaración de la función,
  - tipo del `return` y existencia de una única `main`.
- Los desplazamientos de variables y parámetros se calculan durante el análisis
  (parámetros con desplazamiento negativo respecto al segmento de enlaces).

## Compilar y probar

Requiere Linux x86-64 (o WSL) con `gcc`, `make`, `flex` y `bison`; la librería
`lib/libtds.a` viene precompilada para esa arquitectura.

```sh
sudo apt install gcc make flex bison
make            # genera ./cmc
make test       # compara la salida de cada tests/*.c con tests/*.out
./cmc [-v] [-t] programa.c
```

Los programas `a*.c` de [tests/](tests/) son correctos y no deben dar errores; los
`b*.c` indican en su primera línea cuántos errores deben detectarse.

## Qué es mío y qué viene de la asignatura

- **Implementación propia:** el analizador léxico ([src/alex.l](src/alex.l)) y el
  sintáctico-semántico ([src/asin.y](src/asin.y)), la adaptación de
  [include/header.h](include/header.h) y los tests `a04`, `b06` y `b07`.
- **Proporcionado por la asignatura:** el programa principal
  ([src/principal.c](src/principal.c)), la librería de la tabla de símbolos
  (precompilada en [lib/libtds.a](lib/libtds.a), interfaz en
  [include/libtds.h](include/libtds.h)) y los casos de prueba `a00`–`a03` y
  `b00`–`b05`.

## Limitaciones

- Solo es el front-end: no genera código.
- Se detiene en el primer error sintáctico (no hay recuperación de errores con el
  token `error` de Bison); los errores semánticos sí se acumulan.
- Como pide la especificación de MenosC, `if` siempre lleva `else`.
