****
**** verifico si existe descrip en tablas
****
	lparameters mcon1,cvalor

	mret = sqlexec(mcon1, 'select descrip from tabhcisector where descrip = ?cvalor','mwSectorDesc')

	if mret < 0 
  		MESSAGEBOX("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
   		Cancel
	endif