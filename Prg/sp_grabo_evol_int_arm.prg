*!*	sp_actualizo_TabIntBalH (tnOpcion, tnId, tnentsal, ttfechaH, tnidevol, tcobserva, tntipo, tnusuario, tnvolumen)
parameters  mARM_Fio2,mARM_VniArm,mARM_codmed,mARM_compliance,;
	mARM_frecResp,mARM_idevol,mARM_pafi,mARM_peep,mARM_plateau,mARM_ppico,mARM_resist,;
	mARM_satO2,mARM_tinsp,mARM_vLimite,mARM_vt,moptarm ,marmmodo ,marmcomp,marmmot ,marmfini ,mtuboot,mtraq,mtraqfini,mlcbioarm,mlcambiotot,mlcambiotraq


mfechahora  = sp_busco_fecha_serv("DT")
mfechadia = ttod(mfechahora )
mfecini = ctod("01/01/1900")
mfecfin = ctod("01/01/2100")
if vartype(mARM_Fio2)#"N"

	lcSql = "Insert into TabIntParamArm" + ;
		" (ARM_fechaHora,ARM_VniArm,ARM_codmed,ARM_frecResp,ARM_idevol,"+;
		"ARM_peep,ARM_ppico,ARM_satO2,ARM_vt) " + ;
		" Values " + ;
		" (?mfechahora ,  ?mARM_VniArm, ?mARM_codmed, ?mARM_frecResp, ?mARM_idevol,"+;
		"  ?mARM_peep, ?mARM_ppico,  ?mARM_satO2,  ?mARM_vt) "
else
	lcSql = "Insert into TabIntParamArm" + ;
		" (ARM_fechaHora,ARM_Fio2,ARM_VniArm,ARM_codmed,ARM_compliance,ARM_frecResp,ARM_idevol,ARM_pafi"+;
		",ARM_peep,ARM_plateau,ARM_ppico,ARM_resist,ARM_satO2,ARM_tinsp,ARM_vLimite,ARM_vt) " + ;
		" Values " + ;
		" (?mfechahora , ?mARM_Fio2, ?mARM_VniArm, ?mARM_codmed, ?mARM_compliance, ?mARM_frecResp, ?mARM_idevol,"+;
		" ?mARM_pafi, ?mARM_peep, ?mARM_plateau, ?mARM_ppico, ?mARM_resist, ?mARM_satO2, ?mARM_tinsp, ?mARM_vLimite, ?mARM_vt) "
endif

if !Prg_EjecutoSql(lcSql,'',.f.)
*	return .f.
endif
if vartype(mARM_Fio2)#"N"
	return .t.
endif
if mlcbioarm
	select mwkARM
	miavn = mwkARM.id
	if mARM_VniArm = 2 and reccount('mwkARM')>0   &&&& da por finalizada
		lcSql = "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
			" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=1 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia "

		if !Prg_EjecutoSql(lcSql,'',.f.)
*	return .f.
		endif

	else &&& actualiza o inserta
		mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
			" where  AVN_idevol = ?midevol and AVN_tipo=1 and AVN_fechafin = ?mfecfin ", "mwkVerAVN")

		if mret < 0
			do log_errores with error(), message(), message(1), program(), lineno()
		endif

		miavn = mwkVerAVN.id
		if miavn > 0 &&&actualizo
			lcSql  = "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
				" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?miavn "
		else
			lcSql  = "insert into TabIntAVN " + ;
				" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
				" values "+;
				" (?marmcomp  ,?mfecfin, ?mfechahora,?marmfini, ?midevol,?marmmodo, ?marmmot , 1,?midusuario  )"
		endif
		if !Prg_EjecutoSql(lcSql,'',.f.)
*			return .f.
		endif
	endif
endif
if mlcambiotot
****  actualiza tubo OT
	select mwkToT
	mitot = mwkToT.id
	if mtuboot = 2 and reccount('mwkToT')>0   &&&& da por finalizada
		lcSql  = "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
			" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=4 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia "
		if !Prg_EjecutoSql(lcSql,'',.f.)
*			return .f.
		endif
	else &&& actualiza o inserta
		if mtuboot = 1
			mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
				" where  AVN_idevol = ?midevol and AVN_tipo = 4 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
			mitot = mwkVerAVN.id
			if mitot = 0 &&&inserto
				lcSql  = "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (0,?mfecfin, ?mfechahora,?mtotfini, ?midevol,0,0 , 4,?midusuario  )"
			else
			endif
			if !Prg_EjecutoSql(lcSql,'',.f.)
*			return .f.
			endif
		endif
	endif
endif
if mlcambiotraq
****  actualiza traq
	select mwkTraq
	mitraq = mwkTraq.id
	if mtraq = 2 and reccount('mwkTraq')>0   &&&& da por finalizada
		lcSql  = "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
			" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  5 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia "
		if !Prg_EjecutoSql(lcSql,'',.f.)
*			return .f.
		endif
	else &&& actualiza o inserta
		if mtraq = 1
			mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
				" where  AVN_idevol = ?midevol and AVN_tipo = 5 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
			mitraq = mwkVerAVN.id
			if mitraq = 0 &&&inserto
				lcSql  = "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (0,?mfecfin, ?mfechahora,?mtraqfini , ?midevol,0,0 , 5,?midusuario  )"
				if !Prg_EjecutoSql(lcSql,'',.f.)
*			return .f.
				endif
			endif
		endif
	endif
endif
