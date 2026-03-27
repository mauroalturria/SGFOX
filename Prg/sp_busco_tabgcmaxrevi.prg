PARAMETERS mIdDoc

mret = sqlexec(mcon1," SELECT MAX(Revision) as IdMax FROM TabGcvincproc where idDoc = ?mIdDoc", "mwkGcMax" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ENDIF