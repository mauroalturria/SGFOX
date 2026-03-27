****
**** verifico si existe descrip en tablas
****
	lparameters mconex,cvalor
	if type('mconex')#'N'
		mconex = mcon1
		ctabla = marchivo 
		ccampo = 'descrip'
		cvalor = mdesc
	endif
	mret = sqlexec(mconex, 'select abrevio from tabhcisector where abrevio = ?cvalor','mwSectorAbrev')

	if mret < 0 
  		MESSAGEBOX("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
   		Cancel
	endif