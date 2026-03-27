*!*	lnResu = 0
*!*	prg_nroprotocolo(@lnResu)
*!*	lnResu
*!*	-------------------------------------------------------------
Parameters tnResu
tnResu = 0

olevism = Newobject("Visual", "c:\desaguemes\lib\lib_cubito.vcx")
olevism = olevism.olevism
lbResu = .F.

Do While .T.

	olevism.mserver = Alltrim(mwktabcfg.OLEServer)
	olevism.namespace = Alltrim(mwktabcfg.olespaces)
	olevism.Code = "D Protocolo^SPCIRUGRAL()"
	olevism.execflag = 1
	mmsgerr = olevism.errorname
	If  .Not. Empty(mmsgerr)
		
	Endif
	mok = olevism.p0
	lnerror = olevism.Object.Error
	If lnerror > 0
		Messagebox("ERROR AL OBTENER EL NRO DE PROTOCOLO",16,"ERROR")
		Exit 
	Endif 
	If !Empty(mok)
		Messagebox("ERROR AL OBTENER EL NRO DE PROTOCOLO",16,"ERROR")
		Exit 
	Endif 

	lnProto = olevism.p1
	
	TEXT To lcsql Textmerge Noshow Pretext 7
		Select ID From TabQuirofano Where NroProtocolo = ?lnProto
	ENDTEXT

	If !Prg_EjecutoSql(lcSql,"mwkAuxProt1")
		Exit 
	Endif
	
	If Reccount("mwkAuxProt1") > 0
		Loop
	Endif 
	
	tnResu = Int(Val(olevism.p1))
	
	lbResu = .t.
	Exit 
Enddo 

Use In Select("mwkAuxProt1")
olevism.mserver = ""
olevism.namespace = ""

Release olevism

Return lbResu

