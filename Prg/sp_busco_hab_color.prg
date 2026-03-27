mret = sqlexec(mcon1, "select * from  TabHabcolor ", "mwkCorcama")

If mret <= 0
	MessageBox("ERROR AL GENERAR EL CURSOR",48,"VALIDACION")
	Return .F.
Endif 
