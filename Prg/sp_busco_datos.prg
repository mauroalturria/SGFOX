****
** busco valores de Datos
****
mret = sqlexec(mcon1, "SELECT * FROM TabDatos ", "mwkDatos")
If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif  