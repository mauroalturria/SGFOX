Lparameters tnidEstado, tcDescrip, tnEstado, tnProp, tnSubEst, tnTipo

If tnidEstado = 0
	mRet = Sqlexec(mcon1,"Insert into TabEstados " + ;
		"( Descrip, Estado, Propietario, Subestado, Tipo ) " + ;
		" Values " + ;
		"(?tcDescrip, ?tnEstado, ?tnProp, ?tnSubEst, ?tnTipo ) ")
		
Else

	mRet = Sqlexec(mcon1,"Update TabEstados Set " + ;
		"Descrip = ?tcDescrip, Estado = ?Estado, " + ;
		"Propietario = ?tnProp, Subestado = ?tnSubEst, Tipo = ?tnTipo " + ;
		"Where Id = ?tnidEstado ")

Endif 


If mRet <= 0
	Messagebox("ERROR AL GUARDAR ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 