*******************
* Claudia Antoniow
*******************
* Fecha:05/11/2002
*******************
* Actualizado:
*********************************************************************************************************
mret=sqlexec(mcon1,"SELECT * FROM medpresta " + ;
				   "WHERE codmed = ?mncodmed " + ;
				   "Group by diasem " + ;
				   "ORDER BY diasem ","MwkDiaTrab")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	CANCEL	
endif