Parameters mId, mCodEstadoN 

mret = Sqlexec(mcon1, "Update TabAmbulatorio Set CodEstado = ?mCodEstadoN where id = ?mId ")

If mret < 0
	Messagebox("ERROR AL CAMBIAR EL ESTADO "+chr(10)+;
		"AVISE A SISTEMAS",48,"VALIDACION")
	Return .f.	
Endif 
