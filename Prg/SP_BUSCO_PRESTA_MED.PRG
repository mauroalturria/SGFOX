*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
mret=sqlexec(mcon1,"SELECT a.codprest, b.PRE_descriprest, b.PRE_especialidad, "+;
	"a.codserv, a.diasem " + ;
	"FROM medpresta as a, prestacions as b " + ;
	"WHERE (a.codmed = ?mncodmed and a.codprest=b.PRE_codprest) AND a.diasem is not Null " + ;
	" and b.PRE_fechapasiva is null  "+;
	"ORDER BY b.PRE_descriprest ","Mwkdiasem")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0

endif
