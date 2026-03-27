****
** busco Horas de validacion guardoa
****
mret = sqlexec(mcon1, "SELECT horas_medre FROM TabDatos ", "mwkhorasmedre")
if mret<1
	=aerr(eros)
	Message(eros(3))
endif
