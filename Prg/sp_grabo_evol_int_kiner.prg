*!*	actualizo evolucion AKR
Parameters  mKRE_PEmax, mKRE_PImax, mKRE_THB, mKRE_VNI, mKRE_canula, mKRE_capVital, mKRE_codmed, ;
			mKRE_evalDeg, mKRE_evaluacion, mKRE_idevol, mKRE_mascaraO2, mKRE_medCapv, mKRE_medUlc, mKRE_monyadap, mKRE_prevNav, mKRE_tomaM, ;
			mKRE_ventilacion, mKRE_viaAerea, mKRE_weaning

mfechahor = sp_busco_fecha_serv("DT")

lcSql = "Insert into TabIntAKRevol" + ;
	" (KRE_fechaHora,KRE_PEmax,KRE_PImax,KRE_THB,KRE_VNI,KRE_canula,KRE_capVital,KRE_codmed,KRE_evalDeg,KRE_evaluacion,"+;
	" KRE_idevol,KRE_mascaraO2,KRE_medCapv,KRE_medUlc,KRE_monyadap,KRE_prevNav,KRE_tomaM,KRE_ventilacion,KRE_viaAerea,KRE_weaning) " + ;
	" Values " + ;
	" (?mfechahor , ?mKRE_PEmax, ?mKRE_PImax, ?mKRE_THB, ?mKRE_VNI, ?mKRE_canula, ?mKRE_capVital, ?mKRE_codmed,"+ ;
	" ?mKRE_evalDeg, ?mKRE_evaluacion, ?mKRE_idevol, ?mKRE_mascaraO2, ?mKRE_medCapv, ?mKRE_medUlc, ?mKRE_monyadap, ?mKRE_prevNav, ?mKRE_tomaM, "+;
	" ?mKRE_ventilacion, ?mKRE_viaAerea, ?mKRE_weaning) "


if !Prg_EjecutoSql(lcSql,'',.f.)
*	Return .f.
Endif 
