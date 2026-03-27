****
** busco grupo del usuario sector
****
		   

parameter nf,msql_gru2, mopcion, mcoduser, mcodsec


mfecpas = ctod('01/01/1900')
if mopcion = 1
				
	mret = sqlexec(mcon1, "select tabgrupos.* " + ;
		"from tabsectorusuario, tabgrupos " + ;
		"where tabsectorusuario.codusuario = ?mcoduser and " + ;
		"tabsectorusuario.codgrupo = tabgrupos.id and " + ;
		"tabsectorusuario.codsector = ?mcodsec and " + ;
		"fecpasiva = ?mfecpas order by tabgrupos.id", "mwkgru33"+nf)

	select DESCRIP, id from ('mwkgru33'+nf) into cursor ('mwkgru3'+nf)
	
endif
