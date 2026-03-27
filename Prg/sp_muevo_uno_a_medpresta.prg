*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
**********************************************
* hago un insert del registro de prestaciones
* al de medico -prestaciones
**********************************************
*do sp_conexion.prg
mccampo = ''
mvcampo = ''
if mxambito >1
	mccampo = ", codambito "
	mvcampo = ", ?mxambito "
endif
fecaudi=sp_busco_fecha_serv('DT')
mret=SQLExec(mcon1,"INSERT INTO medpresta (codesp,codmed,codprest,codserv,usuario,fhgraba,canturnos &mccampo ) " + ;
	"values(?mccodesp,?mncodmed,?mncodprest,?mncodserv,?midusu,?fecaudi,?mncanttur &mvcampo )")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	Cancel
Endif

