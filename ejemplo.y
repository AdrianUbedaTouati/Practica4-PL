/*------------------------------ ejemplo.y -------------------------------*/
%token print id 
%token opas opmd
%token numentero numreal pari pard
%token pyc coma

%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>


using namespace std;

#include "comun.h"

// variables y funciones del A. Léxico
extern int ncol,nlin,findefichero;


extern int yylex();
extern char *yytext;
extern FILE *yyin;


int yyerror(char *s);


const int ENTERO=1;
const int REAL=2;

string operador, s1, s2;  // string auxiliares

%}

%%


S    : print SExp pyc    { /* comprobar que después del programa no hay ningún token más */
                           int tk = yylex();
                           if (tk != 0) yyerror("");
			 }
     ;


SExp : SExp coma Exp     { cout << $3.cod << endl; }
     | Exp               { cout << $1.cod << endl; }
     ;


Exp : Exp opas Factor    { if (!strcmp($2.lexema,"+"))
                                  operador = "sum";
                           else
                                  operador = "res";
                           if ($1.tipo != $3.tipo)
                           {
                                 if ($1.tipo == ENTERO)
                                    s1 = "itor(" + $1.cod + ")";
                                 else
                                    s1 = $1.cod;
                                 if ($3.tipo == ENTERO)
                                    s2 = "itor(" + $3.cod + ")";
                                 else
                                    s2 = $3.cod;
                                 operador +="r";
                                 $$.tipo = REAL;
                                 $$.cod = operador + "(" + s1 + "," + s2 + ")";
                           }
                           else
                           {
                                 s1 = $1.cod;
                                 s2 = $3.cod;
                                 if ($1.tipo == REAL) 
                                    operador += "r";
                                 else
                                    operador += "i";
                                 $$.tipo = $1.tipo;
                                 $$.cod = operador + "(" + s1 + "," + s2 + ")";
                           }
                         }
        | Factor         /* $$ = $1 */
        ;

Factor : numentero           { $$.tipo = ENTERO;
                               $$.cod = $1.lexema;
                             }
       | numreal             { $$.tipo = REAL;
                               $$.cod = $1.lexema;
                             }
       | pari Exp pard       { $$.tipo = $2.tipo;
                               $$.cod = $2.cod;
                             }
       | id                  { $$.tipo  = ENTERO; // todas las variables son enteras
                               $$.cod = $1.lexema;
                             }
       ;

%%

void errorSemantico(int nerror,char *lexema,int fila,int columna)
{
    fprintf(stderr,"Error semantico (%d,%d): en '%s', ",fila,columna,lexema);
    switch (nerror) {
      case ERRYADECL: fprintf(stderr,"ya existe en este ambito\n");
         break;
      case ERRNOMFUNC: fprintf(stderr,"no puede llamarse igual que la funcion");
         break;
      case ERRNOSIMPLE: fprintf(stderr,"debe ser de tipo entero o real\n");
         break;
      case ERRNODECL: fprintf(stderr,"no ha sido declarado\n");
         break;
      case ERRTIPOS: fprintf(stderr,"tipos incompatibles entero/real\n");
         break;
      case ERRNOENTEROIZQ: fprintf(stderr,"el operando izquierdo debe ser entero\n");
         break;
      case ERRNOENTERODER: fprintf(stderr,"el operando derecho debe ser entero\n");
         break;
      case ERRRANGO: fprintf(stderr,"rango incorrecto\n");
         break;
    }
    exit(-1);
}


int yyerror(char *s)
{
    if (findefichero) 
    {
       errorSemantico(ERREOF,"",0,0);
    }
    else
    {  
       errorSemantico(ERRSINT,yytext,nlin,ncol-strlen(yytext));
    }
}

int main(int argc,char *argv[])
{
    FILE *fent;

    if (argc==2)
    {
        fent = fopen(argv[1],"rt");
        if (fent)
        {
            yyin = fent;
            yyparse();
            fclose(fent);
        }
        else
            fprintf(stderr,"No puedo abrir el fichero\n");
    }
    else
        fprintf(stderr,"Uso: ejemplo <nombre de fichero>\n");
}
