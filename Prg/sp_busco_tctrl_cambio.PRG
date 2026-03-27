*
* Busco tipos de control de cambio
*

Use in select("mwktipos")

mret = sqlexec(mcon1,"select distinct(tipo) as tipcambio"+;
	" from Tabestados"+;
	" where propietario = 102 and Estado = 1 order by tipo","mwktipos")

If mret < 0
	Messagebox("EN CONSULTA, TIPOS CONTROL DE CAMBIOS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.
