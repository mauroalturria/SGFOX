*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
parameters mfechabusq,mnomcursor

mret=sqlexec(mcon1,'SELECT * FROM turnos WHERE codmed=?mncodmed AND fechatur = ?mfechabusq',mnomcursor)

if mret < 0
	messagebox('Error del Cursor, Avisar a Sistemas',64,'Validacion')
	mret=0

endif
