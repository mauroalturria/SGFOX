Lparameters mId, mMedFirm, mCodPrest, mCodPun, mServVale, mEstado, ;
	mFAprob, mFInforme, mFRecep, mInfor, mInfPDF, mInfPDFG, ;
	mInfSoloT, mProtocolo, mNroVale, mTipoArch

If mid > 0
	
	mRet = Sqlexec(mcon1, "Update Informes Set " + ;
			"CodMedFirma = ?mMedFirm , " + ;
			"CodPrest = ?mCodPrest, " + ;
			"CodPun = ?mCodPun, " + ;
			"CodServVale = ?mServVale, " + ;
			"EstadoInforme = ?mEstado, " + ;
			"FechaAprobacion = ?mFAprob, " + ;
			"FechaInforme = ?mFInforme, " + ;
			"FechaRecepcion = ?mFRecep, " + ;
			"Informe = ?mInfor, " + ;
			"InformePDF = ?mInfPDF, " + ;
			"InformePDFGenerado = ?mInfPDFG, " + ;
			"InformeSoloTexto = ?mInfSoloT, " + ;
			"NroProtocolo = ?mProtocolo, " + ;
			"NroVale = ?mNroVale, " + ;
			"TipoArch = ?mTipoArch " + ;
			"Where id = ?mId" )

Else

	mRet = Sqlexec(mcon1, "Insert into Informes (" + ;
				"CodMedFirma, CodPrest, CodPun, CodServVale, EstadoInforme, " + ;
				"FechaAprobacion, FechaInforme, FechaRecepcion, Informe, " + ;
				"InformePDF, InformePDFGenerado, InformeSoloTexto, " + ;
				"NroProtocolo, NroVale, TipoArch ) " + ;
				"Values " + ;
				"(?mMedFirm, ?mCodPrest, ?mCodPun, ?mServVale, ?mEstado, " + ;
				"?mFAprob, ?mFInforme, ?mFRecep, ?mInfor, ?mInfPDF, ?mInfPDFG, " + ;
				"?mInfSoloT, ?mProtocolo, ?mNroVale, ?mTipoArch ) " )

Endif 			

If mRet <= 0
	Messagebox("ERROR AL ACTUALIZAR INFORMES",48,"VALIDACION")
	Aerror(EROS)
	Return .F.
Endif 