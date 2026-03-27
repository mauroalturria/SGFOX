*****************************************************************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
******************************************************************************
* Genera una lista con las fechas que tienen Agenda generada el profesional
******************************************************************************

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret=sqlexec(mcon1,"UPDATE medpresta SET fechaUltAgenda=?mdmasX " +;
	"WHERE &mccpoamb diasem=?mddiasem AND Codmed =?mncodmed and hhmmdes =?mthorad "+;
	"and hhmmhas =?mthorah ")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0

endif
