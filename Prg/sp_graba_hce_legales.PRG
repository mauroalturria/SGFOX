*
* Registro de solicitudes de impresión HCE
*
Lparameters mmfec, mmtip, mmpro, mnregis, mate

If vartype(mate) # "T" or mate = dtot({//})
	mate = ctot("01/01/1900")
Endif

Use in select("mwkctrl")

&& Busco solicitadas para no requerir de nuevo

If mmtip = 'HCA'
	mret = sqlexec(mcon1,"select * from TabLGHce"+;
		" where TLH_nroregis=?mnregis and TLH_tipo=?mmtip and TLH_estado=1","mwkctrl")
Else
	mret = sqlexec(mcon1,"select * from TabLGHce"+;
		" where TLH_protocolo=?mmpro and TLH_tipo=?mmtip and TLH_estado=1","mwkctrl")
Endif

If mret < 0
	mpasa = .F.
	Messagebox("CONSULTA DE HCE LEGALES SOLICITADAS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
Endif

If Used("mwkctrl")

	If Reccount("mwkctrl") = 0

		muser = Alltrim(mwkusuario.idusuario)
		mfech = sp_busco_fecha_serv("DT")

		mret  = sqlexec(mcon1,"insert into TabLGHce" +;
			"(TLH_estado,TLH_fechasol,TLH_idusuario,TLH_nroregis,TLH_protocolo,TLH_tipo,TLH_fecmov,TLH_fechaate)"+;
			" values "+;
			"(1,?mmfec,?muser,?mnregis,?mmpro,?mmtip,?mfech,?mate)")

		If mret < 0
			Messagebox("CONSULTA REGISTRO HCE LEGALES SOLICITADAS"+chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores with error(), message(), message(1), program(), lineno()
			Return .F.
		Endif

		mret = sqlexec(mcon1,"select id as lid,TLH_estado as lestado from TabLGHce"+;
			" where TLH_protocolo=?mmpro and TLH_tipo=?mmtip and TLH_estado=1","mwkctrl")

		If mret < 0
			Messagebox("CONSULTA DE HCE LEGALES SOLICITADAS"+chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores with error(), message(), message(1), program(), lineno()
			Return .F.
		Endif

		If !sp_hce_legales_log(mwkctrl.lid,mwkctrl.lestado,muser,mfech)
			Return .F.
		Endif

		mpasa = .T.

	Else

		Do case
		Case mmtip = 'INT'
			mlmsg = "EL NRO.ADMISION "+alltrim(mmpro)
		Case mmtip = 'HCA'
			mlmsg = "EL DETALLE DE HC EN PAPEL"
		Otherwise
			mlmsg = "EL PROTOCOLO "+alltrim(mmpro)
			
			If used("mwkdupli")
				Insert into mwkdupli (tlh_protocolob, tlh_nroregisb) values (mmpro, mnregis)
			Endif

		Endcase
		Messagebox(mlmsg+" YA HA SIDO SOLICITADO",48,"Validación")

	Endif
Endif
Use in select("mwkctrl")

Return .T.
