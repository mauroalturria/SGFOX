* Agrego en tabbeepers el ID del nuevo detalle para que se le pueda asignar un pin

Lparameters mGrabDescrip, mGrabSubestado, mGrabEstado

*!*	Lparameters mGrabTipo, mGrabSubestado
*!*
sqlgraba = "Select * From tabestados Where propietario = 84 and tipo = 2 And estado = ?mGrabEstado"
If !prg_ejecutosql(sqlgraba,"mwk_temp")
*!*		Return .F.
*!*		Endif
*!*
	Select mwk_temp
	Go Bottom
*!*
	mIdbee = mwk_temp.Id


*!*
*!*		sqlgraba = "INSERT INTO tabbeepers (BEE_Sector) VALUES (?mIdbee)"
*!*
*!*		If !prg_ejecutosql(sqlgraba)
*!*		Return .F.
*!*		Endif
*!*
*!*		Use In mwk_temp

	mHoraServ = SP_BUSCO_FECHA_SERV("DT")
	mHoraAlta = "1900-01-01"
	mUsuario = mwkusuario.codigovax
	mSectorID = mIdbee
	mNroPin = mGrabDescrip

*!*		sqlgraba = "Select * From tabestados Where propietario = 84 and tipo = ?mGrabTipo And estado = ?mGrabEstado And subestado = ?mGrabSubestado"
*!*	 	If !prg_ejecutosql(sqlgraba,"mwk_temp")
*!*		Return .F.
*!*		Endif
*!*
*!*		Select mwk_temp
*!*
*!*		mIdbee = mwk_temp.id

*	sqlgraba = "INSERT INTO tabbeepers (BEE_Sector) VALUES (?mIdbee)"

	Messagebox(mSectorID)
	Messagebox(Vartype(mSectorID))
	Messagebox(mNroPin)
	Messagebox(Vartype(mNroPin))

	sqlgraba = "INSERT INTO tabbeepers (BEE_Sector, BEE_CodVaxAlta, BEE_FecHAlta, BEE_FecHPasiva, BEE_Pin)"+;
		"values (?mSectorID, ?mUsuario, ?mHoraServ, ?mHoraAlta, ?mNroPin)"

	If !prg_ejecutosql(sqlgraba)
		Return .F.
	Endif

*	Use In mwk_temp
Endif 