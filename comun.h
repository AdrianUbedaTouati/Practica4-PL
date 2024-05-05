/*----------------------- comun.h -----------------------------*/

/* fichero con definciones comunes para los ficheros .l y .y */

typedef struct {
   char *lexema;
   int nlin,ncol;
   int tipo;
   string cod;
} MITIPO;

#define YYSTYPE MITIPO


const int ERRYADECL=1,
	ERRNOMFUNC=2,
	ERRNOSIMPLE=3,
	ERRNODECL=4,
	ERRTIPOS=5,
	ERRNOENTEROIZQ=6,
	ERRNOENTERODER=7,
	ERRRANGO=8;

void errorSemantico(int nerror,char *lexema,int fila,int columna);
