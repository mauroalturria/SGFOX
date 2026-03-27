***************
** grabo seguimiento ART
**********

Lparameters mopc,mx_Dictamen,mx_Estado,mxfecfin ,mxnreg ,mx_Siniestro,mx_proxate ,mxcodmed,mxent,mxctipoat

If Vartype(mxfecfin )<>"D"
	mxfecfin = Ctod("01/01/1900")
Endif
mfechoy = sp_busco_fecha_serv("DD")
midusu = mwkusuario.Id
miusuarioid = midusu 
Do Case
Case mopc = 1
	mret = SQLExec(mcon1, " select id from  ZabSegART where SA_Entidad = ?mxent and  SA_FechaFin = ?mxfecfin "+;
		" and  SA_Nroregistrac = ?mxnreg and SA_Siniestro=  ?mx_Siniestro ","mwkctrart")
	If Reccount("mwkctrart")=0
		mret = SQLExec(mcon1, " insert into ZabSegART (SA_CodigoART, SA_CodigoSG, SA_Dictamen,"+;
			" SA_Entidad, SA_Estado, SA_FechaFin, SA_FechaIni, SA_Nroregistrac,"+;
			" SA_Siniestro, SA_TipoAt ) values ( 0, ?mxcodmed, ?mx_Dictamen, ?mxent, ?mx_Estado"+;
			", ?mxfecfin , ?mfechoy , ?mxnreg , ?mx_Siniestro, ?mxctipoat )")
		mret = SQLExec(mcon1, " select * from  ZabSegART where SA_Entidad = ?mxent and  SA_FechaFin = ?mxfecfin "+;
			" and  SA_Nroregistrac = ?mxnreg and SA_Siniestro=  ?mx_Siniestro ","mwkctrart")
		mid = mwkctrart.Id
	Else
		mid = mwkctrart.Id
		mret = SQLExec(mcon1, "update ZabSegART set SA_Dictamen =?mx_Dictamen , SA_Estado = ?mx_Estado"+;
			", SA_FechaFin = ?mxfecfin where id = ?mid ")
	Endif
	If mret < 0
		=Aerror(merror)
		Messagebox("EN graba ART"+Chr(10)+;
			alltrim(merror(3)),16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Else
		mret = SQLExec(mcon1, "insert into ZabSegARTLog (SAL_Estado, SAL_Fechamod, SAL_Usuario , SAL_idSiniestro) "+;
			" values (?mx_Estado,currENT_timestamp,?midusu,?mid  )")
	Endif

*************
	Use In Select('mwkctrart')
	chabcama =''
	cadm =''
	If Used('mwkpacintart')
		chabcama = Alltrim(mwkpacintart.PAC_habitacion)+ '-'+Alltrim(mwkpacintart.PAC_cama)
		cadm = mwkpacintart.PAC_codadmision

	Endif
	mx_Siniestro = Val(Transform(mx_Siniestro ))
	mret = SQLExec(mcon1, " select id from  Tabartreg where TAR_entidad= ?mxent and  TAR_finpro = '1900-01-01' "+;
		" and  TAR_registracio = ?mxnreg and TAR_siniestro=  ?mx_Siniestro ","mwkctrart")
	If Reccount("mwkctrart")=0
		mret = SQLExec(mcon1, " insert into Tabartreg (TAR_Admision, TAR_HabCama, TAR_codart, TAR_codsg,"+;
			" TAR_entidad, TAR_fecmov, TAR_finpro, TAR_inipro, TAR_proxate, TAR_registracio, TAR_siniestro,"+;
			" TAR_tipo, TAR_tipoAlta, TAR_usuario, TAR_evolint)"+;
			" values ( ?cadm ,?chabcama ,0, ?mxcodmed, ?mxent,currENT_timestamp "+;
			", ?mxfecfin , ?mfechoy ,?mx_proxate , ?mxnreg , ?mx_Siniestro, ?mxctipoat,?mx_Estado ,?miusuarioid,?mx_Dictamen )")
		mret = SQLExec(mcon1, " select id from  Tabartreg where TAR_entidad= ?mxent and  TAR_finpro = '1900-01-01' "+;
			" and  TAR_registracio = ?mxnreg and TAR_siniestro=  ?mx_Siniestro ","mwkctrart")
		mid = mwkctrart.Id
	Else
		mid = mwkctrart.Id
		mret = SQLExec(mcon1, " update Tabartreg set  TAR_evolint=?mx_Dictamen , TAR_tipoAlta= ?mx_Estado"+;
			",TAR_proxate= ?mx_proxate , TAR_finpro= ?mxfecfin where id = ?mid ")
	Endif
	If mret < 0
		=Aerror(merror)
		Messagebox("EN graba ART"+Chr(10)+;
			alltrim(merror(3)),16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif

Endcase
