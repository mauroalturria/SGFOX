Lparameters mOpcion, mId, mSn_IdSero, mSn_valor, mSn_fecha, mSn_Resu, mSn_Registracio 


Do Case
	Case mOpcion = 1
		ldfechoy  = sp_busco_fecha_serv('DT')
		ldFecNull = Ctod("01/01/1900")
 
		mRet = Sqlexec(mcon1,"Insert into TabAmbGestSerologia " + ;
			"(Sn_SeroId, Sn_valor, Sn_fechalabo, SN_Result, Sn_Registracio, Sn_fecha, sn_fechabaja, Sn_CodAmbito) Values " + ;
			"(?mSn_IdSero, ?mSn_valor, ?mSn_fecha, ?mSn_Resu, ?mSn_Registracio, ?ldfechoy, ?ldFecNull, ?mxambito)")

	Case mOpcion = 2

		mRet = Sqlexec(mcon1,"Update TabAmbGestSerologia Set " + ;
			"Sn_SeroId = ?mSn_IdSero, " + ;
			"Sn_valor = ?mSn_valor, Sn_fechalabo = ?mSn_fecha, " + ;
			"SN_Result = ?mSn_Resu, Sn_Registracio = ?mSn_Registracio " + ;
			"Where Id = ?mId")

	Case mOpcion = 3
		ldfechoy  = sp_busco_fecha_serv('DT')
		mRet = Sqlexec(mcon1,"Update TabAmbGestSerologia Set " + ;
			"sn_fechabaja = ?ldfechoy " + ;
			"Where Id = ?mId")	
EndCase
	

If mRet < 0
	Messagebox("ERROR DE ACTUALIZACION - SEROLOGIA.",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 