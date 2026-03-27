*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
*****************************************************************************************
*** Busca en medpresta los horarios de un médico para extender los horarios normales ****
*****************************************************************************************
parameter mvcodmed

mret=sqlexec(mcon1,'SELECT * FROM Medpresta WHERE codmed=?mvcodmed AND diasem=?mndia','MWKHorario')

if mret < 0
	messagebox('ERROR de Cursor, Avisar a sistemas',64,'Validación')
	mret=0

endif