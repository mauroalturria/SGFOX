*
* Esquemas Oncologia - nuevo modelo
*
Lparameters lmForm

*!*	TabEsqCabe   : cabecera del esquema
*!*	TabEsqIndic  : observaciones / indicaciones
*!*	TabEsqQuimio : medicacion quimioterapia

*Set Step On

With lmForm.PGDatos

	With .Page1
		mNombEsq  = .txtesqnombre.Value
		mFormula  = mwkformulas.subestado
		mDias     = .txtesqdias.Value
		mPasiva   = '1900-01-01'
		mlFechor  = sp_busco_fecha_serv("DT")
		mlUsuario = Alltrim(mwkusuario.idusuario)
	Endwith

	If lmForm.regEsq = 0 && Alta

		mret = SQLExec(mcon1,"insert into TabEsqCabe (TEC_nombre, TEC_formula, TEC_diasesq, TEC_fpasiva, TEC_idusuario, TEC_fechor)"+;
			" values (?mNombEsq, ?mFormula, ?mDias, ?mPasiva, ?mlUsuario, ?mlFechor)")

		If mret < 0
			Messagebox("EN LA CARGA DE ESQUEMAS - CABECERA"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Else
			Use In Select("mwkesqctrl")
			mret = SQLExec(mcon1,"select id as lid from TabEsqCabe where TEC_idusuario = ?mlUsuario and TEC_fechor = ?mlFechor","mwkesqctrl")
			If mret < 0
				Messagebox("EN BUSQUEDA DE DATOS, DEL ESQUEMA"+Chr(10)+;
					"INGRESADO - AVISE A SISTEMAS -",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Return .F.
			Else
				mlid = mwkesqctrl.lid
			Endif
			Use In Select("mwkesqctrl")
			mError = .F.

			Select mwkdatosCab
			Go Top
			Scan All
				If !Deleted()
					mldia = mwkdatosCab.lDia
					mindp = Alltrim(mwkdatosCab.indica)
					mprem = Alltrim(mwkdatosCab.premed)
					mposm = Alltrim(mwkdatosCab.posmed)

					mret = SQLExec(mcon1,"insert into TabEsqIndic (TEI_idesquema, TEI_diaesq, TEI_indprevia, TEI_premedica, TEI_posmedica, TEC_fpasiva, TEC_idusuario, TEC_fechor)"+;
						" values (?mlid, ?mldia, ?mindp, ?mprem, ?mposm, ?mPasiva, ?mlUsuario, ?mlFechor)")

					If mret < 0
						Messagebox("EN LA CARGA DE INDICACIONES DEL ESQUEMA, DIA "+Alltrim(Transform(mldia))+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						mError = .T.
						Exit
					Endif
				Endif
			Endscan
			If mError
				Return .F.
			Endif
			Select mwkdatosDias
			Go Top
			Scan All
				If !Deleted()
					If mwkdatosDias.TFI_fecpasiva =  Dtot({//})

						mldia = mwkdatosDias.lDia
						mInsc = mwkdatosDias.TCI_insumocodigo
						mPact = Alltrim(mwkdatosDias.TCI_insumodescrip)
*
*                       2020-02-07
*                       dosisunidad N(9,2),udosisunidad C(12),;
* 						mDsUn  = Alltrim(mwkdatosDias.dosisunidad)

						mDsUn  = mwkdatosDias.dosisunidad            && TEQ_dosisunidad
						muDsUn = Alltrim(mwkdatosDias.udosisunidad)  && TEQ_udosisunidad

						mSolu = Alltrim(mwkdatosDias.solucion)
						mTemp = mwkdatosDias.tiempo
						mUTmp = mwkdatosDias.unidadtiempo
						mVolm = mwkdatosDias.volumen
						mUvol = mwkdatosDias.unidadvol
						mVias = mwkdatosDias.viasadm
						mObsv = Alltrim(mwkdatosDias.observ)

						If Vartype(mTemp) = "C"
							mTemp = Int(Val(mTemp))
						Endif

						mret = SQLExec(mcon1,"insert into TabEsqQuimio (TEQ_idesquema, TEQ_diaesq, TEQ_insumocodig, TEQ_pactivo, TEQ_dosisunidad, TEQ_solucion, TEQ_tiempo,"+;
							" TEQ_utiempo, TEQ_volumen, TEQ_uvolumen, TEQ_viasadm, TEQ_observ, TEQ_fpasiva, TEQ_idusuario, TEQ_fechor, TEQ_udosisunidad)"+;
							" values "+;
							"(?mlid, ?mlDia, ?mInsc, ?mPact, ?mDsUn, ?mSolu, ?mTemp, ?mUTmp, ?mVolm, ?mUvol, ?mVias, ?mObsv, ?mPasiva, ?mlUsuario, ?mlFechor, ?muDsUn)")

						If mret < 0
							Messagebox("EN LA CARGA DE MEDICACION, DIA "+Alltrim(Transform(mldia))   +Chr(10)+;
								"AVISE A SISTEMAS",16,"ERROR")
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
							mError = .T.
							Exit
						Endif
					Endif
				Endif
			Endscan
			If mError
				Return .F.
			Endif
		Endif

	Else

		mbus = lmForm.regEsq
		mlid = lmForm.regEsq

		mret = SQLExec(mcon1,"update TabEsqCabe set TEC_nombre = ?mNombEsq, TEC_formula = ?mFormula, TEC_diasesq = ?mDias, "+;
			"TEC_idusuario = ?mlUsuario, TEC_fechor = ?mlFechor where id = ?mbus")

		If mret < 0
			Messagebox("EN LA ACTUALIZACION DE ESQUEMAS - CABECERA"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Else

			mError = .F.
			Select mwkdatosCab
			Go Top
			Scan All

				mldia = mwkdatosCab.lDia
				mindp = Alltrim(mwkdatosCab.indica)
				mprem = Alltrim(mwkdatosCab.premed)
				mposm = Alltrim(mwkdatosCab.posmed)

				If mwkdatosCab.lRegistro > 0 && 2020-02-27, sólo para control, ya que el campo se incorporo posteriormente, prevalezco esquema y dia

					mret = SQLExec(mcon1,"update TabEsqIndic set "+;
						"TEI_indprevia = ?mindp," +;
						"TEI_premedica = ?mprem," +;
						"TEI_posmedica = ?mposm," +;
						"TEC_idusuario = ?mlUsuario," +;
						"TEC_fechor    = ?mlFechor" +;
						" where TEI_idesquema = ?mbus and TEI_diaesq = ?mldia")

				Else

					mret = SQLExec(mcon1,"insert into TabEsqIndic (TEI_idesquema, TEI_diaesq, TEI_indprevia, TEI_premedica, TEI_posmedica, TEC_fpasiva, TEC_idusuario, TEC_fechor)"+;
						" values (?mlid, ?mldia, ?mindp, ?mprem, ?mposm, ?mPasiva, ?mlUsuario, ?mlFechor)")

				Endif

				If mret < 0
					Messagebox("EN LA ACTUALIZACION DE INDICACIONES DEL ESQUEMA, DIA "+Alltrim(Transform(mldia))+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					mError = .T.
					Exit
				Endif

			Endscan
			If mError
				Return .F.
			Endif

*!*         2020-03-06

			mret = SQLExec(mcon1,"delete from TabEsqQuimio where TEQ_idesquema = ?mlid")

			If mret < 0
				Messagebox("EN DEPURACION DE MEDICACION"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				mError = .T.
			Else


				Select mwkdatosDias
				Go Top
				Scan All

*				If !Deleted()
*				mDsUn   = Alltrim(mwkdatosDias.dosisunidad)


					mldia   = mwkdatosDias.lDia
					mInsc   = mwkdatosDias.TCI_insumocodigo
					mPact   = Alltrim(mwkdatosDias.TCI_insumodescrip)
					mDsUn   = mwkdatosDias.dosisunidad
					muDsUn   = Alltrim(mwkdatosDias.udosisunidad)
					mSolu   = Alltrim(mwkdatosDias.solucion)
					mTemp   = mwkdatosDias.tiempo
					mUTmp   = mwkdatosDias.unidadtiempo
					mVolm   = mwkdatosDias.volumen
					mUvol   = mwkdatosDias.unidadvol
					mVias   = mwkdatosDias.viasadm
					mObsv   = Alltrim(mwkdatosDias.observ)

					If mwkdatosDias.TFI_fecpasiva = Dtot({//})
						mPasiva = '1900-01-01'
					Else
						mPasiva = Ttod(mwkdatosDias.TFI_fecpasiva)
					Endif

					If Vartype(mTemp) = "C"
						mTemp = Int(Val(mTemp))
					Endif

*!*				If mwkdatosDias.lidplani = 0

					If mwkdatosDias.TFI_fecpasiva =  Dtot({//})

						mret = SQLExec(mcon1,"insert into TabEsqQuimio (TEQ_idesquema, TEQ_diaesq, TEQ_insumocodig, TEQ_pactivo, TEQ_dosisunidad, TEQ_solucion, TEQ_tiempo,"+;
							" TEQ_utiempo, TEQ_volumen, TEQ_uvolumen, TEQ_viasadm, TEQ_observ, TEQ_fpasiva, TEQ_idusuario, TEQ_fechor, TEQ_udosisunidad)"+;
							" values "+;
							"(?mlid, ?mlDia, ?mInsc, ?mPact, ?mDsUn, ?mSolu, ?mTemp, ?mUTmp, ?mVolm, ?mUvol, ?mVias, ?mObsv, '1900-01-01', ?mlUsuario, ?mlFechor, ?muDsUn)")

						If mret < 0
							Messagebox("EN LA CARGA DE MEDICACION, DIA "+Alltrim(Transform(mldia))   +Chr(10)+;
								"AVISE A SISTEMAS",16,"ERROR")
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
							mError = .T.
							Exit
						Endif
					Endif

*!*				Else

*!*	*                   TEQ_idesquema   =?mlid,
*!*						mbusco = mwkdatosDias.lidplani
*!*						mret = SQLExec(mcon1,"update TabEsqQuimio set "+;
*!*							"TEQ_diaesq      = ?mlDia, "+;
*!*							"TEQ_insumocodig = ?mInsc, "+;
*!*							"TEQ_pactivo     = ?mPact, "+;
*!*							"TEQ_dosisunidad = ?mDsUn, "+;
*!*							"TEQ_solucion    = ?mSolu, "+;
*!*							"TEQ_tiempo      = ?mTemp, "+;
*!*							"TEQ_utiempo     = ?mUTmp, "+;
*!*							"TEQ_volumen     = ?mVolm, "+;
*!*							"TEQ_uvolumen    = ?mUvol, "+;
*!*							"TEQ_viasadm     = ?mVias, "+;
*!*							"TEQ_observ      = ?mObsv, "+;
*!*							"TEQ_fpasiva     = ?mPasiva, "+;
*!*							"TEQ_idusuario   = ?mlUsuario, "+;
*!*							"TEQ_fechor      = ?mlFechor, "+;
*!*							"TEQ_udosisunidad = ?muDsUn "+;
*!*							"where TabEsqQuimio.id = ?mbusco")

*!*						If mret < 0
*!*							Messagebox("EN LA ACTUALIZACION DE MEDICACION, DIA "+Alltrim(Transform(mldia))   +Chr(10)+;
*!*								"AVISE A SISTEMAS",16,"ERROR")
*!*							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*							mError = .T.
*!*							Exit
*!*						Endif

*!*					Endif

*!*	*				Endif
				Endscan
			Endif
			If mError
				Return .F.
			Endif
		Endif
	Endif
Endwith

Return .T.
