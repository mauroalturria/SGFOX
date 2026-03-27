**************************
*Autor: Claudia Antoniow
**************************
*Fecha Creacion:20/08/2002
***************************
*Fecha Ult Modif:20/08/2002
***************************

mret = sqlexec(mcon1,"select * from turnos where codmed = ?mncodmed  " + ;
				"and fechatur = ?mtfechatur and tipoturno = 0 " + ;
				"order by horatur ","MWKTurnosDisp")
if mret <0 
	messagebox('ERROR DE CURSOR Turnos Disponibles, AVISAR A SISTEMAS',16,'VALIDACION') 
	mret=0
endif