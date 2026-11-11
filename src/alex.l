/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          <jbenedi@dsic.upv.es>   V.24    **/
/*****************************************************************************/
%{
#include "header.h"
#include "asin.h"

#define  retornar(x) {if (verbosidad) ECHO ; return (x) ; }
%}
/*----------------------------------------------------------------------
  Dado que las funciones "input()" y "unput(c)" son costosas y no las
  utilizaremos, evitaremos que se generen automaticamente sus rutinas
  correspondientes desactivandolas mediante las siguientes opciones:
----------------------------------------------------------------------*/
%option noinput
%option nounput
/*----------------------------------------------------------------------
  Para mantener el numero de linea actual en la variable global yylineno
----------------------------------------------------------------------*/
%option yylineno
/* Un solo fichero de entrada: no hace falta yywrap() ni enlazar con -lfl */
%option noyywrap

delimitador     [ \t\r\n]+
int             [0-9]+
/* MenosC admite constantes reales (3.5, 2., .34) y las trunca a entero */
float           {int}\.[0-9]*|\.{int}
digito          {int}|{float}
letra           [a-zA-Z]
id              {letra}({int}|{letra}|_)*
comentario      \/\/[^\n]*

%%

{delimitador} 	{ if (verbosidad) ECHO; }
{comentario}		{}

"+"				{ retornar(OPSUMA_); }
"-"				{ retornar(OPRESTA_); }
"*"				{ retornar(OPMULT_); }
"/"				{ retornar(OPDIV_); }
"&&"				{ retornar(OPAND_); }
"||"				{ retornar(OPOR_); }
"!"				{ retornar(OPNOT_); }

">"				{ retornar(COMPMAYOR_); }
"<"				{ retornar(COMPMENOR_); }
">="				{ retornar(COMPMAYORIG_); }
"<="				{ retornar(COMPMENORIG_); }
"=="				{ retornar(OPIGUAL_); }
"!="				{ retornar(OPDISTINTO_); }
"="					{ retornar(ASIG_); }

"for"				{ retornar(FOR_); }
"if"				{ retornar(IF_); }
"else"			{ retornar(ELSE_); }

"int"				{ retornar(INT_); }
"bool"				{ retornar(BOOL_); }

"read"				{ retornar(READ_); }
"print"				{ retornar(PRINT_); }
"return"				{ retornar(RETURN_); }

"true"				{ retornar(TRUE_); }
"false"				{ retornar(FALSE_); }

"{"				{ retornar(LLAVE1_); }
"}"				{ retornar(LLAVE2_); }
"("				{ retornar(PARENTESIS1_); }
")"				{ retornar(PARENTESIS2_); }
"["				{ retornar(CHT1_); }
"]"				{ retornar(CHT2_); }
";"				{ retornar(SEMICOLON_); }
","				{ retornar(COMA_); }


{digito}        { yylval.cent = atoi(yytext); retornar (CTE_) ; }
{id}            { yylval.ident = strdup(yytext); retornar(id_); }

. 					{ yyerror("Caracter desconocido") ;}
