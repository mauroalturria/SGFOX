****
** Actualizo nro de registracio en guardia por pasaje de consumos o unificacion
***

Parameter nroregistra, newregistra, mfecdesp, mfechas,mnrohc,mnewhc,mxvale

SET STEP ON
	mret = prg_ejecutosql1("select protocolo from guardia " + ;
		"where nroregistrac = ?nroregistra" + ;
		" and fechahoraate>=?mfecdesp "+;
		" and fechahoraate<?mfechas ","mwknewreg")
	mret = prg_ejecutosql1( "update guardia set nroregistrac = ?newregistra " + ;
		"where nroregistrac = ?nroregistra" + ;
		" and fechahoraate>=?mfecdesp "+;
		" and fechahoraate<?mfechas ")
	Select mwknewreg
	Scan
		miprot = protocolo
		mret = prg_ejecutosql1("update Tabguaevol set EG_nroregistrac = ?newregistra " + ;
			"where EG_nroregistrac = ?nroregistra and EG_protocolo = ?miprot ")
		mret = prg_ejecutosql1( "update Tabfichatraumatologica set FT_hce = ?mnewhc " + ;
			" where FT_hce = ?mnrohc and FT_protocolo = ?miprot ")
	Endscan
