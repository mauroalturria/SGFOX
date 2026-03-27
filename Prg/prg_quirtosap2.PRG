LOCAL mFecha

If  .Not. Used("mwkProtocolos")
	Return .F.
Endif

mFecha = sp_busco_fecha_srv2("DD")

*!*	Public GMDB
*!*	GMDB = Sqlconnect("172.16.1.190")

*!*	If  .Not. sp_conexion_mdb()
*!*		Return .F.
*!*	Endif

Select mwkprotocolos
Locate For psele = 1
If  .Not. Found()
	Return .F.
Endif
*!*	If "1.4" $ Alltrim(mwktabcfg.OLEServer)
*!*	*!*	     ? "Servidor " + ALLTRIM(mwktabcfg.oleserver)
*!*	Else
*!*	*!*	     ? "Servidor " + ALLTRIM(mwktabcfg.oleserver)
*!*	*!*	     WAIT
*!*		Return .F.
*!*	Endif
lcsep1 = Chr(9)
lcsep2 = Chr(1)
lccom = ''

Select mwkprotocolos
Count For psele = 1 To lcantidad
Goto Top

lnProceso = 0

olevism = Newobject("Visual", "c:\desaguemes\lib\lib_cubito.vcx")
olevism = olevism.olevism


Select mwkprotocolos

Scan All For psele = 1 AND mwkProtocolos.fechaquirof <= mFecha

	lnProceso = lnProceso + 1
	Wait Window Nowait "Procesando " + Transform(lnProceso) + " / " + Transform(lcantidad)
	lnprotocolo = mwkprotocolos.nroprotocolo
	lcprotocolo = Alltrim(Transform(lnprotocolo))
	lcsvr = Alltrim(mwktabcfg.OLEServer)
	lcnasp = Alltrim(mwktabcfg.olespaces)
	lnexec = 1

	If tqc_nrovaleq = 0
		mdat = ""
		mdat = mdat + lccom + lcprotocolo + lccom + ","
		mdat = mdat + lccom + Alltrim(Transform(g_codvax)) + lccom
		lccomenta = lcprotocolo + "|12"
		lcruti = 'SPCPC011'
		lcparr = 'MAIN'
		lccode = 'D MAIN^SPCPC011("' + mdat + '")'
		


		If execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)
			mnnrovaleq = Val(olevism.Object.p4)
*!*				TEXT TO lcsql TEXTMERGE NOSHOW PRETEXT 7
*!*					Update TabQuirofano Set TQC_NroValeQ = ?mnNroValeQ Where NroProtocolo = ?lnProtocolo
*!*				ENDTEXT
*!*				If  .Not. prg_ejecutosql(lcsql, "mwk")
*!*					Return .F.
*!*				Endif
			Select mwkprotocolos
			lnregi = Recno()
			Replace tqc_nrovaleq With mnnrovaleq For nroprotocolo = lnprotocolo
			Goto lnregi
		Else
		Endif
	Endif
	
	Select mwkprotocolos
	If tqc_nrovaleq > 0 And Empty(Nvl(TQC_NroValeQS,0)) And Empty(Nvl(TQC_NroValeQFS,0))
		mdat = ""
		mdat = mdat + lccom + lcprotocolo + lccom
		lccomenta = lcprotocolo + "|34"
		lcruti = 'SPCPC350'
		lcparr = 'MAIN'
		lccode = 'D MAIN^SPCPC350(1, ' + mdat + ')'

		If execvism(lccomenta, lcsvr, lcnasp, lcruti, lcparr, lccode, lnexec)

			Select mwkprotocolos
			lnregi = Recno()
			mv3 =  Val(olevism.Object.p3)
			mv4 =  Val(olevism.Object.p4)
			Replace TQC_NroValeQS With mv3 For nroprotocolo = lnprotocolo
			Replace TQC_NroValeQFS With mv4 For nroprotocolo = lnprotocolo
			Goto lnregi
			
*!*			.Column11.ControlSource = "mwkProtocolos.TQC_NroValeQS"
*!*			.Column12.ControlSource = "mwkProtocolos.TQC_NroValeQFS"


		Else
		Endif
	Endif
	
	
	If Vartype(olevism) = "O"
		olevism.mserver = ""
		olevism.namespace = ""
		prg_olevism_reset(olevism)
	Endif 
	
	_Screen.Refresh()

	Select mwkprotocolos
	
Endscan

olevism.parent.release
Release olevism



*!*	If  .Not. sp_desconexion_mdb()
*!*		Return .F.
*!*	Endif

Endfunc
**
Function execvism
Parameter tccomenta, tcsvr, tcnasp, tcruti, tcparr, tccode, tnexec


Local lbresu
lbresu = .F.
Do While .T.
 	olevism.mserver = ''
	olevism.mserver = tcsvr
	olevism.namespace = tcnasp
	olevism.Code = tccode
	olevism.execflag = tnexec
	mmsgerr = olevism.errorname
	If  .Not. Empty(mmsgerr)
	Endif
	mok = olevism.p0
	mresp1 = olevism.p1
	mresp2 = olevism.p2
	lnerror = olevism.Object.Error
	lcerrorname = olevism.errorname
	lcp0 = olevism.Object.p0
	lcp1 = olevism.Object.p1
	lcp2 = olevism.Object.p2
	lcp3 = olevism.Object.p3
	lcp4 = olevism.Object.p4
	lcp5 = olevism.Object.p5
	lcp6 = olevism.Object.p6
	lcp7 = olevism.Object.p7
	lcp8 = olevism.Object.p8
	lcp9 = olevism.Object.p9
	lncodvaxadd = g_codvax
	TEXT TO lcsql TEXTMERGE NOSHOW PRETEXT 7
			INSERT INTO ZabVisM
				(ZVM_Comenta, ZVM_Server, ZVM_NameSpace, ZVM_Rutina, ZVM_Parrafo, ZVM_Code,
				ZVM_Error, ZVM_ErrorName, ZVM_P0, ZVM_P1, ZVM_P2,
				ZVM_P3, ZVM_P4, ZVM_P5, ZVM_P6, ZVM_P7,
				ZVM_P8, ZVM_P9, ZVM_CodVaxAdd) VALUES
				(?tcComenta, ?tcSvr, ?tcNaSp, ?tcRuti, ?tcParr, ?tcCode,
				?lnError, ?lcErrorName, ?lcP0, ?lcP1, ?lcP2,
				?lcP3, ?lcP4, ?lcP5, ?lcP6, ?lcP7,
				?lcP8, ?lcP9, ?lnCodVaxAdd)

	ENDTEXT
	If SQLExec(mcon1, lcsql, "") <= 0
		Messagebox("ERROR AL GUARDAR EL LOG", 16, "ERROR")
		Exit
	Endif
	If  .Not. Empty(mok)
		Exit
	Endif
*!*		If  .Not. Empty(mresp1)
*!*			Exit
*!*		Endif
	lbresu = .T.
	Exit
Enddo
 	olevism.mserver = ''
Return lbresu
Endfunc
