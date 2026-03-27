****
** grabo valores de Datos
****
Lparameters ccampo

If vartype(ccampo) = "C"
	mret = sqlexec(mcon1, "Update TabDatos set "+ ccampo)
	If mret < 0
*!*		=aerr(eros)
*!*		Message(eros(3))
		Messagebox("EN ACTUALIZACION DE DATOS",16,"ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Endif
Endif

Return .T.
