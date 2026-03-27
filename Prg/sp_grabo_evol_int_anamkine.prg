*!*	actualiza evolucion AKM
parameters  mIAK_anteced, mIAK_apoyo, mIAK_asisten, mIAK_codmed, mIAK_deambula, mIAK_idevol,;
	mIAK_motivoInter, mIAK_objetivos, mIAK_obsactitud, mIAK_otraeval, mIAK_postura, mIAK_rom, mIAK_tipodeamb, mIAK_tmMID, mIAK_tmMII,;
	mIAK_tmMSD, mIAK_tmMSI
mfechahora = sp_busco_fecha_serv("DT")

lcSql = "Insert into TabIntAnamKine " + ;
	" (IAK_fechaHora,IAK_anteced,IAK_apoyo,IAK_asisten,IAK_codmed,IAK_deambula,IAK_idevol,IAK_motivoInter,IAK_objetivos,"+;
	"IAK_obsactitud,IAK_otraeval,IAK_postura,IAK_rom,IAK_tipodeamb,IAK_tmMID,IAK_tmMII,IAK_tmMSD,IAK_tmMSI) " + ;
	" Values " + ;
	" (?mfechahora , ?mIAK_anteced, ?mIAK_apoyo, ?mIAK_asisten, ?mIAK_codmed, ?mIAK_deambula, ?mIAK_idevol,	?mIAK_motivoInter, "+;
	"?mIAK_objetivos, ?mIAK_obsactitud, ?mIAK_otraeval, ?mIAK_postura, ?mIAK_rom, ?mIAK_tipodeamb, ?mIAK_tmMID, ?mIAK_tmMII,"+;
	"?mIAK_tmMSD, ?mIAK_tmMSI) "


if !Prg_EjecutoSql(lcSql,'',.f.)
	return .f.
endif
