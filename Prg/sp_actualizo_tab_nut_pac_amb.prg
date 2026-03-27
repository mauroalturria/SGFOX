*!*	-------------------------------------------------------------------------------------
*!*	Actualizo Datos de Alimentacion
*!*	-------------------------------------------------------------------------------------
Lparameters nopcion, mProto, mtiposer, mobserva, mcodfact, mid, mfechahoy, mmodi

If Type('mfechahoy')#"D"
	mfechahoy = sp_busco_fecha_serv('DD')
Endif
If Type('mmodi')#"N"
	mmodi = -1
Endif

if !used("mwkusuario")
	create cursor mwkusuario (idusuario c(20),codigovax n(7),password c(10),id n(2),nivel n(2),sector c(30),nomape c(30))
	insert into mwkusuario values ("CFUNES",54035,'',146,1,'SISTEMAS',"Carmencita")
endif
mcodvax	= mwkusuario.codigovax

Do Case

	Case nopcion = 1  &&&  alta o modificacion

		mret = SQLExec(mcon1, "select * " + ;
			"from TabNutPacAmb " + ;
			"where TNP_protocolo = ?mProto and " + ;
				"TNP_Fecha = ?mfechahoy and " + ;
				"TNP_CodServ = ?mtiposer","mwkexistepac")

		If mRet <= 0
			Messagebox("ERROR DE LECTURA",16,"ERROR")
			Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Return .F.
		Endif 
	
		If Reccount("mwkexistepac")>0
			mid = mwkexistepac.Id
			mmodif = Iif(((Alltrim(TNP_Observaciones) # Alltrim(mobserva) And !Empty(TNP_Observaciones));
				or TNP_Modi=1 Or mmodi=1) ;
				and !(TNP_Modi=0 And mmodi=0),1,0)

			mret = SQLExec(mcon1, "update TabNutPacAmb " + ;
				"set TNP_CodFact = ?mcodfact, " + ;
				"TNP_Observaciones = ?mobserva, " + ;
				"TNP_Usuario = ?mcodvax, " + ;
				"TNP_Modi = ?mmodif " + ;
				"where id = ?mid" )

			If mRet <= 0
				Messagebox("ERROR DE ACTUALIZACION",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Endif 
		Else
			mret = SQLExec(mcon1, "insert into TabNutPacAmb " + ;
				"(TNP_protocolo, TNP_Fecha, TNP_CodServ, TNP_CodFact, " + ;
				"TNP_Observaciones, TNP_Usuario, TNP_Modi ) " + ;
				"values " + ;
				"(?mProto,?mfechahoy,?mtiposer,?mcodfact, " + ;
				"?mobserva, ?mcodvax, 0) ")


			If mRet <= 0
				Messagebox("ERROR DE ACTUALIZACION",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Endif 
		Endif
		
*!*	-------------------------------------------------------------------------------------
	Case nopcion = 2  &&&  solo modificacion
		If Type('mid')#"N"
		
			mret = SQLExec(mcon1, "select * " + ;
				"from TabNutPacAmb " + ;
				"where TNP_protocolo = ?mProto and " + ;
					"TNP_Fecha = ?mfechahoy and " + ;
					"TNP_CodServ = ?mtiposer","mwkexistepac")

			If mRet <= 0
				Messagebox("ERROR DE LECTURA",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Endif 

			If Reccount("mwkexistepac")>0
				mid = mwkexistepac.Id
				mmodif = Iif(((Alltrim(TNP_Observaciones) # Alltrim(mobserva) And !Empty(TNP_Observaciones));
					or TNP_Modi=1 Or mmodi=1) ;
					and !(TNP_Modi=0 And mmodi=0),1,0)
					
				mret = SQLExec(mcon1, "update TabNutPacAmb " + ;
					"set TNP_CodFact = ?mcodfact, " + ;
						"TNP_Observaciones = ?mobserva, " + ;
						"TNP_Usuario = ?mcodvax, " + ;
						"TNP_Modi = ?mmodif " + ;
					"where id = ?mid" )

				If mRet <= 0
					Messagebox("ERROR DE ACTUALIZACION",16,"ERROR")
					Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Return .F.
				Endif 					
			Else
				mret = SQLExec(mcon1, "insert into TabNutPacAmb " + ;
					"(TNP_protocolo, TNP_Fecha, TNP_CodServ, TNP_CodFact, " + ;
					"TNP_Observaciones, TNP_Usuario, TNP_Modi ) " + ;
					"values " + ;
					"(?mProto, ?mfechahoy, ?mtiposer, ?mcodfact, " + ;
					"?mobserva, ?mcodvax, 0 )")
					
				If mRet <= 0
					Messagebox("ERROR DE ACTUALIZACION",16,"ERROR")
					Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Return .F.
				Endif 
			Endif
		Else
			mret = SQLExec(mcon1, "update TabNutPacAmb " + ;
				"set TNP_CodFact = ?mcodfact, " + ;
				"TNP_Observaciones = ?mobserva, " + ;
				"TNP_Usuario = ?mcodvax " + ;
				"where id = ?mid" )

			If mRet <= 0
				Messagebox("ERROR DE ACTUALIZACION",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Endif 
		Endif
*!*	-------------------------------------------------------------------------------------
	Case nopcion = 3  &&&  BAJA
		mret = SQLExec(mcon1, "delete from TabNutPacAmb where id = ?mid" )
		If mRet <= 0
			Messagebox("ERROR DE ACTUALIZACION",16,"ERROR")
			Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Return .F.
		Endif 
	Endcase
