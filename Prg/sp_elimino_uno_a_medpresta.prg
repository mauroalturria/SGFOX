*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
******************************************************
******************************************************
* AUTOR:Claudia Antoniow
* FECHA:01/10/2001
**************************
* MODIFICACION:02/06/2003
**************************
* hago un delete del registro de medico -prestaciones
******************************************************
*do sp_conexion.prg
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif

mret=sqlexec(mcon1,"DELETE FROM medpresta WHERE codmed = ?mncodmed and codesp = ?mccodesp " + ;
				   "and codprest = ?mncodprest and diasem is null " + mccpoamb)

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
endif
