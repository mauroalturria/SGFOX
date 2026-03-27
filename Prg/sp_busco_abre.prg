****
**** verifico si existe descrip en tablas
****
	lparameters mcon1

	mret = sqlexec(mcon1, 'select * from tabhcisector' ,'mwkcAbrevio')

	if mret < 0 
  		MESSAGEBOX("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
   		Cancel
	ENDIF
	
	