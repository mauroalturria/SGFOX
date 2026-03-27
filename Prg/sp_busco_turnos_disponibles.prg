**************************
*Autor: Claudia Antoniow
**************************
*Fecha Creacion:20/08/2002
***************************
*Fecha Ult Modif:30/01/2003
***************************
parameters vr_horad,vr_horah
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

if !(isnull(vr_horad) and isnull(vr_horah))
	mret=sqlexec(mcon1,"select * from turnos where &mccpoamb codmed=?mncodmed and "+;
				"horatur between ?vr_horad and ?vr_horah  "+;
				"and fechatur=?mtfechatur and tipoturno=0 order by horatur ","MWKTurnosDisp")
else	
	vr_horad=Null
	vr_horah=Null
	mret=sqlexec(mcon1,"select * from turnos where &mccpoamb codmed=?mncodmed  "+;
				"and fechatur=?mtfechatur and tipoturno=0 order by horatur ","MWKTurnosDisp")
endif				
if mret <0
	messagebox('ERROR DE CURSOR Turnos Disponibles, REINTENTE',16,'VALIDACION') 
	mret=0
endif
