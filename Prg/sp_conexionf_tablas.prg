****
**** Armo la Conexion a la base
****
	if messagebox('CONEXION 1 (Real)?',292,'CONEXION')=6
		mcon1 = sqlconnect('Conec02','_system','sys')
	else
		mcon1 = sqlconnect('Conecdt','_system','sys')
	endif

	if mcon1 < 0
		messagebox("ERROR DE CONEXION, AVISAR A SISTEMAS", 16, "Validación")
		cancel
	endif