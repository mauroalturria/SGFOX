**** traslado/alta pacientes sap
lparameters xtipo,xmnroadm,musumod,mespec,mbaja,mfecalta,mmotegr,mentsap,mimedcab

do sp_busco_estados with 7, " and tipo = 46 ", "mwkAdmonline"
if vartype(mespec)#"C"
	mespec = ''
endif
if vartype(mbaja)#"N"
	mbaja= 0
endif
if vartype(mentsap)#"N"
	mentsap = 0
endif
msech = ''

if vartype(musumod)#"C"
	musumod=''
endif
miresp ="AUN NO ESTA EN LINEA"
*if mwkAdmonline.estado =1 or mwkusuario.codigovax = 54035
	mnroadm = xmnroadm
	private mresultado, merror,cprov(25)
	dimension cprov(25)
	mRet = SQLExec(mcon1,"SELECT Pacientes.*,Motivoegreso.MTE_Descripcion,Tabcie10.codcie10 "+;
		"FROM  Pacientes left  JOIN Motivoegreso  ON  PAC_motivoalta = MTE_CodMotivo LEFT OUTER join Tabcie10 on Tabcie10.id = pac_codcie10diagegr "+;
		" WHERE  PAC_codadmision  = ?mnroadm ","mwkpacsap")
	mRet = SQLExec(mcon1,"SELECT Lugarintern.*, Sectores.SEC_habitsala"+;
		" FROM Lugarintern INNER JOIN SQLUser.SECTORES Sectores "+;
		" ON  Lugarintern.LUG_codsector = Sectores.SEC_codsector "+;
		" WHERE  LUG_PACIENTES = ?mnroadm "+;
		" ORDER BY LUG_fechaingreso,LUG_horaingreso  " ,"mwklugarinterna")
	select mwklugarinterna
	go top
	m1 = iif(xtipo=1,"X","")
	m2 = iif(xtipo=2,"X","")
	m3 = alltrim(mnroadm )
	select mwklugarinterna
	scan
		fechahoraing = ctot(dtoc(mwkpacsap.pac_fechaadmision)+" "+ttoc(mwkpacsap.pac_horaadmision,2))
		mfectras =  ctot(dtoc(mwklugarinterna.LUG_fechaingreso)+" "+right("0"+alltrim(ttoc(mwklugarinterna.LUG_horaingreso,2)),8))
		if mfectras = fechahoraing
			mfectras = mfectras +10
		endif
		mfecingr = alltrim(transform(ttod(mfectras)))
		m4 = mfecingr
		m5 = right("0"+alltrim(ttoc(mfectras,2)),8)
		If m5 = "00:00:00"
			m5 = "00:00:01"
		Endif
		if mespec="EMER"
			mespec = 'CLIN'
		endif

		m6 = mespec
		m7 = alltrim(mwklugarinterna.lug_codsector)
		m8 = alltrim(mwklugarinterna.sec_habitsala)
		m9 = alltrim(mwklugarinterna.lug_habitacion)
		m10= alltrim(mwklugarinterna.lug_cama)
		m11= alltrim(mwklugarinterna.lug_categoria)
		if empty(mespec)
			do sp_busco_estados with 25,' and tipo = 48 order by estado ','mwksECESP'
			select mwksECESP
			midiesp = 1000
			scan
				if m7  $ alltrim(mwksECESP.descrip)
					midiesp = mwksECESP.estado
					exit
				endif
			endscan
			mRet = SQLExec(mcon1,"SELECT * FROM ZapServEspec "+;
				" WHERE  NroServicio  = ?midiesp ","mwkespxpiso")
			mespec= mwkespxpiso.Codesp
		endif
		if mespec="EMER"
			mespec = 'CLIN'
		endif

		m12= ''
		m13= ''
		m14= ''
		m15= ''
		m16= transform(mwkusuario.codigovax)
		m17= musumod
		m18= ''
		if !empty(mespec)
			midusua = iif(used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)
			mcodadmision = mnroadm
			mfechap = ctot(dtoc(mwklugarinterna.LUG_fechaingreso)+" "+ttoc(mwklugarinterna.LUG_horaingreso,2))
			mRet = SQLExec(mcon1, "insert into TabVerC (codadmision,control,fecha,prg, usuario, habcama) values "+;
				" ( ?mcodadmision,1,?mfechap,999, ?midusua, ?mespec)	")
		endif


		mccampos = ''
		for I = 1 to 18
			mccampos = mccampos +evaluate("m" + alltrim(transform(I)))+iif(I<18,",","")
		next

		mresultado = 0
		merror = 0
		mcopt = ''
		musuario = mwkusuario.idusuario
*If !Used("mwkservprueba")
		do sp_busco_estados with 7, " and tipo = 45 ", "mwkservprueba"
*Endif
		go top in mwkservprueba
		mstringcon = alltrim(mwkservprueba.descrip)
		if mwkservprueba.estado = 1
			miconex = sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )
		else
			miconex = mcon1
		endif
		mRet = SQLExec(miconex ,"CALL WS.AProcesarSP_GrabaAProcesar('SI_PO_0011_Integra_Translado_Out',3,?mccampos,?musuario,?@mresultado, ?@merror","C1")
	endscan
	if 	miconex # mcon1
		SQLDisconnect(miconex)
	endif
	miresp = "Resultado : " + transform(mresultado)+"Error : " + transform(merror)
*endif

return miresp
