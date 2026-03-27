Lparameters tnOpcion, tnId, tnEINN_idnecesidad, tcEINN_valor, tnEINN_usuario, tnEINN_idevol, tcEINN_observa, tnEINN_frecuencia

mFecHoy = sp_busco_fecha_serv("DT")
mFecNull = Ctod("01/01/1900")

Do Case

	Case tnOpcion = 1
		mRet = SQLExec(mcon1,"Insert into TabIntNeces " + ;
			"(EINN_idnecesidad ,  EINN_valor , EINN_usuario , EINN_fechaH , EINN_idevol , EINN_fpasiva ,  EINN_observa,EINN_frecuencia  ) " + ;
			"Values " + ;
			"(?tnEINN_idnecesidad, ?tcEINN_valor, ?tnEINN_usuario, ?mFecHoy, ?tnEINN_idevol, ?mFecNull,?tcEINN_observa, ?tnEINN_frecuencia) ")

	Case tnOpcion = 3
		mRet = SQLExec(mcon1,"Update TabIntNeces set EINN_fpasiva = ?mFecHoy Where Id = ?tnId")


Endcase

If mRet <= 0
	Messagebox("ERROR DE ACTUALIZACION - ANTECEDENTES",16,"ERROR")
	Return .F.
Endif
