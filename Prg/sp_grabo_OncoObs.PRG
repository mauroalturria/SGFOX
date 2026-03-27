
Lparameters tnOpcion, tnId, tcfechamov, tnidonco, tcobserva, tctipoobs, tcusuario

Do Case 
	Case tnOpcion = 1

		mRet = Sqlexec(mcon1,"insert into TabAmbOncoObs ( " + ;
			"Too_fechamov, Too_idonco, Too_observa, " + ;
			"Too_tipoobs, Too_usuario ) Values ( " + ;
			"?tcfechamov, ?tnidonco, ?tcobserva, ?tctipoobs, ?tcusuario " + ;
			")")
	
	Case tnOpcion = 2

		mRet = Sqlexec(mcon1,"Update TabAmbOncoObs Set " + ;
			"Too_fechamov = ?tcfechamov, " + ; 
			"Too_idonco = ??tnidonco, " + ; 
			"Too_observa = ?tcobserva, " + ;
			"Too_tipoobs = ?tctipoobs, " + ; 
			"Too_usuario = ?tcusuario " + ;
			"Where Id = ?tnId ")
		
	Otherwise 
		Return .f.
Endcase 

If mRet <= 0
	Messagebox("ERROR AL ACTUALIZAR OBS. ONCOLOGIA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 	
