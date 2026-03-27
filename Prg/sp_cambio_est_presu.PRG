Lparameters lnIdPresu, lnIdEstado

mret = sqlexec(mcon1, "UPDATE tabpresupuestos SET EstadoActual = ?lnIdEstado " +;
					  "WHERE id = ?lnIdPresu ")
					  
					  
If mret <= 0
	Aerror(eros)
	Messagebox("ERROR AL ACTUALIZAR",48,"VALIDACION")
	Return .F.
Endif 					  