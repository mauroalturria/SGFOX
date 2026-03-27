*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************


mret = sqlexec(mcon1, "DELETE FROM turnos " + ;
				"WHERE turnos.codmed = ?mncodmed " + mcbuqdiasem + ;
				" turnos.fechatur between ?mfecturno1 and ?mfecturno2 ")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0

endif	