*********************************************************************************
* Busco reparacion
*********************************************************************************
mret = sqlexec(mcon1,"select  * from TabMantReparacion order by reparacion ","mwkMantReparacion")
	if mret < 1 
		=aerr(eros)
		messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')	
	endif
			