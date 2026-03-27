*
* Nombre del Paciente desde REGISTRACIO
*
Lparameters mbusca

Use in select("mwkdat")

mret = sqlexec(mcon1,"select REG_nombrepac,REG_nroregistrac from Registracio"+;
	" where REG_nrohclinica = ?mbusca","mwkdat")

If mret < 0
	Messagebox("EN CONSULTA MAESTRO REGISTRACIO"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.
