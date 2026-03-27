*****
** Busco entidad - modalidad
*****

parameter mcodent


	mret = sqlexec(mcon1, "select * from EntidModalidad where codent = ?mcodent", "mwkmensaje") 
	
	if mret < 0
		messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS', 16,'Validacion')	
	endif	