parameters tnid,mTRRsexo,mTRRedad,mTRRfuma, mTRRpresion,mTRRdiabetes, mTRRcolesterol, mTRRriesgo,mTRRcodmed,mTRRregistracio

mfechora = sp_busco_fecha_serv("DT")
if tnid = 0
	lcSql = "Insert into TabRegRCV (TRR_codambito,TRR_codmed,TRR_registracio,TRR_diabetes, TRR_edad,TRR_fuma, TRR_presion"+;
		",TRR_colesterol, TRR_riesgo,TRR_sexo,TRR_fechah )"+;
		" values (?mxambito ,?mTRRcodmed, ?mTRRregistracio, ?mTRRdiabetes, ?mTRRedad, ?mTRRfuma, ?mTRRpresion"+;
		", ?mTRRcolesterol, ?mTRRriesgo, ?mTRRsexo,?mfechora  )"
else
	lcSql = "update TabRegRCV set TRR_diabetes = ?mTRRdiabetes, TRR_edad = ?mTRRedad,TRR_fuma = ?mTRRfuma, TRR_presion = ?mTRRpresion"+;
		",TRR_colesterol = ?mTRRcolesterol, TRR_riesgo = ?mTRRriesgo,TRR_sexo = ?mTRRsexo,TRR_fechah= ?mfechora "+;
		"where id = ?tnid"
endif
tcCursor = ''
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
