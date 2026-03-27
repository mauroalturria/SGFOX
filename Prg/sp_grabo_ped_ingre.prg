************
*   grabacion de anamnesis pediatirca

**********

parameters lgrabobien,mnroreg, mprot, mmedico,midevolu,mpgAnam,musua,morigen
if vartype(morigen)#"N"
	morigen = 0
	lmismomed = .f.
endif
midusuario = iif(used('mwkusuarios'),mwkusuarios.id ,mwkusuario.id)
lgrabobien = .t.
mfechahora  = sp_busco_fecha_serv("DT")
mfechadia = ttod(mfechahora )
mfecini = ctod("01/01/1900")
mfecfin = ctod("01/01/2100")
msoloevol = ''
mIPA_codmed = mmedico
mIPA_fechaH = mfechadia
mIPA_usuario = midusuario
midevol	= midevolu &&mopage.parent.parent.parent.parent.midevol
with mpgAnam
*!* -----------------   Cargamos datos del page pgAnApa ------------------------------------------------------
	with .Page1
		mIPA_Gralmotint = .TxteditMotInt.value
		mIPA_GralEnfAct = .TxteditEnfAct.value
		mIPA_GralExCompPrev = .TxteditExcompl.value

		with  .Cnttepingr1

			mIPA_TGralTas = .txtTaSist.value
			mIPA_TGralEB = .txteb.value
			mIPA_TGralFio = .txtfio.value
			mIPA_TGralPao = .txtpao2.value
			mIPA_TGralPim = .txtpim.value
			mIPA_TGralIngel = .optingsel.value
			mIPA_TGralPqx = .optpqx.value
			mIPA_TGralCec = .optcec.value
			mIPA_TGralMpb = .optmpb.value
			mIPA_TGralArm = .optARM.value
			mIPA_TGralDgAlto = mwkdiagnoalta.pc_orden
			mIPA_TGralDgBajo = mwkdiagnobaja.pc_orden

		endwith
	endwith

	mIPA_PlanTto = iif(.Page1.Cnttepingr1.visible,.Page1.Cnttepingr1.TxtEd_an_planT.value,.Page4.TxtEd_an_planT.value)
	mIPA_ExamenComplem = iif(.Page1.Cnttepingr1.visible,.Page1.Cnttepingr1.Txtedexcompl.value,.Page4.Txtedexcompl.value)

	with .page2
		mIPA_qmLabHto = .txtlabhto.value
		mIPA_qmLabHb = .txtlabhb.value
		mIPA_qmLabPla = .txtlabpla.value
		mIPA_qmLabLT = .txtlablt.value
		mIPA_qmLabformLT = .txtlabfor.value
		mIPA_qmLabNT = .txtlabnt.value
		mIPA_qmLabCrea = .txtlabcre.value
		mIPA_qmLabUr = .txtlabur.value
		mIPA_qmLabNa = .txtlabna.value
		mIPA_qmLabK = .txtlabk.value
		mIPA_qmLabGOT = .txtlabgot.value
		mIPA_qmLabGPT = .txtlabgpt.value
		mIPA_qmLabOtros = .txtlabotros.value
		mIPA_qmdiasPrev = .txtdiasInt.value
		mIPA_qmportaCateter = .optcatimp.value
		mIPA_qmDiagnosPrev = .txtdiagnosprevio.value
		mIPA_qmfechaIniDiag = IIF(.txtfecinidiagno.value = CTOD("  /  /  "),null,.txtfecinidiagno.value)
		mIPA_qmMImanCat	= .chkmtocat.value
		mIPA_qmMIotros = .chkotros.value
		mIPA_qmMIotrosMot = alltrim(.txtotromot.value)
		mIPA_qmMIprocdiag = .chkPD.value
		mIPA_qmMIquimio	=.chkqt.value
		mIPA_qmMItransf	= .chkTransf.value
		mIPA_qmfechaUlt = IIF(.txtfechaqt.value = CTOD("  /  /  "),null,.txtfechaqt.value)
		mIPA_qmProblemAnt = .Txtedprobqt.value
		mIPA_qmAntec = .Txtedantec.value
		mIPA_qmDrogasPac = .Txteddrgpac.value
		mIPA_qmDrogas = .txteddrgfar.value
	endwith
	with .Page3
		mIPA_EFDiasvida  = .txtdias.value
		mIPA_EFPesoEstimado = .txtpesoest.value
		mIPA_EFPesoReal = .txtpesoreal.value
		mIPA_EFTalla = .txttalla.value
		mIPA_EFPerimCef = .txtpercef.value
		mIPA_EFPercPeso = .txtpercpeso.value
		mIPA_EFPercTalla = .txtperctalla.value
		mIPA_EFdatospositivos = .txtEd_datos_posit.value
		mIPA_EFPesoval = .chkPesoval.value
		mIPA_EFEstadoGral = .optestgral.value
		mIPA_EFEstadoGralObs = .txtedestado.value
		select mwkexfis
		go top
		scan
			if si>0 or no >0
				mobs = observa
				midef = id
				mopc = iif(Si=1,1,iif(no = 1,2,0))
				mret = sqlexec(mcon1, "SELECT id FROM ZabIntPedExFis " + ;
					" where IPEF_idevol = ?midevol and IPEF_idexamen = ?midef  ", "mwkVerexfis")
				if reccount("mwkVerexfis")=0
					text To lcsql Textmerge Noshow Pretext 7
						INSERT INTO  ZabIntPedExFis
							(IPEF_Observa, IPEF_Opcion, IPEF_codmed, IPEF_fechaH, IPEF_idevol, IPEF_idexamen,IPEF_usuario )
							values (?mobs,?mopc,?mmedico,?mfechahora, ?midevol,?midef,?midusuario  )
					ENDTEXT
					if !Prg_EjecutoSql(lcSql)
					endif
				else
					mid = mwkVerexfis.id
					text To lcsql Textmerge Noshow Pretext 7
						UPDATE ZabIntPedExFis SET IPEF_Observa = ?mobs, IPEF_Opcion = ?mopc, IPEF_codmed= ?mmedico, IPEF_fechaH = ?mfechahora, IPEF_usuario = ?midusuario
							where id = ?mid
					ENDTEXT
					if !Prg_EjecutoSql(lcSql)
					endif
				endif
			endif
		endscan
	endwith
endwith
mret = sqlexec(mcon1, "SELECT id FROM ZabIntPedAnam " + ;
	" where IPA_idevol = ?midevol ", "mwkVerana")
if mret < 0
	=aerr(eros)
	messagebox(eros(3), 48, "Validacion")
endif


if reccount('mwkVerana')= 0
	mret = sqlexec(mcon1, "insert into ZabIntPedAnam " + ;
		" (IPA_EFDiasVida,IPA_EFPercPeso,IPA_EFPercTalla,IPA_EFPerimCef,IPA_EFPesoEstimado,IPA_EFPesoReal,IPA_EFPesoval,IPA_EFTalla"+;
		", IPA_EFEstadoGral, IPA_EFEstadoGralObs ,IPA_EFdatospositivos,IPA_ExamenComplem,IPA_GralEnfAct,IPA_GralExCompPrev,IPA_Gralmotint"+;
		",IPA_PlanTto,IPA_codmed,IPA_fechaH"+;
		",IPA_idevol,IPA_qmAntec,IPA_qmDiagnosPrev,IPA_qmDrogas,IPA_qmDrogasPac,IPA_qmLabCrea,IPA_qmLabGOT,IPA_qmLabGPT,IPA_qmLabHb"+;
		",IPA_qmLabHto,IPA_qmLabK,IPA_qmLabLT,IPA_qmLabNT,IPA_qmLabNa,IPA_qmLabOtros,IPA_qmLabPla,IPA_qmLabUr,IPA_qmLabformLT"+;
		",IPA_qmProblemAnt,IPA_qmdiasPrev,IPA_qmfechaIniDiag,IPA_qmfechaUlt,IPA_qmMImanCat, IPA_qmMIotros, IPA_qmMIotrosMot, IPA_qmMIprocdiag"+;
		", IPA_qmMIquimio, IPA_qmMItransf,IPA_qmportaCateter,IPA_usuario"+;
		", IPA_TGralTas, IPA_TGralEB ,IPA_TGralFio , IPA_TGralPao, IPA_TGralPim , IPA_TGralIngel , IPA_TGralPqx , IPA_TGralCec , IPA_TGralMpb"+;
		", IPA_TGralArm , IPA_TGralDgAlto , IPA_TGralDgBajo )"+;
		" values(?mIPA_EFDiasVida, ?mIPA_EFPercPeso, ?mIPA_EFPercTalla, ?mIPA_EFPerimCef, ?mIPA_EFPesoEstimado, ?mIPA_EFPesoReal, ?mIPA_EFPesoval, ?mIPA_EFTalla"+;
		", ?mIPA_EFEstadoGral, ?mIPA_EFEstadoGralObs, ?mipa_EFdatospositivos, ?mIPA_ExamenComplem, ?mIPA_GralEnfAct, ?mIPA_GralExCompPrev, ?mIPA_Gralmotint"+;
		", ?mIPA_PlanTto, ?mIPA_codmed, ?mIPA_fechaH"+;
		", ?midevol , ?mIPA_qmAntec, ?mIPA_qmDiagnosPrev, ?mIPA_qmDrogas, ?mIPA_qmDrogasPac, ?mIPA_qmLabCrea, ?mIPA_qmLabGOT, ?mIPA_qmLabGPT, ?mIPA_qmLabHb"+;
		", ?mIPA_qmLabHto, ?mIPA_qmLabK, ?mIPA_qmLabLT, ?mIPA_qmLabNT, ?mIPA_qmLabNa, ?mIPA_qmLabOtros, ?mIPA_qmLabPla, ?mIPA_qmLabUr, ?mIPA_qmLabformLT"+;
		", ?mIPA_qmProblemAnt, ?mIPA_qmdiasPrev, ?mIPA_qmfechaIniDiag, ?mIPA_qmfechaUlt, ?mIPA_qmMImanCat, ?mIPA_qmMIotros, ?mIPA_qmMIotrosMot"+;
		", ?mIPA_qmMIprocdiag, ?mIPA_qmMIquimio, ?mIPA_qmMItransf, ?mIPA_qmportaCateter, ?mIPA_usuario"+;
		", ?mIPA_TGralTas, ?mIPA_TGralEB ,?mIPA_TGralFio , ?mIPA_TGralPao, ?mIPA_TGralPim , ?mIPA_TGralIngel , ?mIPA_TGralPqx , ?mIPA_TGralCec , ?mIPA_TGralMpb"+;
		", ?mIPA_TGralArm , ?mIPA_TGralDgAlto , ?mIPA_TGralDgBajo )")
else
	mret = sqlexec(mcon1, "update ZabIntPedAnam set " + ;
		" IPA_EFDiasVida  = ?mIPA_EFDiasVida, IPA_EFPercPeso = ?mIPA_EFPercPeso, IPA_EFPercTalla = ?mIPA_EFPercTalla"+;
		", IPA_EFPerimCef  = ?mIPA_EFPerimCef, IPA_EFPesoEstimado = ?mIPA_EFPesoEstimado, IPA_EFPesoReal = ?mIPA_EFPesoReal,IPA_EFPesoval  = ?mIPA_EFPesoval, IPA_EFTalla = ?mIPA_EFTalla"+;
		", IPA_EFEstadoGral= ?mIPA_EFEstadoGral,IPA_EFEstadoGralObs = ?mIPA_EFEstadoGralObs ,IPA_EFdatospositivos  = ?mipa_EFdatospositivos, IPA_ExamenComplem = ?mIPA_ExamenComplem, IPA_GralEnfAct = ?mIPA_GralEnfAct"+;
		", IPA_GralExCompPrev = ?mIPA_GralExCompPrev, IPA_Gralmotint = ?mIPA_Gralmotint,IPA_PlanTto  = ?mIPA_PlanTto,IPA_codmed  = ?mIPA_codmed, IPA_fechaH = ?mIPA_fechaH"+;
		", IPA_qmAntec  = ?mIPA_qmAntec, IPA_qmDiagnosPrev = ?mIPA_qmDiagnosPrev, IPA_qmDrogas = ?mIPA_qmDrogas"+;
		", IPA_qmDrogasPac = ?mIPA_qmDrogasPac,IPA_qmLabCrea  = ?mIPA_qmLabCrea,IPA_qmLabGOT  = ?mIPA_qmLabGOT,IPA_qmLabGPT  = ?mIPA_qmLabGPT, IPA_qmLabHb = ?mIPA_qmLabHb"+;
		", IPA_qmLabHto = ?mIPA_qmLabHto, IPA_qmLabK = ?mIPA_qmLabK, IPA_qmLabLT = ?mIPA_qmLabLT, IPA_qmLabNT = ?mIPA_qmLabNT, IPA_qmLabNa = ?mIPA_qmLabNa"+;
		", IPA_qmLabOtros = ?mIPA_qmLabOtros,IPA_qmLabPla  = ?mIPA_qmLabPla,IPA_qmLabUr  = ?mIPA_qmLabUr, IPA_qmLabformLT = ?mIPA_qmLabformLT"+;
		", IPA_qmProblemAnt = ?mIPA_qmProblemAnt,IPA_qmdiasPrev  = ?mIPA_qmdiasPrev,  IPA_qmfechaIniDiag= ?mIPA_qmfechaIniDiag,IPA_qmfechaUlt  = ?mIPA_qmfechaUlt"+;
		", IPA_qmMImanCat = ?mIPA_qmMImanCat , IPA_qmMIotros = ?mIPA_qmMIotros , IPA_qmMIotrosMot = ?mIPA_qmMIotrosMot , IPA_qmMIprocdiag = ?mIPA_qmMIprocdiag "+;
		", IPA_qmMIquimio = ?mIPA_qmMIquimio , IPA_qmMItransf = ?mIPA_qmMItransf , IPA_qmportaCateter = ?mIPA_qmportaCateter,IPA_usuario= ?mIPA_usuario"+;
		", IPA_TGralTas = ?mIPA_TGralTas, IPA_TGralEB = ?mIPA_TGralEB,IPA_TGralFio = ?mIPA_TGralFio, IPA_TGralPao = ?mIPA_TGralPao, IPA_TGralPim = ?mIPA_TGralPim "+;
		", IPA_TGralIngel = ?mIPA_TGralIngel, IPA_TGralPqx  = ?mIPA_TGralPqx, IPA_TGralCec = ?mIPA_TGralCec, IPA_TGralMpb = ?mIPA_TGralMpb"+;
		", IPA_TGralArm = ?mIPA_TGralArm, IPA_TGralDgAlto = ?mIPA_TGralDgAlto, IPA_TGralDgBajo = ?mIPA_TGralDgBajo"+;
		" where IPA_idevol = ?midevol ")

endif

use in select('mwkVerana')
if mret < 0
	mret=aerr(eros)
	messagebox(eros(3),"Validacion")
	return(.f.)
else
	return(.t.)
endif
