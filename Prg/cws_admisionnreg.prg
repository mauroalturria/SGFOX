**** registro pacientes sap

Lparameters xtipopac,nrohclinica,mnroadm, mireg

If mxambito<>1
	Return
Endif
If Vartype(mespec)#"C"
	mespec = ''
Endif
If Vartype(msinreg)#"N"
	msinreg = 0
Endif

If Vartype(leseme)#"N"
	leseme = 0
Endif
If mespec="EMER"
	mespec = 'CLIN'
Endif
If !INLIST(Vartype(nordeninter),"C","N")
	nordeninter=''
Endif
minrohclinica = nrohclinica
Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
miresp ="AUN NO ESTA EN LINEA"
*If mwkAdmonline.estado = 1 Or mwkusuario.codigovax = 54035
	msech = ''

	Private mresultado, merror,cprov(25)
	Dimension cprov(25)
	mRet = SQLExec(mcon1,"SELECT Coberturas.*, Pacientes.*,codcie10 "+;
		"FROM Coberturas  "+;
		" INNER JOIN Pacientes ON  COB_PACIENTES = PAC_codadmision  "+;
		" left JOIN tabcie10 on pac_codcie10diagn = tabcie10.id "+;
		" WHERE  PAC_codadmision  = ?mnroadm order by cob_fechacomcob desc ","mwkcober")
	If Reccount("mwkcober")= 0
		mRet = SQLExec(mcon1,"SELECT Coberturas.*, Pacientes.*,codcie10 "+;
			"FROM Pacientes "+;
			" left JOIN Coberturas  ON  COB_PACIENTES = PAC_codadmision  "+;
			" left JOIN tabcie10 on pac_codcie10diagn = tabcie10.id "+;
			" WHERE  PAC_codadmision  = ?mnroadm order by cob_fechacomcob desc ","mwkcober")
	Endif
	Go Top In mwkcober
	mient = Transform(mwkcober.cob_codentidad)
	If msinreg=0
		Do cws_registrareg With mireg
	Endif
	Do sp_busco_entidad_afiliado1 With mwkcober.pac_codhci,'mwkafisap'
	If xtipopac ="INT"
		mRet = SQLExec(mcon1,"SELECT Lugarintern.*, Sectores.SEC_habitsala"+;
			" FROM Lugarintern INNER JOIN SQLUser.SECTORES Sectores "+;
			" ON  Lugarintern.LUG_codsector = Sectores.SEC_codsector "+;
			" WHERE  LUG_PACIENTES = ?mnroadm "+;
			" ORDER BY LUG_fechaingreso,LUG_horaingreso  " ,"mwklugarinterna")
		Select mwklugarinterna
		Do While !Eof() And Inlist(mwklugarinterna.LUG_codsector, 'PQU','PRP','EME','CEG')
			Skip 1
		Enddo
		If Eof()
			Go Bottom
		Endif
		If leseme = 1
			Go Top
			If Empty(mespec)
				Do sp_busco_estados With 25,' and tipo = 48 order by estado ','mwksECESP'
				Select mwksECESP
				midiesp = 1000
				misec = Alltrim(mwklugarinterna.LUG_codsector)
				Scan
					If misec $ Alltrim(mwksECESP.Descrip)
						midiesp = mwksECESP.estado
						Exit
					Endif
				Endscan
				mRet = SQLExec(mcon1,"SELECT * FROM ZapServEspec "+;
					" WHERE  NroServicio  = ?midiesp ","mwkespxpiso")
				mespec= mwkespxpiso.Codesp
			Endif

		Endif
	Endif
	If !Empty(mespec) And xtipopac="INT"
		midusua = Iif(Used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)
		mcodadmision = mnroadm
		mfechap = sp_busco_fecha_serv("DD")
		If Used("mwksectorint") And xtipopac="INT"
			m9 = Alltrim(mwklugarinterna.LUG_codsector)
		Endif

		mRet = SQLExec(mcon1, "insert into TabVerC (codadmision,control,fecha,prg, usuario, habcama) values "+;
			" ( ?mcodadmision,1,?mfechap,999, ?midusua, ?mespec)	")
	Endif
	m1 = Iif(xtipopac="AMB","X","")
	m2 = Iif( xtipopac="INT","X","")
	m3 = Iif(xtipopac="GUA","X","")
	m4 = Alltrim(nrohclinica)
	m5 = Alltrim(mnroadm )
	m6 = Alltrim(Dtoc(mwkcober.PAC_fechaadmision))
	m7 = Left(Right("0"+Alltrim(Ttoc(mwkcober.PAC_horaadmision,2)),8),5)+":00"
	IF m7 = "00:00:00"
		m7 = "00:00:01"
	endif
	m8= mespec
	m9= xtipopac &&Alltrim(Nvl(mwkcober.PAC_sectorinternac,''))
	m10 = ""
	m11 = ""
	m12 = ""
	m13 = ""
	If Used("mwksectorint") And xtipopac="INT"
		m9 = Alltrim(mwklugarinterna.LUG_codsector)
		Select mwksectorint
		Locate For sec_codsector = m9
		If Found()
			m10 = Alltrim(sec_habitsala)
		Endif
		m11 = Alltrim(mwklugarinterna.lug_habitacion)
		m12= Alltrim(mwklugarinterna.lug_cama)
		m13= Alltrim(mwklugarinterna.lug_categoria)
	Endif

	If Vartype(mcodcie)#"C"
		mcodcie = 0
		m15= Alltrim(Transform(Nvl(mwkcober.codcie10 ,'')))
	Else
		m15= Iif(mcodcie = '','',Alltrim(Transform(mcodcie)))
	Endif
	m14 = Iif(!Empty(m15),'09','')
	m16 = Alltrim(Transform(mwkcober.cob_codentidad))
	Select mwkafisap
	Locate For ent_codent = Val(m16)
	If !Found()
		Go Top

	Endif
	m17 = Alltrim(Transform(mwkafisap.AFI_nroafiliado))
	m18 = IIF(nvl(mwkcober.COB_CondicImpositiva,"0")="0","E",mwkcober.COB_CondicImpositiva)
	m19 = Dtoc(mwkcober.cob_fechacomcob)
	m20 = Iif(mwkcober.PAC_operadm<99999,Alltrim(Transform(mwkcober.PAC_operadm)),'')
	m21 = Alltrim(Transform(Nvl(mwkcober.PAC_operalta,'')))
	m22 = ''   && nro
	m23 = ''   && observa
	m24 = ''   && tipo
	m25 = ''   && vigencia
	m26 = ''   && dias

	If xtipopac="INT"
		msql_ord = ''
		Do sp_busco_orden_int_ent With m5,msql_ord
		If Reccount('mwkordintent')>0
			&msql_ord
			Select mwkordintpac
			Go Bott
			m22 = Alltrim(Nvl(mwkordintpac.ORICodAutoriz,''))
			m22 = Chrtran(m22, "§$%/()=?`'!><;:_#*+_,'ºª", "                Ñ       ")
			m23 = Alltrim(Nvl(mwkordintpac.ORIObservac,''))
			m23 = Chrtran(m23, "§$%/()=?`'!><;:_#*+_,'ºª", "                Ñ       ")
			m24 = Alltrim(Nvl(mwkordintpac.oritipoorden,''))
			m24 = Chrtran(m24, "§$%/()=?`'!><;:_#*+_,'ºª", "                Ñ       ")
			m25 = Dtoc(mwkordintpac.orivigdesde)
			m26 = Iif( m24 = "P",Transform(Nvl(mwkordintpac.ORIDiasVigencia,0)),'')
		Endif
	Else
		If !Empty(nordeninter)
			m22 = Alltrim(Transform(nordeninter))
			m23 = ''
			m24 = 'T'
			m25 = m6
			m26 = m6

		Endif

	Endif
	mccampos = ''
	For I = 1 To 26
		mccampos = mccampos +Evaluate("m" + Alltrim(Transform(I)))+Iif(I<26,",","")
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
	mRet = SQLExec(miconex ,"CALL WS.AProcesarSP_GrabaAProcesar('SI_PO_0008_Integra_Admision_Out',2,?mccampos,?musuario,?@mresultado, ?@merror","C1")
	If 	miconex # mcon1
		SQLDisconnect(miconex)
	Endif
	miresp = "Resultado : " + Transform(mresultado)+"Error : " + Transform(merror)
*Endif

Return miresp
