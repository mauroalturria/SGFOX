****
** Busqueda de Protocolo
****
Parameter mbusca,mcual,mbuscog,magrup
If vartype(mcual)#"N"
	mcual = 0
Endif
If vartype(mbuscog)#"C"
	mbuscog = " tabtipoaltas.sector = 1 and Tabtipoaltas.tipoest = 0 and "
Endif
If vartype(magrup)#"C"
	magrup = 'protocolo'
Endif
if mcual = 0 
	mret = SQLExec(mcon1, "select guardia.*,sector,tipoest "+;
		" from guardia,tabtipoaltas,GuardiaPrestacion  "+;
		" where Guardiaprestacion.codprest = Guardia.codprest and " + ;
		" guardia.codestado = tabtipoaltas.id and GuardiaPrestacion.codserv = 8000 and "+;
		  mbuscog + mbusca , "mwkguardia01")
else
	mret = SQLExec(mcon1, "select guardia.*,tabtipoaltas.*,REG_nrohclinica,REG_nombrepac "+;
		" from guardia,tabtipoaltas,GuardiaPrestacion,registracio  "+;
		" where Guardiaprestacion.codprest = Guardia.codprest and " + ;
		" guardia.codestado = tabtipoaltas.id and GuardiaPrestacion.codserv = 8000 and "+;
		" guardia.nroregistrac = registracio.REG_nroregistrac and "+;
		  mbuscog + mbusca , "mwkguardia01")
endif	
If mret<1
	=aerr(eros)
	Messagebox(eros(3))
Endif
Select * from mwkguardia01 ;
	group by &magrup;
	order by fechahoraing desc  into cursor mwkguardia
