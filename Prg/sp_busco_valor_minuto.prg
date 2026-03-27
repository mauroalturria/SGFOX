****
** busco valores de llamadas
****
mret = sqlexec(mcon1, "SELECT ValorMinutoCelular,ValorMinutoLocal FROM TabDatos ", "mwkvalorTE")
if mret<1
	=aerr(eros)
	Message(eros(3))
endif