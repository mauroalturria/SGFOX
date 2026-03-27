*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
mcafil		= 0
mncodent	= 0
mccodesp	= ''
mncodmed	= 334
mncodserv	= 0
mndiasem	= 2
mtfechatur	= ctod('15/04/2002')
mthorad		=datetime(2002,4,15,15,30,0)
*mthoraH=datetime(2002,3,23,12,15,0)
mntipotur	= 0
midusu 		= 'Cantoniow'
mususec		= 1

mret=sqlexec(mcon1,"INSERT INTO turnos (afiliado,codent,codesp,codmed,codserv,confirmado,diasem,fechatur,horatur,tipoturno,usuario, UsuarioSector ) " + ;
				   "VALUES (?mcafil,?mncodent,?mccodesp,?mncodmed,?mncodserv,0,?mndiasem,?mtfechatur,?mthorad,?mntipotur,?midusu,?mususec )")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
endif
