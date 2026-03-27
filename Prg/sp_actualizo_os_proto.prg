*
* Actualiza la Entidad del protocolo de atencion
*
parameters  mprot , mcodent

*set step on
mccpoamb = ''

if mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
endif
mret = sqlexec(mcon1, "update TabAmbulatorio set codent = ?mcodent "+;
	" where protocolo = ?mprot "+mccpoamb )

if mret < 0
	=aerror(merror)
	messagebox("EN actualizacion DE PROTOCOLO"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif
