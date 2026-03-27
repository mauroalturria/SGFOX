*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
 
use in select('MwkExisteEspecial')
	
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and a.codambito = ?mxambito "
endif
mret = sqlexec(mcon1,"SELECT a.codesp, b.ESP_descripcion " + ;
			"FROM medpresta as a, Especialid as b " +;
			"WHERE a.codmed = ?mncodmed and a.codesp = trim(b.ESP_codesp) AND " + ;
			" a.diasem is not Null " + mccpoamb+;
			"GROUP BY a.codesp " + ;
			"ORDER BY b.ESP_descripcion","MwkExisteEspecial")

if mret < 0
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion") 
	mret=0	
endif