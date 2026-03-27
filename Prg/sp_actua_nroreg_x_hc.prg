****
** Actualizo nro de registracio en guardia por pasaje de consumos o unificacion
***

Parameter nroregistra, newregistra, mfecdesp, mfechas,mnrohc,mnewhc


If Type ('mfecdesp') = "C" Or Vartype(mfecdesp) = "T"
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
Else
	mret = prg_ejecutosql1("update guardia set nroregistrac = ?newregistra " + ;
		"where nroregistrac = ?nroregistra")

	mret = prg_ejecutosql1("update Tabguaevol set EG_nroregistrac = ?newregistra " + ;
		"where EG_nroregistrac = ?nroregistra")

	mret = prg_ejecutosql1("update Tabfichatraumatologica set FT_hce = ?mnewhc " + ;
		" where FT_hce = ?mnrohc ")


	lcSQL = "UPDATE TabHTGrupo SET htg_hc = ?mnewhc WHERE htg_hc = ?mnrohc"
	=prg_ejecutosql(lcSQL)

	lcSQL = "UPDATE TabHTAnticuerpos SET hta_hc = ?mnewhc WHERE hta_hc = ?mnrohc"
	=prg_ejecutosql(lcSQL)

	lcSQL = "UPDATE TabHTCoombsDirecta SET htc_hc = ?mnewhc WHERE htc_hc = ?mnrohc"
	=prg_ejecutosql(lcSQL)


	lcSQL = "UPDATE TabHTTransfusiones SET htt_hc = ?mnewhc WHERE htt_hc = ?mnrohc"
	=prg_ejecutosql(lcSQL)

	mret = prg_ejecutosql1("update ZabDocuPac set ZDP_hclinica = ?mnewhc " + ;
		" where ZDP_hclinica = ?mnrohc ")
	=prg_ejecutosql(lcSQL)
	
	mret = prg_ejecutosql1("update ZabDocuPac2 set ZDP_hclinica = ?mnewhc " + ;
		" where ZDP_hclinica = ?mnrohc ")
	=prg_ejecutosql(lcSQL)

Endif
