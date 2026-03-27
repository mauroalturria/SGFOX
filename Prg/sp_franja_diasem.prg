
* TRAE LAS FRANJAS del dia
******************************
parameters vr_codmed, vr_diasem ,tcCursor,vr_memo

if vartype(tcCursor) # "C"
	tcCursor= 'MwkFranjaDia'
endif
if vartype(vr_memo) # "N"
	vr_memo = 0
endif
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
ENDIF

	mccpocmed = " and centromed = ?mxcentromedico "

tcWhere1 = " WHERE codmed = " + alltrim(transform(vr_codmed))+ " and diasem = " + alltrim(transform(vr_diasem)) + ;
	" AND fecvigend < fecvigenh "+mccpoamb +mccpocmed 

tcWhere2 = " WHERE MEF_codmed = " + alltrim(transform(vr_codmed))+ " and MEF_diasem = " + alltrim(transform(vr_diasem))+ ;
	" AND MEF_fecvigend < MEF_fecvigenh "+mccpoamb+mccpocmed 

*!*	if !used('mwkHabmemo')
*!*		do sp_busco_estados with 7,' and tipo = 2 ','mwkHabmemo'&& habilita memo electronico
*!*	endif
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif
if vr_memo = 0
	lcSql = " select * from franjaHoraria " + tcWhere1
else
	lcSql = "SELECT ID , Codmed , Diasem , Estructura , Fechagraba , Fecvigend , Fecvigenh , Horadesde , Horahasta , Tiposervicio "+;
		", hhmmDes , hhmmHas , tipoturno FROM FranjaHoraria "+tcWhere1 +" union all "+;
		" SELECT ID , MEF_codmed as Codmed , MEF_diasem as Diasem , MEF_estructura as Estructura  , MEF_fechagraba as Fechagraba , "+;
		" MEF_fecvigend as Fecvigend  , MEF_fecvigenh as Fecvigenh , MEF_horadesde as Horadesde  , MEF_horahasta as Horahasta , "+;
		" MEF_tipoServicio as Tiposervicio , MEF_hhmmDes as hhmmDes  , MEF_hhmmHas as hhmmHas , MEF_tipoTurno as tipoTurno FROM TabMEFranja "+tcWhere2
endif
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
