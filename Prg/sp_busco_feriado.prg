*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
*****************************************************
* Busca a partir de una fechas si es feriados
******************************************************
Lparameters tcWhere,midia

If Vartype(tcWhere)<>"C"
	tcWhere = ""
Endif 	
If Vartype(midia)="D"
	mdmasx = midia
Endif 	

mret=sqlexec(mcon1,"SELECT dia " + ;
	"FROM feriaturnosA " + ;
	"WHERE dia = ?mdmasx " + tcWhere ,'MWKFeriados')

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION") 
    mret = 0	
	Return .f.
Endif

*m=sqldisconnect(mcon1)