Lparameters mrevision
if vartype(mrevision) #"N"
	mrevision = 0
endif
mret = sqlexec(mcon1," SELECT ubicacion FROM TabGcproc where tipo = 9 and revision = ?mrevision  ", "mwkPathCopia" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ENDIF