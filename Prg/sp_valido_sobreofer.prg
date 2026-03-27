*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* Modificado Ultima vez:13/02/2002
*******************************
********************************************************************
* Valida si ya se corrió el proceso de sobreoferta
********************************************************************

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
mdHora_d=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(Mwksobre.horadesde),minute(Mwksobre.horadesde),0)
mdHora_h=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(Mwksobre.horahasta),minute(Mwksobre.horaHasta),0)

mret=sqlexec(mcon1,"SELECT * FROM Turnos WHERE &mccpoamb codmed=?mncodmed AND fechatur = ?mtfechatur " + ;
	"AND Tipoturno =1 AND horatur >=?mdHora_d AND horatur <=?mdHora_h",'MWKExisteTurno')

if mret < 0
	messagebox('ERROR DE CURSOR',16,'Validacion')
	mret=0
endif

