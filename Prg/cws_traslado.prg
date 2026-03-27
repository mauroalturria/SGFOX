**** traslado/alta pacientes sap
Lparameters xtipo,xmnroadm,musumod,mespec,mbaja,mfecalta,mmotegr,mentsap,mimedcab

Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
If Vartype(mespec)#"C"
	mespec = ''
Endif
If mespec="EMER"
	mespec = 'CLIN'
Endif
If Vartype(mbaja)#"N"
	mbaja= 0
Endif
If Vartype(mentsap)#"N"
	mentsap = 0
ENDIF
If Vartype(mimedcab)#"N"
	mimedcab= 306
Endif
msech = ''

If Vartype(musumod)#"C"
	musumod=''
Endif
miresp ="AUN NO ESTA EN LINEA"
*If mwkAdmonline.estado =1 Or mwkusuario.codigovax = 54035
	mnroadm = xmnroadm
	Private mresultado, merror,cprov(25)
	Dimension cprov(25)
	mRet = SQLExec(mcon1,"SELECT Pacientes.*,Motivoegreso.MTE_Descripcion,Tabcie10.codcie10 "+;
		"FROM  Pacientes left JOIN Motivoegreso  ON  PAC_motivoalta = MTE_CodMotivo LEFT OUTER join Tabcie10 on Tabcie10.id = pac_codcie10diagegr "+;
		" WHERE  PAC_codadmision  = ?mnroadm ","mwkpacsap")
	mRet = SQLExec(mcon1,"SELECT Lugarintern.*, Sectores.SEC_habitsala"+;
		" FROM Lugarintern INNER JOIN SQLUser.SECTORES Sectores "+;
		" ON  Lugarintern.LUG_codsector = Sectores.SEC_codsector "+;
		" WHERE  LUG_PACIENTES = ?mnroadm "+;
		" ORDER BY LUG_fechaingreso,LUG_horaingreso  " ,"mwklugarinterna")
	Select mwklugarinterna
	Go Bott
	m1 = Iif(xtipo=1,"X","")
	m2 = Iif(xtipo=2,"X","")
	m3 = Alltrim(mnroadm )
	Do Case
	Case xtipo = 1
		If Reccount('mwklugarinterna')=1 And musumod = '9' And mwklugarinterna.lug_fechahoraingreso=Ctot(Dtoc(mwkpacsap.pac_fechaadmision)+" "+;
				TTOC(mwkpacsap.pac_horaadmision,2))
			Return
		Endif
		Select mwklugarinterna
		mfecingr = Alltrim(Transform(mwklugarinterna.LUG_fechaingreso))
		m4 = mfecingr
		m5 = Right("0"+Alltrim(Ttoc(mwklugarinterna.LUG_horaingreso,2)),8)
		If m5 = "00:00:00"
			m5 = "00:00:01"
		Endif

		m7 = Alltrim(mwklugarinterna.lug_codsector)
		m8 = Alltrim(mwklugarinterna.sec_habitsala)
		m9 = Alltrim(mwklugarinterna.lug_habitacion)
		m10= Alltrim(mwklugarinterna.lug_cama)
		m11= Alltrim(mwklugarinterna.lug_categoria)

		If Empty(mespec)
			Do sp_busco_estados With 25,' and tipo = 48 order by estado ','mwksECESP'
			Select mwksECESP
			midiesp = 1000
*	m7 = Alltrim(mwkpacint.sec_codsector)
			Scan
				If m7  $ Alltrim(mwksECESP.Descrip)
					midiesp = mwksECESP.estado
					Exit
				Endif
			Endscan
			mRet = SQLExec(mcon1,"SELECT * FROM ZapServEspec "+;
				" WHERE  NroServicio  = ?midiesp ","mwkespxpiso")
			mespec= mwkespxpiso.Codesp
		Endif
		m6 = mespec
		m12= ''
		m13= ''
		m14= ''
		m15= ''
		m16= Transform(mwkusuario.codigovax)
		m17= ''&&musumod
		m18= ''
		If !Empty(mespec)
			midusua = Iif(Used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)
			mcodadmision = mnroadm
			mfechap = Ctot(Dtoc(mwklugarinterna.LUG_fechaingreso)+" "+Ttoc(mwklugarinterna.LUG_horaingreso,2))
			mRet = SQLExec(mcon1, "insert into TabVerC (codadmision,control,fecha,prg, usuario, habcama) values "+;
				" ( ?mcodadmision,1,?mfechap,999, ?midusua, ?mespec)	")
		Endif

	Case xtipo = 2
		Do sp_busco_denuncia_ob With 2," PO_admision = ?mnroadm "
		Select mwkobito
		Go Bottom
		Select mwklugarinterna
		mfecegr = Alltrim(Transform(mwklugarinterna.lug_fechaegreso))
		m4 = mfecegr
		m5 = Right("0"+Alltrim(Ttoc(mwkpacsap.pac_horaalta,2)),8)
		If m5 = "00:00:00"
			m5 = "00:00:01"
		Endif
		
		m6 = mespec
		m7 = Alltrim(mwklugarinterna.lug_codsector)
		m8 = Alltrim(mwklugarinterna.sec_habitsala)
		m9 = Alltrim(mwklugarinterna.lug_habitacion)
		m10= Alltrim(mwklugarinterna.lug_cama)
		m11= Alltrim(mwklugarinterna.lug_categoria)
		Do sp_busco_medico_datos With mwkobito.po_codmed
		m12= Alltrim(Strtran(Nvl(mwkmeddat.cuiL,''),"-",""))
		m12 = Iif(Empty(m12),"99999999999",m12)
		m13 = Iif(Vartype(mwkpacsap.PAC_motivoalta) = "N",Alltrim(Str(mwkpacsap.PAC_motivoalta)),mwkpacsap.PAC_motivoalta)
*		m13= Iif(mwkpacsap.PAC_motivoalta=6,"M","V")
		m14 = '09'
		If Vartype(mcodcie)#"C"

			m15= Alltrim(Iif(!Isnull(mwkobito.codcie10),Transform(mwkobito.codcie10),Nvl(mwkpacsap.codcie10,'')))
		Else
			m15= Iif(mcodcie = '','',Alltrim(Transform(mcodcie)))
		Endif

		m16= Transform(mwkusuario.codigovax)
		m17= ''
		m18= ''
	Case xtipo = 3

		mfecingr = Left(mfecalta,10)
		m4 = mfecingr
		m5 = Alltrim(Right(mfecalta,8))
		If m5 = "00:00:00"
			m5 = "00:00:01"
		Endif
		m6 = ''
		m7 = ''
		m8 = ''
		m9 = ''
		m10= ''
		m11= ''
		m12= ''
		m13= Alltrim(Transform(mmotegr))
		m14= ''
		m15= ''
		m16= ''
		m17= ''
		m18= Iif(mbaja=1,"X","")
	Case xtipo = 101
		m1 = "X"
		Select mwklugarinterna
		Go Top
		fechahoraing = Ctot(Dtoc(mwkpacsap.pac_fechaadmision)+" "+Ttoc(mwkpacsap.pac_horaadmision,2))+10
		mfecingr = Alltrim(Transform(Ttod(fechahoraing )))
		m4 = mfecingr
		m5 = Right("0"+Alltrim(Ttoc(fechahoraing ,2)),8)
		IF m5 = "00:00:00"
			m5 = "00:00:01"
		endif

		m7 = Alltrim(mwklugarinterna.lug_codsector)
		m8 = Alltrim(mwklugarinterna.sec_habitsala)
		m9 = Alltrim(mwklugarinterna.lug_habitacion)
		m10= Alltrim(mwklugarinterna.lug_cama)
		m11= Alltrim(mwklugarinterna.lug_categoria)

		If Empty(mespec)
			Do sp_busco_estados With 25,' and tipo = 48 order by estado ','mwksECESP'
			Select mwksECESP
			midiesp = 1000
			Scan
				If m7  $ Alltrim(mwksECESP.Descrip)
					midiesp = mwksECESP.estado
					Exit
				Endif
			Endscan
			mRet = SQLExec(mcon1,"SELECT * FROM ZapServEspec "+;
				" WHERE  NroServicio  = ?midiesp ","mwkespxpiso")
			mespec= mwkespxpiso.Codesp
		Endif
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
		m17= ''&&musumod
		m18= ''
	Endcase

	mccampos = ''
	For I = 1 To 18
		mccampos = mccampos +Evaluate("m" + Alltrim(Transform(I)))+Iif(I<18,",","")
	Next

	mresultado = 0
	merror = 0
	mcopt = ''
	musuario = mwkusuario.idusuario
*If !Used("mwkservprueba")
	Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
*Endif
	Go Top In mwkservprueba
	mstringcon = Alltrim(mwkservprueba.Descrip)
	If mwkservprueba.estado = 1
		miconex = Sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )
	Else
		miconex = mcon1
	Endif
	mRet = SQLExec(miconex ,"CALL WS.AProcesarSP_GrabaAProcesar('SI_PO_0011_Integra_Translado_Out',3,?mccampos,?musuario,?@mresultado, ?@merror","C1")
	If 	miconex # mcon1
		SQLDisconnect(miconex)
	Endif
	If xtipo = 2 And m12 #"99999999999"
		m12 = "99999999999"
		mccampos = ''
		For I = 1 To 18
			mccampos = mccampos +Evaluate("m" + Alltrim(Transform(I)))+Iif(I<18,",","")
		Next

		mresultado = 0
		merror = 0
		mcopt = ''
		musuario = mwkusuario.idusuario
*If !Used("mwkservprueba")
		Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
*Endif
		Go Top In mwkservprueba
		mstringcon = Alltrim(mwkservprueba.Descrip)
		If mwkservprueba.estado = 1
			miconex = Sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )
		Else
			miconex = mcon1
		Endif
		mRet = SQLExec(miconex ,"CALL WS.AProcesarSP_GrabaAProcesar('SI_PO_0011_Integra_Translado_Out',3,?mccampos,?musuario,?@mresultado, ?@merror","C1")
		If 	miconex # mcon1
			SQLDisconnect(miconex)
		Endif

	Endif
	miresp = "Resultado : " + Transform(mresultado)+"Error : " + Transform(merror)
*Endif

Return miresp
