*****
***** busco descrip en tablas
*****
Use in select(mcursor)

mret = sqlexec(mcon1,'select * from &marchivo order by descrip', '&mcursor')

*!*	If mcursor = 'mwkestudio'
*!*		mret = sqlexec(mcon1,'select * from TabEstudios order by descrip', 'mwkestudio')
*!*	Else
*!*		mret = sqlexec(mcon1,'select * from &marchivo where id<900000 order by descrip', '&mcursor')
*!*	Endif

If mret < 0
	Messagebox("ERROR AL CREAR EL CURSOR, REINTENTE", 16, "Validación")
	do log_errores with error(), message(), message(1), program(), lineno()
	Do prg_cancelo
Endif
