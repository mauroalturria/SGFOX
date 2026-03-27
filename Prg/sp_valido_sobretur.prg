*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* Modificado Ult. Vez:13/02/2002
*******************************
********************************************************************
* Valida si ya se corrió el proceso de sobreturnos
********************************************************************
*do sp_conexion.prg
mdHora_d=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(Mwksobre.horadesde),minute(Mwksobre.horadesde),0)
mdHora_h=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(Mwksobre.horahasta),minute(Mwksobre.horaHasta),0)
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif

mret=sqlexec(mcon1,"SELECT * FROM Turnos WHERE &mccpoamb Tipoturno=2 AND codmed=?mncodmed " + ;
	"AND fechatur = ?mtfechatur AND horatur between ?mdHora_d AND ?mdHora_h",'MWKExisteTurnoa')
select * from MWKExisteTurnoa where nvl(solicigia,0)<9 into cursor MWKExisteTurno 	


if mret < 0
	messagebox('ERROR DE CURSOR',16,'Validacion')
	mret=0
endif

*m=sqldisconnect(mcon1)
