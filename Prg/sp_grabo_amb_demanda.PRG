Lparameters mOpcion, lnIdAmb, lnDemanda, lnVale,lnestado

Do Case 

	Case mOpcion = 1

		mret = SQLExec(mcon1, "update TabAmbulatorio set " + ;
			"demanda = ?lnDemanda " + ;
			"where NroVale = ?lnVale")

	Case mOpcion = 2

		mret = SQLExec(mcon1, "update TabAmbulatorio set " + ;
			"demanda = ?lnDemanda " + ;
			"where Id = ?lnIdAmb")
Case mOpcion = 3

		mret = SQLExec(mcon1, "update TabAmbulatorio set " + ;
			"demanda = ?lnDemanda,codestado = ?lnestado " + ;
			"where Id = ?lnIdAmb")
Endcase
	
If mRet <= 0
	Messagebox("ERROR DE ACTUALIZACION DEMANDA AMB.",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 	