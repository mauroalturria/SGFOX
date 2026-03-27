*******************************
* AUTOR:Claudia Antoniow
* FECHA:20/08/2002
* Modificado Ult. Vez:20/08/2002
*******************************
********************************************************************
* Valida si ya se corrió el proceso de sobreturnos
********************************************************************
*do sp_conexion.prg
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif

mdHora_d=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(thorad),minute(thorad),0)
mdHora_h=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(thorah),minute(thorah),0)

mret = sqlexec(mcon1,"SELECT * FROM Turnos " + ;
	"WHERE &mccpoamb Tipoturno = 5 and codmed=?mncodmed and " + ;
	"fechatur = ?mtfechatur and horatur >=?mdHora_d and " + ;
	"horatur <=?mdHora_h",'MWKExisteTurno')

if mret < 0
	messagebox('ERROR DE CURSOR',16,'Validacion')
	mret=0
endif
*m=sqldisconnect(mcon1)
