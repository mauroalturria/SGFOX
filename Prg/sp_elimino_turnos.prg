*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
parameter mfectur, mhoratur

mhoratur=datetime(year(mfectur),month(mfectur),day(mfectur),hour(mhoratur),minute(mhoratur),0)

mret=sqlexec(mcon1,'DELETE FROM turnos WHERE codmed=?mncodmed AND fechatur=?mfectur AND horatur=?mhoratur AND afiliado =0')

if mret < 0
	messagebox('ERROR DE CURSOR,AVISAR A SISTEMAS',64,'VALIDACION')
	mret=0

endif