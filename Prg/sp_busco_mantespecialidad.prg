*********************************************************************************
* Busco especialidad
*********************************************************************************
mret = sqlexec(mcon1,"select  * from TabMantEspecialidad","mwkMantEspecialidad")
	if mret < 1 
		=aerr(eros)
		messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')	
	endif
			