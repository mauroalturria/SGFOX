Lparameters tnOpcion, tnIdonco


Do Case
	Case tnOpcion = 1 
		mRet = Sqlexec(mcon1,"Select * from TabAmbOncoObs where too_idonco = ?tnIdonco ", "mwkOncoObs")
		
	Otherwise 
		Return .f.
Endcase 

If mRet <= 0
	Messagebox("ERROR DE LECTURA DE ONCOLOGIA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 