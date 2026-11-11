// Sin errores en cascada y funciones usadas como variables: 7 errores
//--------------------------------------------------------------------
int f() { return 1; }

int main()
{ int x; int a[3];

  print(a[z]);                    // Solo: no existe la variable "z"
  a[w] = 1;                       // Solo: no existe la variable "w"
  x = f(q);                       // Solo: no existe la variable "q"
  k[1] = 2;                       // Variable no declarada
  x = f;                          // Una funcion no es una variable
  f = 3;                          // Una funcion no es una variable
  read(f);                        // Una funcion no es una variable

  return 0;
}
