Parameters mIdCondPago

mret = sqlexec(mcon1, "SELECT * "+;
	" FROM tabpcpago "+;
	" Where id = ?mIdCondPago ", "mwkpcpago")

If mret <= 0
	Messagebox("ERROR DE LECTURA", 48, "VALIDACION")
	Return .F.
Endif
