*!*	lcDir = "c:\SAP\IS-H\"
*!*	lcArc = "04_FORMATO_MCARGUE_DICCIONARIO_Admisiones.xlsx"
*!*	lbProcesar = .T.

*!*	Public oExcel As Excel.Application
*!*	oExcel = Createobject("Excel.application")
*!*	oExcel.ScreenUpdating = .F.
*!*	*Set Step On
*!*	oExcel.Visible = .T.

*!*	oExcel.Workbooks.Open(lcDir + lcArc)
*!*	oExcel.Sheets("Matriz de Cargue").Select
*!*	lnRow = 6
*!*	*oExcel.Workbooks.Close(0)

*!*	*!*	WHERE {FN Year(REG_FECHAALTA)} = 2018 ORDER BY REG_NROREGISTRAC DESC

*!*	K = 0

*!*	Select  admisiones
*!*	Scan
*!*		mnroreg = admisiones.pac_codhci
*!*		mnroadm = admisiones.pac_codadm
*!*		mcodent  = 0
*!*		MNUMDOC = 0
*!*		minifec = Ctod("01/01/1900")
*!*		mnroafi = ''
*!*		If pac_tipop2>1
*!*			Requery('afilia')
*!*			If Reccount('afilia')>0
*!*				mcodent  = afilia.afi_codentidad
*!*				MNUMDOC = afilia.REG_numdocumento
*!*				minifec = admisiones.pac_fecha2
*!*				mnroafi = afilia.afi_nroafiliado
*!*				Select  admisiones
*!*				Replace codent With mcodent,numdoc With MNUMDOC,fechacob With minifec,afiliado With mnroafi
*!*			Endif
*!*	*	1			2			3			4			5			6		7			8			9				10			11		12				13			14		15
*!*	*TIPOPAC_AMB	TIPOPAC_GUA	TIPOPAC_INT	NRO_HCLINICA	TIPODOC NUMDOC	CODADMISION	FECHAADMISION	HORAADMISION	SECTORINTERNAC	HABITSALA	HABITACION	CAMA	CATEGORIA	CODENTIDAD	NROAFILIADO	EXE_GRAV	FECHACOMCOB	OPERADM	OPERMOD
*!*			m1 = Iif( admisiones.pac_tipop2=2,"X","")
*!*			m2 = Iif( admisiones.pac_tipop2=3,"X","")
*!*			m3 = Iif( admisiones.pac_tipop2<2,"X","")
*!*			m4 = Alltrim(afilia.REG_nrohclinica)
*!*			m5 = Iif(VAL(afilia.REG_tipodocumento)=4,"DI",Left(Alltrim(afilia.abrevio),2))
*!*			m6 = Alltrim(Transform(MNUMDOC ))
*!*			m7 = Alltrim(mnroadm )
*!*			m8 = Alltrim(Transform(admisiones.pac_fecha2))
*!*			m9 = Right("0"+Alltrim(Ttoc(admisiones.pac_horaad,2)),8)
*!*			m10= Alltrim(admisiones.pac_tipopa)
*!*			m11= ''
*!*			m12= ''
*!*			m13= ''
*!*			m14= ''
*!*			m15 = Alltrim(Transform(mcodent))
*!*			m16 = Alltrim(Transform(mnroafi))
*!*			m17 = 'E'
*!*			m18 = Alltrim(Transform(minifec ))
*!*			m19 = Alltrim(Transform(admisiones.pac_operad))
*!*			m20 = ''
*!*			For I = 1 To 20
*!*				oExcel.Cells(lnRow + K,I).Value = Evaluate("m" + Alltrim(Transform(I)))
*!*			Next
*!*			K = K + 1

*!*		Else

*!*			Requery('cober')
*!*			If Reccount( "cober")>0
*!*				Select cober
*!*				Scan
*!*					mcodent  = cob_codentidad
*!*					MNUMDOC = REG_numdocumento
*!*					minifec = cob_fechacomcob
*!*					mnroafi = afi_nroafiliado
*!*					Select  admisiones
*!*					Replace codent With mcodent,numdoc With MNUMDOC,fechacob With minifec,afiliado With mnroafi
*!*	*	1			2			3			4			5			6		7			8			9				10			11		12				13			14		15
*!*	*TIPOPAC_AMB	TIPOPAC_GUA	TIPOPAC_INT	NRO_HCLINICA	TIPODOC NUMDOC	CODADMISION	FECHAADMISION	HORAADMISION	SECTORINTERNAC	HABITSALA	HABITACION	CAMA	CATEGORIA	CODENTIDAD	NROAFILIADO	EXE_GRAV	FECHACOMCOB	OPERADM	OPERMOD
*!*					m1 = Iif( admisiones.pac_tipop2=2,"X","")
*!*					m2 = Iif( admisiones.pac_tipop2=3,"X","")
*!*					m3 = Iif( admisiones.pac_tipop2<2,"X","")
*!*					m4 = Alltrim(cober.REG_nrohclinica)
*!*					m5 = Iif(VAL(cober.REG_tipodocumento)=4,"DI",Left(Alltrim(cober.abrevio),2))
*!*					m6 = Alltrim(Transform(MNUMDOC ))
*!*					m7 = Alltrim(mnroadm )
*!*					m8 = Alltrim(Transform(admisiones.pac_fecha2))
*!*					m9 = Right("0"+Alltrim(Ttoc(admisiones.pac_horaad,2)),8)
*!*					m10= Alltrim(admisiones.pac_sector)
*!*					m11= "H"&&alltrim(admisiones.pac_motivo)
*!*					m12= Alltrim(admisiones.pac_habita)
*!*					m13= Alltrim(admisiones.pac_cama)
*!*					m14= Alltrim(admisiones.pac_catego)
*!*					m15 = Alltrim(Transform(mcodent))
*!*					m16 = Alltrim(Transform(mnroafi))
*!*					m17 = 'E'
*!*					m18 = Alltrim(Transform(minifec ))
*!*					m19 = Alltrim(Transform(admisiones.pac_operad))
*!*					m20 = Alltrim(Transform(admisiones.pac_operal))
*!*					For I = 1 To 20
*!*						oExcel.Cells(lnRow + K,I).Value = Evaluate("m" + Alltrim(Transform(I)))
*!*					Next
*!*					K = K + 1
*!*				Endscan
*!*			Endif
*!*		Endif
*!*	Endscan


*!*	oExcel.ScreenUpdating = .T.

*!*	Set Step On
*!*	lcDir = "c:\SAP\IS-H\"
*!*	lcArc = "05_FORMATO_MCARGUE_DICCIONARIO_traslados.xlsx"
*!*	lbProcesar = .T.

*!*	Public oExcel As Excel.Application
*!*	oExcel = Createobject("Excel.application")
*!*	oExcel.ScreenUpdating = .F.
*!*	*Set Step On
*!*	oExcel.Visible = .T.

*!*	oExcel.Workbooks.Open(lcDir + lcArc)
*!*	oExcel.Sheets("Matriz de Cargue").Select
*!*	lnRow = 6
*!*	*oExcel.Workbooks.Close(0)

*!*	WHERE {FN Year(REG_FECHAALTA)} = 2018 ORDER BY REG_NROREGISTRAC DESC

*!*	K = 0

*!*	Select  admisiones
*!*	Set Filter To pac_tipop2<2
*!*	Scan
*!*		mnroreg = admisiones.pac_codhci
*!*		mnroadm = admisiones.pac_codadm
*!*		mcodent  = 0
*!*		MNUMDOC = 0
*!*		minifec = Ctod("01/01/1900")
*!*		mnroafi = ''
*!*		Requery('lugarinterna')
*!*		Select lugarinterna
*!*		Go Top
*!*		Do While !Eof()
*!*			mfecegr = Alltrim(Transform(lugarinterna.lug_fechaegreso))
*!*			If Isnull(lugarinterna.lug_fechaegreso) OR RECCOUNT('lugarinterna')=1
*!*				Requery('pacobito')
*!*				If Reccount( "pacobito")>0
*!*					Select pacobito
*!*					Go Botto

*!*					m1 = ""
*!*					m2 = "X"
*!*					m3 = Alltrim(mnroadm )
*!*					m4 = mfecegr
*!*					m5 = Right("0"+Alltrim(Ttoc(admisiones.pac_horaal,2)),8)
*!*					m6 = Alltrim(lugarinterna.lug_codsector)
*!*					m7 = Alltrim(lugarinterna.sec_habitsala)
*!*					m8 = Alltrim(lugarinterna.lug_habitacion)
*!*					m9 = Alltrim(lugarinterna.lug_cama)
*!*					m10= Alltrim(lugarinterna.lug_categoria)
*!*					m11= Alltrim(pacobito.matriculas)
*!*					m12= Alltrim(Transform(admisiones.pac_motivo))
*!*					m13= Iif(admisiones.pac_motivo=6,"M","V")
*!*					m14= 'CIE10'
*!*					m15 =  Alltrim(Transform(pacobito.po_codcie10))
*!*					m16 = '54035'
*!*					m17 = ''
*!*					For I = 1 To 17
*!*						oExcel.Cells(lnRow + K,I).Value = Evaluate("m" + Alltrim(Transform(I)))
*!*					Next
*!*					K = K + 1
*!*				Endif
*!*				Exit

*!*			Else
*!*				Skip
*!*				mhora = Right("0"+Alltrim(Ttoc(lugarinterna.lug_horaingreso,2)),8)
*!*				m1 = "X"
*!*				m2 = ""
*!*				m3 = Alltrim(mnroadm )
*!*				m4 = mfecegr
*!*				m5 = mhora
*!*				m6 = Alltrim(lugarinterna.lug_codsector)
*!*				m7 = Alltrim(lugarinterna.sec_habitsala)
*!*				m8 = Alltrim(lugarinterna.lug_habitacion)
*!*				m9 = Alltrim(lugarinterna.lug_cama)
*!*				m10= Alltrim(lugarinterna.lug_categoria)
*!*				m11= ""
*!*				m12= ""
*!*				m13= ""
*!*				m14= ""
*!*				m15 =  ""
*!*				m16 = '54035'
*!*				m17 = ''
*!*				For I = 1 To 17
*!*					oExcel.Cells(lnRow + K,I).Value = Evaluate("m" + Alltrim(Transform(I)))
*!*				Next
*!*				K = K + 1
*!*			Endif
*!*		Enddo
*!*	Endscan


*!*	oExcel.ScreenUpdating = .T.
*!*	Set Step On
lcDir = "c:\SAP\IS-H\"
lcArc = "06_FORMATO_MCARGUE_DICCIONARIO_servicios_cabecera.xlsx"
lcArd = "06_FORMATO_MCARGUE_DICCIONARIO_servicios_detalle.xlsx"
lbProcesar = .T.

Public oExcel As Excel.Application
Public oExceld As Excel.Application
oExcel = Createobject("Excel.application")
oExcel.ScreenUpdating = .F.
*Set Step On
oExcel.Visible = .T.

oExcel.Workbooks.Open(lcDir + lcArc)
oExcel.Sheets("Matriz de Cargue").Select

oExceld = Createobject("Excel.application")
oExceld.ScreenUpdating = .F.
*Set Step On
oExceld.Visible = .T.

oExceld.Workbooks.Open(lcDir + lcArd)
oExceld.Sheets("Matriz de Cargue").Select

lnRow = 6
*oExcel.Workbooks.Close(0)

*!*	WHERE {FN Year(REG_FECHAALTA)} = 2018 ORDER BY REG_NROREGISTRAC DESC

K = 0
L = 0

Select  admisiones
Scan
	mnroreg = admisiones.pac_codhci
	mnroadm = admisiones.pac_codadm
	mcodent  = 0
	MNUMDOC = 0
	minifec = Ctod("01/01/1900")
	mnroafi = ''
	Requery('vales_realprest')
	If Reccount( "vales_realprest")>0
		Select vales_realprest
		Go Top
		mivale = 0
		Do While !Eof()
*	1				2			3			4			5				6			7				;
8		9		10			11				12			13			14			15
*TIPOPAC_AMB	TIPOPAC_GUA	TIPOPAC_INT	CODADMISION	CODVALEASIST	FECHASOLICITUD	HORASOLICITUD	;
PISO	NUMERO	DESCRIP	URGENCIASERV	CODSERVVALE	PRESTADOR	OPERADORCARGA	OPERADORCONFORME
			mivale = vales_realprest.VAL_codvaleasist
			m1 = Iif( admisiones.pac_tipop2=2,"X","")
			m2 = Iif( admisiones.pac_tipop2=3,"X","")
			m3 = Iif( admisiones.pac_tipop2<2,"X","")
			m4 = Alltrim(mnroadm )
			m5 = Alltrim(Transform(vales_realprest.VAL_codvaleasist))
			m6 = Alltrim(Transform(vales_realprest.VAL_fechasolicitud))
			m7 = Right("0"+Alltrim(Ttoc(vales_realprest.VAL_FHSolicitud,2)),8)
			m8 = ''
			m9 = ''
			m10= ''
			m11= Iif(VAL(vales_realprest.VAL_urgenciaserv)=1,"U","")
			m12= Alltrim(Transform(vales_realprest.VAL_codservvale))
			m13=  Alltrim(Transform(Nvl(vales_realprest.VAL_prestador,306)))
			m14= Alltrim(Transform(vales_realprest.VAL_OperadorCarga))
			m15 =  Alltrim(Transform(vales_realprest.VAL_OperadorConforme))
			For I = 1 To 15
				oExcel.Cells(lnRow + K,I).Value = Evaluate("m" + Alltrim(Transform(I)))
			Next
			K = K + 1
			Do While !Eof() And mivale = vales_realprest.VAL_codvaleasist
				mivale = vales_realprest.VAL_codvaleasist
*						CODVALEASIST	CODPREST	CANTSOLICITADA	ESPECIALIDAD

				m1 = Alltrim(Transform(vales_realprest.VAL_codvaleasist))
				m2 =  Alltrim(Transform(vales_realprest.PRE_codprest))
				m3 = Alltrim(Transform(vales_realprest.PIA_cantsolicitada))
				m4 = Alltrim(Transform(vales_realprest.PRE_especialidad))
				For I = 1 To 4
					oExceld.Cells(lnRow + K,I).Value = Evaluate("m" + Alltrim(Transform(I)))
				Next
				L = L + 1
				Skip
			Enddo
			mivale = vales_realprest.VAL_codvaleasist
		Enddo
	Endif
Endscan


oExcel.ScreenUpdating = .T.
oExceld.ScreenUpdating = .T.

*!*		Endif
*!*	Endscan
*!*	Do sp_desconexion
*!*	Select admisiones
*!*	Scan
*!*		mnrohclin = h_clinica
*!*		mtfhoy = ingreso - 24 * 3600 * 1 &&(2 dias antes)
*!*		mret = SQLExec(mcon1, "select REG_nroregistrac  "+;
*!*			" FROM Registracio "+ ;
*!*			" where  REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")

*!*		mbusca = " guardia.fechahoraing >= ?mtfhoy and guardia.nroregistrac = "+Alltrim(Str(mwkbuspacie.REG_nroregistrac))
*!*		Do sp_busco_protocolo_paciente With mbusca,0,'','protocolo,codprest'
*!*		Select mwkguardia
*!*		Go Top
*!*		If Reccount( "mwkguardia")>0
*!*			cdiag = codcie9
*!*			Select admisiones
*!*			Replace codcie1 With cdiag
*!*		Else
*!*			mbusca = " guardia.fechahoraing >= ?mtfhoy and guardia.nroregistrac = "+Alltrim(Str(mwkbuspacie.REG_nroregistrac))
*!*			Do sp_busco_protocolo_paciente With mbusca,0,1,'protocolo,codprest'
*!*			Select mwkguardia
*!*			Go Top
*!*			If Reccount( "mwkguardia")>0
*!*				cdiag = codcie9
*!*				Select admisiones
*!*				Replace codcie1 With cdiag
*!*			Endif

*!*		Endif
*!*	Endscan
*!*	Select  hclini
*!*	Scan
*!*		mnrohclin = hclini.hclinica
*!*		mret = SQLExec(mcon1, "select HIS_codentidad ,HIS_fechaadmision "+;
*!*			" FROM Registracio,histambgua "+ ;
*!*			" where  his_nroregistrac = REG_nroregistrac and "+;
*!*			" REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")
*!*		If Reccount( "mwkbuspacie")>0
*!*			Go Bott
*!*			mcodent  = HIS_codentidad
*!*			Select  hclini
*!*			Replace codent With mcodent
*!*		Endif
*!*	Endscan
*!*	Do sp_desconexion

*!*	Do sp_conexion
*!*	Set Step On
*!*	Select  hclin
*!*	Scan
*!*		If hclin.entidad = 0

*!*			Wait Windows Transform(Recno()) Nowait
*!*			mctexto = Alltrim(hclin)
*!*			mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_nombrepac" + ;
*!*				" FROM afiliacion, registracio " + ;
*!*				" where REG_nrohclinica = ?mctexto and AFI_fechabaja is null  "+;
*!*				" and registracio.REG_nroregistrac = afiliacion.registracio and  afiliacion.AFI_codentidad = 948 " , "mwkbuspacie")
*!*			If Reccount( "mwkbuspacie")>0
*!*				Select  hclin
*!*				Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 948
*!*			Else
*!*				mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_nombrepac" + ;
*!*					" FROM afiliacion, registracio " + ;
*!*					" where REG_nrohclinica = ?mctexto and AFI_fechabaja is null  "+;
*!*					" and registracio.REG_nroregistrac = afiliacion.registracio and afiliacion.AFI_codentidad = 945 " , "mwkbuspacie")
*!*				If Reccount( "mwkbuspacie")>0
*!*					Select  hclin
*!*					Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 945
*!*				Endif

*!*			Endif
*!*			mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_nombrepac,AFI_fechabaja " + ;
*!*				" FROM afiliacion, registracio " + ;
*!*				" where REG_nrohclinica = ?mctexto "+;
*!*				" and registracio.REG_nroregistrac = afiliacion.registracio and  afiliacion.AFI_codentidad = 948 " , "mwkbuspacie")
*!*			If Reccount( "mwkbuspacie")>0
*!*				Select  hclin
*!*				Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 948,pasivo With Nvl(mwkbuspacie.AFI_fechabaja,Ctod("  /  /  "))
*!*			Else
*!*				mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_nombrepac,AFI_fechabaja " + ;
*!*					" FROM afiliacion, registracio " + ;
*!*					" where REG_nrohclinica = ?mctexto  "+;
*!*					" and registracio.REG_nroregistrac = afiliacion.registracio and afiliacion.AFI_codentidad = 945 " , "mwkbuspacie")
*!*				If Reccount( "mwkbuspacie")>0
*!*					Select  hclin
*!*					Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 945,pasivo With Nvl(mwkbuspacie.AFI_fechabaja,Ctod("  /  /  "))
*!*				Endif

*!*			Endif

*!*		Endif
*!*	Endscan
*!*	Do sp_desconexion
*!*	Select admisiones
*!*	Scan
*!*		mnrohclin = h_clinica
*!*		mtfhoy = ingreso - 24 * 3600 * 1 &&(2 dias antes)
*!*		mret = SQLExec(mcon1, "select REG_nroregistrac  "+;
*!*			" FROM Registracio "+ ;
*!*			" where  REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")

*!*		mbusca = " guardia.fechahoraing >= ?mtfhoy and guardia.nroregistrac = "+Alltrim(Str(mwkbuspacie.REG_nroregistrac))
*!*		Do sp_busco_protocolo_paciente With mbusca,0,'','protocolo,codprest'
*!*		Select mwkguardia
*!*		Go Top
*!*		If Reccount( "mwkguardia")>0
*!*			cdiag = codcie9
*!*			Select admisiones
*!*			Replace codcie1 With cdiag
*!*		Else
*!*			mbusca = " guardia.fechahoraing >= ?mtfhoy and guardia.nroregistrac = "+Alltrim(Str(mwkbuspacie.REG_nroregistrac))
*!*			Do sp_busco_protocolo_paciente With mbusca,0,1,'protocolo,codprest'
*!*			Select mwkguardia
*!*			Go Top
*!*			If Reccount( "mwkguardia")>0
*!*				cdiag = codcie9
*!*				Select admisiones
*!*				Replace codcie1 With cdiag
*!*			Endif

*!*		Endif
*!*	Endscan
*!*	Select valestc
*!*	Scan
*!*		mvale = valestc.vale
*!*		mret = SQLExec(mcon1, " select PRE_codprest, PRE_descriprest  FROM Valesasist,"+;
*!*			" Presinsuvas, Prestacions WHERE PIA_VALESASIST = VALESASIST " +;
*!*			"  AND PRE_codprest = PIA_codprest "+ ;
*!*			" and val_codvaleasist = ?mvale " +;
*!*			" " , "mwkdatos")
*!*		If mret<0
*!*			=Aerr(eros)
*!*			Messagebox(eros(3))
*!*		Endif
*!*		Select valestc
*!*		If Reccount("mwkdatos")>0
*!*			Replace codprest With mwkdatos->PRE_codprest,Descrip With mwkdatos->PRE_descriprest
*!*		Endif
*!*	Endscan
*!*	Do sp_desconexion
*!*	Select diasmarzo
*!*	Scan
*!*		admi = NRO_ADMISI
*!*		Requery('lugarinterna')
*!*		Select * From lugarinterna ;
*!*			where LUG_fechaingreso <Ctod("01/04/2017") And Nvl(LUG_fechaegreso,Ctod("01/01/2100"))>=Ctod("01/03/2017") ;
*!*			into Cursor ucis



Function TipoDocumento(lnTipo)
Do Case
Case lnTipo = 1
	lcResu = 'LE' &&	Libreta de Enrolamiento
Case lnTipo = 2
	lcResu = 'LC' && 	Libreta cívica
Case lnTipo = 3
	lcResu = 'CI' &&	Cédula de identidad
Case lnTipo = 4
	lcResu = 'DI' && 	Documento Nacional de Identificación
Case lnTipo = 5
	lcResu = 'PA' &&	Pasaporte
Case lnTipo = 6
	lcResu = 'LM' &&	Libreta de Matrimonio
Case lnTipo = 7
	lcResu = 'LF' &&	Libreta Familiar
Case lnTipo = 9
	lcResu = 'OT' &&	Otros

Otherwise
	lcResu = ""

Endcase
