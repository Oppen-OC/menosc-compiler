// Errores que antes pasaban sin detectar: 6 errores
//--------------------------------------------------
int main()
{ int x; bool b; int a[3]; int c[3];

  read(z);                        // Variable no declarada
  x = x[1];                       // El identificador no es un array
  x = x(1);                       // El identificador no es una funcion
  a = c;                          // La variable debe ser de tipo simple
  b = !5;                         // No se puede negar un entero
  x = -true;                      // No se puede sumar/restar un logico

  return 0;
}
