*
* Actualizo medico de cabecera
*
Lparameters xmnroreg,xmimed

mret = sqlexec(mcon1,"update Registracio set REG_medicocabecera = ?xmimed "+;
	" where REG_nroregistrac = ?xmnroreg")

If mret < 0
	Messagebox("EN ACTUALIZACION DE medico de cabecera"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.









