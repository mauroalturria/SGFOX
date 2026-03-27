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
	mret = SQLExec(mcon1, "select Tabambulatorio.*,sector,tipoest "+;
		" from Tabambulatorio,tabtipoaltas,Prestacions"+;
		" where Tabambulatorio.codprest = Prestacions.PRE_codprest and " + ;
		" Tabambulatorio.codestado = tabtipoaltas.id and "+;  &&and Prestacions.PRE_codservicio = 2200 
		  mbuscog + mbusca , "mwkambula01")
else
	mret = SQLExec(mcon1, "select Tabambulatorio.*,sector,tipoest,REG_nrohclinica,REG_nombrepac  "+;
		" from Tabambulatorio,tabtipoaltas,Prestacions,registracio"+;
		" where Tabambulatorio.codprest = Prestacions.PRE_codprest and " + ;
		" Tabambulatorio.codestado = tabtipoaltas.id and "+;  
		" Tabambulatorio.nroregistrac = registracio.REG_nroregistrac and "+;  &&and Prestacions.PRE_codservicio = 2200 
		  mbuscog + mbusca , "mwkambula01")
endif	
If mret<1
	=aerr(eros)
	Messagebox(eros(3))
Endif
Select * from mwkambula01;
	group by &magrup;
	order by fechahoraing desc  into cursor mwkambula
