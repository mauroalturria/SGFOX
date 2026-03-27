Lparameters tnidantec, tcCodEsp, tcTipo, tcDescrip, tcIngreso

If tnidantec = 0
	mRet = Sqlexec(mcon1,"Insert into TabAntecedentes " + ;
		"( Ta_codesp, Ta_descrip, Ta_ingreso, Ta_tipo ) " + ;
		" Values " + ;
		"(?tcCodEsp, ?tcDescrip, ?tcIngreso, ?tcTipo ) ")
		
Else

	mRet = Sqlexec(mcon1,"Update TabAntecedentes Set " + ;
		"Ta_codesp = ?tcCodEsp, Ta_descrip = ?tcDescrip, " + ;
		"Ta_ingreso = ?tcIngreso, Ta_tipo = ?tcTipo " + ;
		"Where Id = ?tnidantec ")

Endif 


If mRet <= 0
	Messagebox("ERROR AL GUARDAR ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 