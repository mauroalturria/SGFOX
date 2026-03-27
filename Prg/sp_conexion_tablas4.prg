****
**** Armo la Conexion a la base
****

	mcon4 = SQLCONNECT('Conec04','_system','sys')
		if mcon4 < 0
		MESSAGEBOX("ERROR DE CONECCION, AVISAR A SISTEMAS", 16, "Validación")
   		Cancel
	endif
	