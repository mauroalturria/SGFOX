
******************************************************************
* Trae en funcion de un codigo de médicos  y diasem su duracion  *
* los horarios de esa prestacion,sala,y demás datos              *
******************************************************************

parameters vr_codmed, vr_dia, vr_horad, vr_horah, vr_fec_vd, vr_fec_vh,tcCursor,vr_memo

if vartype(tcCursor) # "C"
	tcCursor= 'MwkDatosMed'
endif
if vartype(vr_memo) # "N"
	vr_memo = 0
endif
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif
*!*	if !used('mwkHabmemo')
*!*		do sp_busco_estados with 7,' and tipo = 2 ','mwkHabmemo'&& habilita memo electronico
*!*	endif
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif
if vr_memo = 0
	lcSql = "SELECT codmed, diasem, horadesde, horahasta, fecvigend, fecvigenh, "+;
	" sala, duracion, demanda,generaagen, fechaultagenda, "+;
	" hdesde1, hhasta1, fhgraba,reservados  "+;
	" from medpresta where codmed=?vr_codmed "+;
	" &mccpoamb and diasem = ?vr_dia   "+;
	" and horadesde = ?vr_horad and horahasta =?vr_horah " +;
	" and fecvigend >=?vr_fec_vd and fecvigenh <=?vr_fec_vh "+;
	" and fecvigend <> fecvigenh "+;
	" group by codmed, diasem, horadesde, horahasta, fecvigend, fecvigenh " +;
	" order by horadesde, horahasta, fecvigend, fecvigenh "
else
	lcSql = "SELECT MEF_codmed as codmed, MEF_diasem a diasem, MEF_horadesde as horadesde, "+;
	"MEF_horahasta as horahasta, MEF_fecvigend as fecvigend, MEF_fecvigenh as fecvigenh, "+;
	" MEF_sala, MEF_duracion, MEF_demanda,MEF_generaagen, MEF_fechaultagenda, "+;
	" MEF_hdesde1, MEF_hhasta1, MEF_fhgraba,MEF_reservados  "+;
	" from TabMEFranja where MEF_codmed=?vr_codmed "+;
	" &mccpoamb and MEF_diasem = ?vr_dia   "+;
	" and MEF_horadesde = ?vr_horad and MEF_horahasta =?vr_horah " +;
	" and MEF_fecvigend >=?vr_fec_vd and MEF_fecvigenh <=?vr_fec_vh "+;
	" and MEF_fecvigend <> MEF_fecvigenh "+;
	" group by codmed, diasem, horadesde, horahasta, fecvigend, fecvigenh " +;
	" order by horadesde, horahasta, fecvigend, fecvigenh "
endif
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
