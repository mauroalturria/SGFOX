lParameters mId, mCodMed, mwhere

mret = Sqlexec(mcon1,"Update TabAmbulatorio Set CodMed = ?mCodMed where id = ?mId " + mwhere )

If mret <= 0
	Messagebox("ERROR AL ACTUALIZAR EL MEDICO ",48,"VALIDACION")
	Aerror(eros)
	Return .f.
Endif 
