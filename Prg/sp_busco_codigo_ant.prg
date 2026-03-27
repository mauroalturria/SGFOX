***
*** Busqueda de codigo telefonicos
***
lparameters mlegajo 
mret = sqlexec(mcon1, "select * from codigos " + ;
						"where legajo = ?mlegajo ", "mwkcodigo")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion") 
	do prg_cancelo
endif	