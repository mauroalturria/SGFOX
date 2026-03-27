****
** Actualizo nro de registracio en ambulatorio por pasaje de consumos
***

parameter nroregistra, newregistra, mpasavale

mret = prg_ejecutosql1("select id, protocolo from tabambulatorio " + ;
	"where nroregistrac = ?nroregistra" + ;
	" and nrovale= ?mpasavale ","mwknewreg" )

mret = prg_ejecutosql1("update tabambulatorio set nroregistrac = ?newregistra " + ;
	"where nroregistrac = ?nroregistra and  nrovale=?mpasavale ")
select mwknewreg
scan
	miprot = protocolo
	mret = prg_ejecutosql1("update Tabambevol set EA_nroregistrac = ?newregistra " + ;
		"where EA_nroregistrac = ?nroregistra and EA_protocolo = ?miprot ")
	mret = prg_ejecutosql1("update Tabautprevias set APV_Registracio = ?newregistra " + ;
		"where APV_Protocolo = ?miprot ")
endscan
**** idem para historico
mret = prg_ejecutosql1("select id, protocolo from tabambulatoriohis " + ;
	"where nroregistrac = ?nroregistra" + ;
	" and nrovale= ?mpasavale ","mwknewreg" )

mret = prg_ejecutosql1("update tabambulatoriohis set nroregistrac = ?newregistra " + ;
	"where nroregistrac = ?nroregistra and  nrovale=?mpasavale ")
select mwknewreg
scan
	miprot = protocolo
	mret = prg_ejecutosql1("update Tabambevolhis set EA_nroregistrac = ?newregistra " + ;
		"where EA_nroregistrac = ?nroregistra and EA_protocolo = ?miprot ")
	mret = prg_ejecutosql1("update Tabautprevias set APV_Registracio = ?newregistra " + ;
		"where APV_Protocolo = ?miprot ")
endscan
