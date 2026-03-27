*!*	----------------------------------------------------------------------------------
*!*	Actualizo Datos de Alimentacion
*!*	----------------------------------------------------------------------------------
Lparameters nopcion, mfecreal

mdatetime = sp_busco_fecha_serv('DT')
mhoract = Hour(mdatetime)

Select mwkactualiza
Do While !Eof('mwkactualiza')

	mcodvax	= mwkusuario.codigovax
	mProto	= mwkactualiza.Protocolo

	If !Empty(mwkactualiza.TNP_CodFact1) Or !Empty(mwkactualiza.TNP_Observaciones1) OR ISNULL(mwkactualiza.indicaciones)

		mobserva	= mwkactualiza.TNP_Observaciones1
		mcodfact	= mwkactualiza.TNP_CodFact1
		mtiposer	= nopcion

		mret = SQLExec(mcon1, "select * " + ;
			"from TabNutPacAmb " + ;
			"where TNP_protocolo = ?mProto and " + ;
			"TNP_Fecha = ?mfecreal and " + ;
			"TNP_CodServ = ?mtiposer","mwkexistepac")

		If mret <= 0
			Messagebox("ERROR DE LECTURA ",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		If Reccount("mwkexistepac") > 0
		
			mid = mwkexistepac.Id
			mcodfact = Iif(Empty(mcodfact),mwkexistepac.TNP_CodFact,mcodfact )
			mmodif = Iif(((Alltrim(TNP_Observaciones) # Alltrim(mobserva) And !Empty(TNP_Observaciones));
				or TNP_Modi=1 ) ,1,0)
			If mhoract<13
				mret = SQLExec(mcon1, "update TabNutPacAmb set TNP_CodFact = ?mcodfact"+;
					",TNP_Observaciones = ?mobserva, TNP_Usuario = ?mcodvax, TNP_Modi = ?mmodif "+;
					",TNP_FecImp = ?mdatetime  where id = ?mid" )

				If mret <= 0
					Messagebox("ERROR DE ACTUALIZACION ",16,"ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Return .F.
				Endif
			Else
				mret = SQLExec(mcon1, "update TabNutPacAmb set TNP_Observaciones = ?mobserva"+;
					",TNP_Usuario = ?mcodvax , TNP_Modi = ?mmodif where id=?mid" )

				If mret <= 0
					Messagebox("ERROR DE ACTUALIZACION ",16,"ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Return .F.
				Endif

			Endif

		Else
			mmodif = Iif(!Empty(mobserva) And mtiposer>0 , 1, 0 )
&& VER
*			If Isnull(mwkactualiza.pac_fechaalta)
			If mhoract<13
				mret = SQLExec(mcon1, "insert into TabNutPacAmb (TNP_protocolo"+;
					",TNP_Fecha, TNP_FecImp, TNP_CodServ, TNP_CodFact, TNP_Observaciones, TNP_Usuario, TNP_Modi )"+;
					" values (?mProto, ?mfecreal, ?mdatetime, ?mtiposer, ?mcodfact, ?mobserva, ?mcodvax, ?mmodif )")

				If mret <= 0
					Messagebox("ERROR DE ACTUALIZACION ",16,"ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Return .F.
				Endif

			Else
				mret = SQLExec(mcon1, "insert into TabNutPacAmb (TNP_protocolo"+;
					",TNP_Fecha, TNP_FecImp, TNP_CodServ, TNP_CodFact, TNP_Observaciones, TNP_Usuario, TNP_Modi )"+;
					" values (?mProto, ?mfecreal, ?mdatetime, ?mtiposer, '', ?mobserva, ?mcodvax, ?mmodif  )")

				If mret <= 0
					Messagebox("ERROR DE ACTUALIZACION ",16,"ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Return .F.
				Endif

			Endif
*!*				Endif
		Endif
	Endif
	If !Empty(mwkactualiza.TNP_CodFact2) Or !Empty(mwkactualiza.TNP_Observaciones2)
		mobserva = mwkactualiza.TNP_Observaciones2
		mcodfact = mwkactualiza.TNP_CodFact2
		mtiposer = nopcion + 1
		
		mret = SQLExec(mcon1, "select * from TabNutPacAmb "+;
			"where TNP_protocolo = ?mProto and TNP_Fecha = ?mfecreal "+;
			" and TNP_CodServ = ?mtiposer","mwkexistepac")

		If mret <= 0
			Messagebox("ERROR DE LECTURA ",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		If Reccount("mwkexistepac")>0
			mid = mwkexistepac.Id
			mmodif = Iif(((Alltrim(TNP_Observaciones) # Alltrim(mobserva) And !Empty(TNP_Observaciones));
				or TNP_Modi = 1 ) ,1,0)

			mret = SQLExec(mcon1, "update TabNutPacAmb set TNP_CodFact = ?mcodfact "+;
				",TNP_Observaciones = ?mobserva, TNP_Usuario = ?mcodvax, TNP_Modi = ?mmodif  "+;
				",TNP_FecImp = ?mdatetime  where id = ?mid" )

			If mret <= 0
				Messagebox("ERROR DE ACTUALIZACION ",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Return .F.
			Endif

		Else
			mmodif = Iif(!Empty(mobserva) And mtiposer > 0 , 1, 0 )

&& ver
*			If Isnull(mwkactualiza.pac_fechaalta)
			mret = SQLExec(mcon1, "insert into TabNutPacAmb (TNP_protocolo"+;
				",TNP_Fecha, TNP_FecImp, TNP_CodServ, TNP_CodFact, TNP_Observaciones, TNP_Usuario, TNP_Modi )"+;
				" values (?mProto, ?mfecreal, ?mdatetime, ?mtiposer, ?mcodfact, ?mobserva, ?mcodvax, ?mmodif)")

			If mret <= 0
				Messagebox("ERROR DE ACTUALIZACION ",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Return .F.
			Endif

*			Endif
		Endif
	Endif
	Skip 1 In mwkactualiza
Enddo