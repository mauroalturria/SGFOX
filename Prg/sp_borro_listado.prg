****
** Busco Listado
****

Parameter mnroSP

mret = sqlexec(mcon1, "DELETE FROM SPListados where NroListado = ?mnroSP" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 18, "Validacion")
endif