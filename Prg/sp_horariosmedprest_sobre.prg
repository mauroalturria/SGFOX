*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
*****************************************************************************************
*** Busca en medpresta los horarios de un médico para extender los horarios normales ****
*****************************************************************************************
parameter mvcodmed

mret=sqlexec(mcon1,'SELECT Min(horadesde) as Horadesde,Max(Horahasta) as Horahasta FROM Medpresta ' +;
				   'WHERE codmed=?mvcodmed AND diasem=?mndiasem AND fecVigend <=?mtfechatur and ' +;
				   'fecVigenh >?mtfechatur '+;
				   'GROUP BY codmed ','MWKSOBRE')

if mret < 0
	messagebox('ERROR de Cursor, Avisar a sistemas',64,'Validación')
	mret=0
	
endif