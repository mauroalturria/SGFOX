**** traslado/alta pacientes sap
Lparameters xtipo,xmnroadm,musumod,mespec

*Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
If Vartype(mespec)#"C"
	mespec = ''
Endif
Set Step On
If Vartype(musumod)#"C"
	musumod=''
Endif
miresp ="AUN NO ESTA EN LINEA"
If mwkAdmonline.estado = 1
	mnroadm = xmnroadm
	Private mresultado, merror,cprov(25)
	Dimension cprov(25)

	mRet = SQLExec(mcon1,"SELECT Pacientes.*,Motivoegreso.MTE_Descripcion "+;
		"FROM  Pacientes INNER JOIN Motivoegreso  ON  PAC_motivoalta = MTE_CodMotivo "+;
		" WHERE  PAC_codadmision  = ?mnroadm ","mwkpacsap")
	mRet = SQLExec(mcon1,"SELECT Lugarintern.*, Sectores.SEC_habitsala"+;
		" FROM Lugarintern INNER JOIN SQLUser.SECTORES Sectores "+;
		" ON  Lugarintern.LUG_codsector = Sectores.SEC_codsector "+;
		" WHERE  LUG_PACIENTES = ?mnroadm "+;
		" ORDER BY LUG_fechaingreso,LUG_horaingreso  " ,"mwklugarinterna")
	Select mwklugarinterna
	If Reccount('mwklugarinterna')>1
		Scan

			m1 = "X"
			m2 = ""
			m3 = Alltrim(mnroadm )

			Select mwklugarinterna
			mfecingr = Alltrim(Transform(mwklugarinterna.LUG_fechaingreso))
			m4 = mfecingr
			m5 = Right("0"+Alltrim(Ttoc(mwklugarinterna.LUG_horaingreso,2)),8)
			m6 = mespec
			m7 = Alltrim(mwklugarinterna.lug_codsector)
			m8 = Alltrim(mwklugarinterna.sec_habitsala)
			m9 = Alltrim(mwklugarinterna.lug_habitacion)
			m10= Alltrim(mwklugarinterna.lug_cama)
			m11= Alltrim(mwklugarinterna.lug_categoria)
			m12= ''
			m13= ''
			m14= ''
			m15= ''
			m16= Transform(mwkusuario.codigovax)
			m17= musumod
			m18= ''



			mccampos = ''
			For I = 1 To 18
				mccampos = mccampos +Evaluate("m" + Alltrim(Transform(I)))+Iif(I<18,",","")
			Next

			mresultado = 0
			merror = 0
			mcopt = ''
			musuario = mwkusuario.idusuario
*If !Used("mwkservprueba")
*	Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
			Go Top In mwkservprueba
			If mwkservprueba.estado = 1
				miconex = Sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )
			Else
				miconex = mcon1
			Endif

			mRet = SQLExec(miconex ,"CALL WS.AProcesarSP_GrabaAProcesar('SI_PO_0011_Integra_Translado_Out',3,?mccampos,?musuario,?@mresultado, ?@merror","C1")
			If 	miconex # mcon1
				SQLDisconnect(miconex)
			Endif
			miresp = "Resultado : " + Transform(mresultado)+"Error : " + Transform(merror)
			m6 = mespec
			mccampos = ''
			For I = 1 To 18
				mccampos = mccampos +Evaluate("m" + Alltrim(Transform(I)))+Iif(I<18,",","")
			Next

			mresultado = 0
			merror = 0
			mcopt = ''
			musuario = mwkusuario.idusuario
*If !Used("mwkservprueba")
*	Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
			Go Top In mwkservprueba
			If mwkservprueba.estado = 1
				miconex = Sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )
			Else
				miconex = mcon1
			Endif

			mRet = SQLExec(miconex ,"CALL WS.AProcesarSP_GrabaAProcesar('SI_PO_0011_Integra_Translado_Out',3,?mccampos,?musuario,?@mresultado, ?@merror","C1")
			If 	miconex # mcon1
				SQLDisconnect(miconex)
			Endif
			miresp = "Resultado : " + Transform(mresultado)+"Error : " + Transform(merror)
		Endscan
	Endif
	If xtipo=2
		Select mwklugarinterna
		Go Bottom
		m1 = ""
		m2 = "X".
		Do sp_busco_denuncia_ob With 2," PO_admision = ?mnroadm "
		Select mwkobito
		Go Bottom
		Select mwklugarinterna
		mfecegr = Alltrim(Transform(mwklugarinterna.lug_fechaegreso))
		m4 = mfecegr
		m5 = Right("0"+Alltrim(Ttoc(mwkpacsap.pac_horaalta,2)),8)
		m6 =  mespec
		m7 = Alltrim(mwklugarinterna.lug_codsector)
		m8 = Alltrim(mwklugarinterna.sec_habitsala)
		m9 = Alltrim(mwklugarinterna.lug_habitacion)
		m10= Alltrim(mwklugarinterna.lug_cama)
		m11= Alltrim(mwklugarinterna.lug_categoria)
		Do sp_busco_medico_datos With mwkobito.po_codmed
		m12= Alltrim(Strtran(Nvl(mwkmeddat.cuiL,''),"-",""))
		m13 = Iif(Vartype(mwkpacsap.PAC_motivoalta) = "N",Alltrim(Str(mwkpacsap.PAC_motivoalta)),mwkpacsap.PAC_motivoalta)
*		m13= Iif(mwkpacsap.PAC_motivoalta=6,"M","V")
		m14 = '09'
		If Vartype(mcodcie)#"C"

			m15= Iif(!Isnull(mwkobito.codcie10),Transform(mwkobito.codcie10),Nvl(mwkpacsap.codcie10,''))
		Else
			m15= Iif(mcodcie = '','',Alltrim(Transform(mcodcie)))
		Endif

		m16= Transform(mwkusuario.codigovax)
		m17= musumod

		mccampos = ''
		For I = 1 To 17
			mccampos = mccampos +Evaluate("m" + Alltrim(Transform(I)))+Iif(I<17,",","")
		Next

		mresultado = 0
		merror = 0
		mcopt = ''
		musuario = mwkusuario.idusuario
*If !Used("mwkservprueba")
*	Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
*Endifndif
		Go Top In mwkservprueba
		If mwkservprueba.estado = 1
			miconex = Sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )
		Else
			miconex = mcon1
		Endif

		mRet = SQLExec(miconex ,"CALL WS.AProcesarSP_GrabaAProcesar('SI_PO_0011_Integra_Translado_Out',3,?mccampos,?musuario,?@mresultado, ?@merror","C1")
		If 	miconex # mcon1
			SQLDisconnect(miconex)
		Endif
		miresp = "Resultado : " + Transform(mresultado)+"Error : " + Transform(merror)
	Endif


Endif

Return miresp
