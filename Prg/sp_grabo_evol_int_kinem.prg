*!*	actualiza evolucion AKM
parameters  mKME_asisten,mKME_codmed,mKME_elonga,mKME_estabTron,mKME_evaluacion,;
	mKME_idevol,mKME_movAAs,mKME_movAct,mKME_movPas,mKME_postura,mKME_rom,mKME_sedesta,mKME_tecMovArt,;
	mKME_tecUlcera,mKME_tmMID,mKME_tmMII,mKME_tmMSD,mKME_tmMSI

mfechahora = sp_busco_fecha_serv("DT")

lcSql = "Insert into TabIntAKMevol" + ;
	" (KME_fechaHora,KME_asisten,KME_codmed,KME_elonga,KME_estabTron,KME_evaluacion,KME_idevol,KME_movAAs,KME_movAct,KME_movPas,KME_postura,"+;
	"KME_rom,KME_sedesta,KME_tecMovArt,KME_tecUlcera,KME_tmMID,KME_tmMII,KME_tmMSD,KME_tmMSI) " + ;
	" Values " + ;
	" (?mfechahora , ?mKME_asisten, ?mKME_codmed, ?mKME_elonga, ?mKME_estabTron, ?mKME_evaluacion,"+;
	"?mKME_idevol, ?mKME_movAAs, ?mKME_movAct, ?mKME_movPas, ?mKME_postura, ?mKME_rom, ?mKME_sedesta, ?mKME_tecMovArt,"+;
	"?mKME_tecUlcera, ?mKME_tmMID, ?mKME_tmMII, ?mKME_tmMSD, ?mKME_tmMSI) "


if !Prg_EjecutoSql(lcSql,'',.f.)
	return .f.
endif
