// Casos validos que antes se rechazaban por error: 0 errores
//-----------------------------------------------------------
int v[1];                         // array de talla 1

int cero()                        // funcion sin parametros
{
  return 0;
}

int main()
{ int x; bool b;

  x = -cero();                    // llamada sin argumentos y menos unario
  b = (x == 0) && (x != 1);       // igualdad entre enteros
  b = !b == false;                // negacion e igualdad entre logicos
  print(v[0] = x + 1);            // asignar a un elemento devuelve entero

  return x;
}
