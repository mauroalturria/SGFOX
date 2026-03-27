*
* Desbloqueo de Derivaciones
*
* mid = mwkderiva1.id && ID derivación

Lparameters mid

mret = sqlexec(mcon1,"update TabDerivacion set vaxbloqreg = 0"+;
	" where id = ?mid")

If mret < 0
	Messagebox("EN DESBLOQUEO DE LA DERIVACION"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.
