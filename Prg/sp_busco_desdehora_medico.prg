* Busca la hora desde del medico
*********************************************************************************************************
lparameters mncodmed, mdiasem

mret=sqlexec(mcon1,"SELECT * FROM medpresta " + ;
				   "WHERE codmed = ?mncodmed and diasem = ?mdiasem " + ;
				   "Group by diasem " + ;
				   "ORDER BY diasem ","MwkDiaTrab")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
endif