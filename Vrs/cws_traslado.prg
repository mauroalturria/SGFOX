**** registro pacientes sap
Lparameters xtipopac,nrohclinica,mnroadm,mcodcie

Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
miresp ="AUN NO ESTA EN LINEA"
If mwkAdmonline.estado = 1
	Private mresultado, merror,cprov(25)
	Dimension cprov(25)
	If !Used('mwkbuspacie')
		mbusco1 = "where reg_nrohclinica = ?nrohclinica and "
		Do sp_busco_nombre_paciente_1 With mbusco1, 1, ''
	Endif
	mRet = SQLExec(mcon1,"SELECT Coberturas.*, Pacientes.* "+;
		"FROM Coberturas  "+;
		"INNER JOIN Pacientes ON  COB_PACIENTES = PAC_codadmision  "+;
		" WHERE  PAC_codadmision  = ?mnroadm","mwkcober")
	If !Used('mwkafient')
		Do sp_busco_entidad_afiliado With mwkcober.pac_codhci
	Endif

	m1 = Iif(xtipopac="AMB","X","")
	m2 = Iif(xtipopac="GUA","X","")
	m3 = Iif( xtipopac="INT","X","")
	m4 = Alltrim(nrohclinica)
	m5 = Alltrim(mnroadm )
	m6 = Alltrim(Dtoc(mwkcober.PAC_fechaadmision))
	m7 = Right("0"+Alltrim(Ttoc(mwkcober.PAC_horaadmision,2)),8)
	m8= Transform(Nvl(mwkcober.pac_areainternac,''))
	m9= Alltrim(Nvl(mwkcober.PAC_sectorinternac,''))
	m10= ""
	If Used("mwksectorint")
		Select mwksectorint
		Locate For sec_codsector = m9
		If Found()
			m10 = sec_habitsala
		Endif
	Endif
	m11= Alltrim(Nvl(mwkcober.PAC_habitacion,''))
	m12= Alltrim(Nvl(mwkcober.PAC_cama,''))
	m13= Alltrim(Nvl(mwkcober.PAC_categoria,''))
	m14 =Iif( xtipopac="INT","CIE10","CIE9")
	If Vartype(mcodcie)#"N"
		m15= Alltrim(Transform(Nvl(mwkcober.pac_codcie10diagn,'')))
	Else
		m15= Iif(mcodcie = 0,'',Alltrim(Transform(mcodcie)))
	Endif
	m16 = Alltrim(Transform(mwkcober.cob_codentidad))
	Select mwkafient
	Locate For ent_codent = Val(m16)
	If !Found()
		Go Top

	Endif
	m17 = Alltrim(Transform(mwkafient.AFI_nroafiliado))
	m18 = 'E'
	m19 = Dtoc(mwkcober.cob_fechacomcob) 
	m20 = Iif(mwkcober.PAC_operadm<99999,Alltrim(Transform(mwkcober.PAC_operadm)),'')
	m21 = Alltrim(Transform(Nvl(mwkcober.PAC_operalta,'')))
	mccampos = ''
	For I = 1 To 21
		mccampos = mccampos +Evaluate("m" + Alltrim(Transform(I)))+Iif(I<46,",","")
	Next

	mresultado = 0
	merror = 0
	mcopt = ''
	musuario = mwkusuario.idusuario
	If !Used("mwkservprueba")
		Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
	Endif
	Go Top In mwkservprueba
	mstringcon = mwkservprueba.Descrip
	If mwkservprueba.estado = 1
		miconex = Sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )
	Else
		miconex = mcon1
	Endif
	mRet = SQLExec(miconex ,"CALL WS.AProcesarSP_GrabaAProcesar('SI_PO_0011_Integra_Translado_Out',5,?mccampos,?musuario,?@mresultado, ?@merror","C1")
	If 	miconex # mcon1
		SQLDisconnect(miconex)
	Endif
	miresp = "Resultado : " + Transform(mresultado)+"Error : " + Transform(merror)
Endif

Return miresp


<xsd:element name="TRASLADO" type="xsd:string"/><xsd:element name="ALTA" type="xsd:string"/><xsd:element name="EPISODIO" type="xsd:string"/><xsd:element name="DIA" type="xsd:string"/><xsd:element name="HORA" type="xsd:string"/><xsd:element name="ESPECIALIDAD" type="xsd:string"/><xsd:element name="SECTORINTERNAC" type="xsd:string"/><xsd:element name="HABITSALA" type="xsd:string"/><xsd:element name="HABITACION" type="xsd:string"/><xsd:element name="CAMA" type="xsd:string"/><xsd:element name="CATEGORIA" type="xsd:string"/><xsd:element name="MATRICULA" type="xsd:string"/><xsd:element name="DETALLEALTA" type="xsd:string"/><xsd:element name="DKAT" type="xsd:string"/><xsd:element name="DKEY" type="xsd:string"/><xsd:element name="ERUSR" type="xsd:string"/><xsd:element name="UPUSR" type="xsd:string"/>