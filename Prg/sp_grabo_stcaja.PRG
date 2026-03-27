Lparameters lnOpcion, lnId, lnboca, lnidedif, lnidrack, ;
	lcpachera, ltfechahora, lcidusuario, lnInterno, lnIdSector

Do Case 
	Case lnOpcion = 1
		If lnId = 0
			mRet = Sqlexec(mcon1,"Insert into TabStCaja (" + ;
				"Cj_boca, Cj_idedif, Cj_idrack, Cj_pachera, " + ;
				"Cj_fechahora, Cj_idusuario, CJ_Interno, CJ_IdSector )" + ;
				"Values (" + ;
				"?lnboca, ?lnidedif, ?lnidrack, ?lcpachera, " + ;
				"?ltfechahora, ?lcidusuario, ?lnInterno, ?lnIdSector " + ;
				")")
		Else
			mRet = Sqlexec(mcon1,"Update TabStCaja Set " + ;
				"Cj_boca = ?lnboca, Cj_idedif = ?lnidedif, " + ;
				"Cj_idrack = ?lnidrack, " + ;
				"Cj_pachera = ?lcpachera, Cj_fechahora = ?ltfechahora, " + ;
				"Cj_idusuario = ?lcidusuario, " + ;
				"CJ_Interno = ?lnInterno, CJ_IdSector = ?lnIdSector " + ;
				"Where Id = ?lnId ")
		Endif 		
Endcase 
		
If mRet <= 0
	Messagebox("ERROR DE ACTUALIZACION DE CAJAS ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 
	