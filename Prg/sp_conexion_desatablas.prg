****
**** Armo la Conexion a la base
****

	mcon1 = SQLCONNECT('Conecdt','_system','sys')
		if mcon1 < 0
		MESSAGEBOX("ERROR DE CONECCION, AVISAR A SISTEMAS", 16, "Validación")
   		Cancel
	endif
	