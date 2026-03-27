****
**** verifico si existe descrip en tablas
****
	lparameters mconex,ctabla,ccampo,cvalor
	if type('mconex')#'N'
		mconex = mcon1
		ctabla = marchivo 
		ccampo = 'descrip'
		cvalor = mdesc
	endif
	mret = sqlexec(mconex, 'select &ccampo from &ctabla where &ccampo = ?cvalor','mwkveodes')

	if mret < 0 
  		MESSAGEBOX("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
   		Cancel
	endif