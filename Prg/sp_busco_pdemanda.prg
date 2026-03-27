***
*** Generacion de planilla de Demanda
***
parameter mfecdes , midmedico, mcodesp
if midmedico=350

	mf1 = prg_dtoc(mfecdes )
	mf2 = prg_dtoc(mfecdes +1)

	mret = sqlexec(mcon1, "select cast(fechahoraing as date) as VAL_fechasolicitud,REG_nrohclinica, " + ;
		" REG_numdocumento,REG_nombrepac ,PRE_descriprest as VAL_codservvale " + ;
		" from guardia,prestacions,registracio,guardiavale  "+;
		" left outer join prestadores on guardiavale.codmed = prestadores.id " + ;
		" where guardia.nroregistrac = registracio.REG_nroregistrac and  " + ;
		" guardia.protocolo	= guardiavale.protocolo and "+;
		" guardia.codprest = prestacions.PRE_codprest and "+;
		" guardiavale.codserv in ( 8000,2150,5800,6500,9600) and " + ;
		"guardia.fechahoraing >= ?mf1 and " + ;
		"guardia.fechahoraing < ?mf2 " , "mwkconsumos3")

	msql = "select VAL_fechasolicitud, REG_nrohclinica, " + ;
		" REG_numdocumento,REG_nombrepac,VAL_codservvale " + ;
		" from mwkconsumos3 group by REG_nrohclinica order by REG_nombrepac into cursor mwkconsu"
else
	mret = sqlexec(mcon1, "select VAL_fechasolicitud,REG_nrohclinica, " + ;
		" REG_numdocumento,REG_nombrepac ,VAL_codservvale  " + ;
		" from valesasist,pacientes,registracio " + ;
		" where VAL_codsector in('AMB','GUA') and VAL_circuitoorigen = 2 and " + ;
		" pacientes = VAL_codadmision  and "+;
		" PAC_codhci= registracio and "+;
		" VAL_fechasolicitud = ?mfecdes and " + ;
		" VAL_prestador =?midmedico " + ;
		"", "mwkconsumos3")

	msql = "select VAL_fechasolicitud, REG_nrohclinica, " + ;
		" REG_numdocumento,REG_nombrepac,VAL_codservvale " + ;
		" from mwkconsumos3 order by VAL_fechasolicitud desc into cursor mwkconsu"

endif
if mret < 0
	=aerr(eros)
	messagebox(eros(2))
	messagebox(eros(3))
endif

if used ('mwkconsumos1')
	use in mwkconsumos1
endif
if used ('mwkconsumos2')
	use in mwkconsumos2
endif
