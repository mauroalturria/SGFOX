*
* Actualiza maestro TabAmbOnco
*
Parameters mform

Local mIdOnco

mfnull = Ctod("01/01/1900")
muser  = mwkusuario.idusuario
mfecm  = sp_busco_fecha_serv('DT')
msg    = ""

With mform
	mlvalida1 = (Type('m' + Alltrim(mform.Name) + 'CmdAuditoria') # 'U')
	mlvalida2 = (Type('m' + Alltrim(mform.Name) + 'cmdhdo') # 'U')
	mlvalida3 = (Type('m' + Alltrim(mform.Name) + 'cmdfarmacia') # 'U')

	muser = Iif(.midmed > 0 And Left(mwkusuario.nomape,1)="*","!"+Transf(.midmed ),muser)
	Dimension vdat[13]

	vdat[01]  = .lnroregis
	vdat[02]  = .txtturno.Value
	vdat[03]  = .txtlabor.Value
	vdat[04]  = .chk1.Value
	vdat[05]  = .txtobs1.Value
	vdat[06]  = .chk2.Value
	vdat[07]  = .txtobs2.Value
	vdat[08]  = .chk3.Value
	vdat[09]  = .txtobs3.Value
	vdat[10]  = .chk4.Value
	vdat[11]  = .txtobs4.Value
	lmedfarma = Empty(Ctot(Ttoc(.txtrecibe.Value)))
	vdat[12]  = Iif(lmedfarma,Ctod("01/01/1900"),.txtrecibe.Value)
	vdat[13]  = .chk5.Value
	midturno  = mwkambonco.ltid

	Use In Select("mwkctrlonco")
	mret = SQLExec(mcon1,"select * from TabAmbOnco where TAO_idturnos = ?midturno","mwkctrlonco")

	If mret < 0
		Messagebox("EN CONSULTA DE HOSP. DE DIA ONCOLOGICO"+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		Do log_errores With Error(), Message(),;
			vartype(vdat[12])+Alltrim(Transf(vdat[12]))+Message(1), Program(), Lineno()
		Return .F.
	Endif

	If Used("mwkctrlonco")
		If Reccount("mwkctrlonco") = 0
			mret = SQLExec(mcon1,"insert into TabAmbOnco"+;
				" (TAO_registracio,TAO_fturno,TAO_flabor,TAO_autesque,"+;
				"TAO_autacomp,TAO_autprqui,TAO_autfarm,"+;
				"TAO_fmedfarma,TAO_usuario,TAO_fechamov,TAO_fpasiva,TAO_idturnos,TAO_consentimiento )"+;
				" values "+;
				"(?vdat[01],?vdat[02],?vdat[03],?vdat[04],?vdat[06],"+;
				" ?vdat[08],?vdat[10],?vdat[12],?muser,?mfecm,?mfnull,?midturno,?vdat[13])")
		Else
			midturno = mwkctrlonco.Id

*!*			"TAO_registracio = ?vdat[01],"+;
*!*			"TAO_fturno      = ?vdat[02],"+;

			If mlvalida1 && Medico Audito Consultorios Externos
				mret = SQLExec(mcon1,"update TabAmbOnco set "+;
					"TAO_flabor      = ?vdat[03],"+;
					"TAO_autesque    = ?vdat[04],"+;
					"TAO_autacomp    = ?vdat[06],"+;
					"TAO_consentimiento = ?vdat[13],"+;
					"TAO_usuario     = ?muser,"+;
					"TAO_fechamov    = ?mfecm"+;
					" where id = ?midturno")
				If mret < 0
					Messagebox("EN ANTUALIZACION DE HOSP. DE DIA ONCOLOGICO"+Chr(10)+;
						"AVISE A SISTEMAS",16,"ERROR")
					Do log_errores With Error(), Message(),;
						vartype(vdat[12])+Alltrim(Transf(vdat[12]))+Message(1), Program(), Lineno()
					Return .F.
				Endif
			Endif

			If mlvalida2 && Hospital de Dia Oncologico
				mret = SQLExec(mcon1,"update TabAmbOnco set "+;
					"TAO_flabor      = ?vdat[03],"+;
					"TAO_autprqui    = ?vdat[08],"+;
					"TAO_usuario     = ?muser,"+;
					"TAO_fechamov    = ?mfecm"+;
					" where id = ?midturno")
				If mret < 0
					Messagebox("EN ACTUALIZACION DE HOSP. DE DIA ONCOLOGICO"+Chr(10)+;
						"AVISE A SISTEMAS",16,"ERROR")
					Do log_errores With Error(), Message(),;
						vartype(vdat[12])+Alltrim(Transf(vdat[12]))+Message(1), Program(), Lineno()
					Return .F.
				Endif
			Endif

			If mlvalida3 && Farmacia entrega de materiales
				mret = SQLExec(mcon1,"update TabAmbOnco set "+;
					"TAO_autfarm     = ?vdat[10],"+;
					"TAO_fmedfarma   = ?vdat[12],"+;
					"TAO_usuario     = ?muser,"+;
					"TAO_fechamov    = ?mfecm"+;
					" where id = ?midturno")
				If mret < 0
					Messagebox("EN ANTUALIZACION DE HOSP. DE DIA ONCOLOGICO"+Chr(10)+;
						"AVISE A SISTEMAS",16,"ERROR")
					Do log_errores With Error(), Message(),;
						vartype(vdat[12])+Alltrim(Transf(vdat[12]))+Message(1), Program(), Lineno()
					Return .F.
				Endif
			Endif

		Endif
	Endif

	Use In Select("mwkctrlonco")
	If mret < 0
		Messagebox("EN ANTUALIZACION DE HOSP. DE DIA ONCOLOGICO"+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		Do log_errores With Error(), Message(),;
			vartype(vdat[12])+Alltrim(Transf(vdat[12]))+Message(1), Program(), Lineno()
		Return .F.
	Endif

*!*	---------------------------------------
*!*	ID
*!*	---------------------------------------
	If mform.lqtipo = "A"
		mret = SQLExec(mcon1,"Select Id " + ;
			"from TabAmbOnco " + ;
			"where TAO_fturno = ?vdat[02] and TAO_registracio = ?vdat[01] " + ;
			"Order by id desc ", "mwkAmbObcAux")
		If mret < 0
			Messagebox("ERROR EN LA CONSULTA ",16,"ERROR")
			Do log_errores With Error(), Message(), ;
				vartype(vdat[12])+Alltrim(Transf(vdat[12]))+Message(1), Program(), Lineno()
			Return .F.
		Endif
		mIdOnco = mwkAmbObcAux.Id
		Use In mwkAmbObcAux
	Else
		mIdOnco = mform.lregistroid
	Endif
*!*	---------------------------------------
*!*	GUARDO SIEMPRE
*!*	---------------------------------------
	If !Empty(vdat[05]) && Obs1
		Do sp_grabo_OncoObs With 1, 0, mfecm, mIdOnco, vdat[05], 1, muser
	Endif
	If !Empty(vdat[07]) && Obs2
		Do sp_grabo_OncoObs With 1, 0, mfecm, mIdOnco, vdat[07], 2, muser
	Endif
	If !Empty(vdat[09]) && Obs3
		Do sp_grabo_OncoObs With 1, 0, mfecm, mIdOnco, vdat[09], 3, muser
	Endif
	If !Empty(vdat[11]) && Obs4
		Do sp_grabo_OncoObs With 1, 0, mfecm, mIdOnco, vdat[11], 4, muser
	Endif
*!*	---------------------------------------
	Release vdat

	If mform.lqtipo = "M"

		If mwkcontrol.fturno <> .txtturno.Value
			msg = msg + "Fecha Turno, anterior: "+Dtoc(mwkcontrol.fturno)+;
				", actual "+Dtoc(.txtturno.Value)+Chr(10)
		Endif

		If mwkcontrol.flabor <> .txtlabor.Value
			msg = msg + "Fecha Laboratorio, anterior: "+Dtoc(mwkcontrol.flabor)+;
				", actual "+Dtoc(.txtlabor.Value)+Chr(10)
		Endif

		If mwkcontrol.chk1 <> .chk1.Value
			msg = msg + "Confirmación Esq. Tratamiento, anterior: "+;
				iif(mwkcontrol.chk1=0,"NO","SI")+", actual "+Iif(.chk1.Value=0,"NO","SI")+Chr(10)
		ENDIF
		If mwkcontrol.chk5 <> .chk5.Value
			msg = msg + "Consentimiento Informado Firmado, anterior: "+;
				iif(mwkcontrol.chk5=0,"NO","SI")+", actual "+Iif(.chk5.Value=0,"NO","SI")+Chr(10)
		Endif

		If mwkcontrol.chk2 <> .chk2.Value
			msg = msg + "Confirmación Alta Complejidad, anterior: "+;
				iif(mwkcontrol.chk2=0,"NO","SI")+", actual "+Iif(.chk2.Value=0,"NO","SI")+Chr(10)
		Endif

		If mwkcontrol.chk3 <> .chk3.Value
			msg = msg + "Confirmación Ctrl. Pre Quimioterapia, anterior: "+;
				iif(mwkcontrol.chk3=0,"NO","SI")+", actual "+Iif(.chk3.Value=0,"NO","SI")+Chr(10)
		Endif

		If mwkcontrol.chk4 <> .chk4.Value
			msg = msg + "Confirmación Farmacia recepción de materiales a tiempo, anterior: "+;
				iif(mwkcontrol.chk4=0,"NO","SI")+", actual "+Iif(.chk4.Value=0,"NO","SI")+Chr(10)
		Endif

		If mwkcontrol.obs1 <> .txtobs1.Value
			msg = msg + "Esq.Tratamiento Obs., anterior: "+;
				alltrim(mwkcontrol.obs1)+", actual "+Alltrim(.txtobs1.Value)+Chr(10)
		Endif

		If mwkcontrol.obs2 <> .txtobs2.Value
			msg = msg + "Alta Complejidad Obs., anterior: "+;
				alltrim(mwkcontrol.obs2)+", actual "+Alltrim(.txtobs2.Value)+Chr(10)
		Endif

		If mwkcontrol.obs3 <> .txtobs3.Value
			msg = msg + "Ctrl. Pre-Quimioterapia Obs., anterior: "+;
				alltrim(mwkcontrol.obs3)+", actual "+Alltrim(.txtobs3.Value)+Chr(10)
		Endif

		If mwkcontrol.obs4 <> .txtobs4.Value
			msg = msg + "Farmacia Recepción Materiales Obs., anterior: "+;
				alltrim(mwkcontrol.obs4)+", actual "+Alltrim(.txtobs4.Value)+Chr(10)
		Endif

		If mwkcontrol.fmat <> .txtrecibe.Value
			msg = msg + "Fecha Recepción Materiales, anterior: "+Ttoc(mwkcontrol.fmat)+;
				", actual "+Ttoc(.txtrecibe.Value)+Chr(10)
		Endif

		If mwkcontrol.nregi <> .lnroregis
			msg = msg + "Paciente, anterior: "+Alltrim(mwkambonco.REG_nombrepac)+;
				", actual "+Alltrim(.txtpaciente.Value)+Chr(10)
		Endif

	Else

		Use In Select("mwkctrlid")
		mret = SQLExec(mcon1,"select id as lidtur from TabAmbOnco"+;
			" where TAO_usuario = ?muser and TAO_fechamov = ?mfecm and TAO_fpasiva = ?mfnull","mwkctrlid")

		If mret < 0
			Messagebox("EN CONSULTA DE HOSP. DE DIA ONCOLOGICO ID TURNO"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		midturno = mwkctrlid.lidtur
		msg      = "Hospital de Día Oncológico Inicio LOG "+Chr(10)
		msgN     = ""

		Use In Select("mwkctrlid")

		If !Empty(.txtlabor.Value) && Fecha de Laboratorio
			msgN = msgN + "Fecha Laboratorio: " + Dtoc(.txtlabor.Value) + Chr(10)
		Endif

		If .chk1.Value = 1 && Esq. tratamiento
			msgN = msgN + "Confirmación Esq. Tratamiento: SI" + Chr(10)
		ENDIF
		
		If .chk5.Value = 1 && Cons.Informado
			msgN = msgN + "Consentimiento Informado: SI" + Chr(10)
		Endif
		If .chk2.Value = 1 && Alta complejidad
			msgN = msgN + "Confirmación Alta Complejidad : SI" + Chr(10)
		Endif

		If .chk3.Value = 1 && Ctrl. prequimio
			msgN = msgN + "Confirmación Ctrl. Pre Quimioterapia: SI" + Chr(10)
		Endif

		If .chk4.Value = 1 && Recep. materiales
			msgN = msgN + "Confirmación Farmacia recepción de materiales a tiempo: SI" + Chr(10)
		Endif

		If !Empty(.txtobs1.Value) && Esq. tratamiento
			msgN = msgN + "Esq.Tratamiento Obs.: " + Alltrim(.txtobs1.Value) + Chr(10)
		Endif

		If !Empty(.txtobs2.Value) && Alta complejidad
			msgN = msgN + "Alta Complejidad Obs.: " + Alltrim(.txtobs2.Value) + Chr(10)
		Endif

		If !Empty(.txtobs3.Value) && Ctrl. prequimio
			msgN = msgN + "Ctrl. Pre-Quimioterapia Obs.: "+ Alltrim(.txtobs3.Value)+Chr(10)
		Endif

		If !Empty(.txtobs4.Value) && Recep. materiales
			msgN = msgN + "Farmacia Recepción Materiales Obs.: "+Alltrim(.txtobs4.Value)+Chr(10)
		Endif

		If !Empty(.txtrecibe.Value) && Fec. recep. materiales
			msgN = msgN + "Fecha Recepción Materiales: " + Ttoc(.txtrecibe.Value) + Chr(10)
		Endif

		msg = msg + Iif(!Empty(msgN),msgN,"SIN CAMBIOS")

	Endif

	If Len(Alltrim(msg))>0
		If	mform.lqtipo = "M"
			msg = "Cambios para: "+Alltrim(.txtpaciente.Value)+Chr(10)+msg
		Endif

		mret = SQLExec(mcon1,"insert into TabAmbOncoLog"+;
			" (TOL_idturno,TOL_usuario,TOL_fechamov,TOL_cambios)"+;
			" values "+;
			"(?midturno,?muser,?mfecm,?msg)")

		If mret < 0
			Messagebox("EN ACTUALIZACION DE HOSP. DE DIA ONCOLOGICO LOG"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif
	Endif

Endwith
Return .T.
