****
** busco los exe
****

parameter nf,msql_lst1, msql_lst2, mcoduser, mcodsec, mcodgru,lcopia

if type('lcopia') # "N"
	lcopia= 0
endif

mfecpas = ctod('01/01/1900')
if lcopia = 0

	mret = sqlexec(mcon1, "select * from tabfrm " + ;
		"where tabfrm.id not in(select codfrm " + ;
		"from tabpermisosfrm where codusuario = ?mcoduser and " + ;
		"codsector = ?mcodsec and codgrupo = ?mcodgru and " + ;
		"fecpasiva = ?mfecpas) and fecpasiva = ?mfecpas order by puntomenu", "mwkfrm33"+nf)

	mret = sqlexec(mcon1, "select tabfrm.id, puntomenu " + ;
		"from tabpermisosfrm, tabfrm " + ;
		"where codusuario  = ?mcoduser and codgrupo = ?mcodgru and " + ;
		"codsector = ?mcodsec and codfrm = tabfrm.id and " + ;
		"tabpermisosfrm.fecpasiva = ?mfecpas " + ;
		" and tabfrm.fecpasiva = ?mfecpas " + ;
		"order by puntomenu", "mwkfrm44"+nf)

	mret = sqlexec(mcon1, "select codgrupo,tabgrupos.*" + ;
		"from tabpermisosfrm, tabgrupos " + ;
		"where codusuario  = ?mcoduser and codgrupo <> ?mcodgru and " + ;
		"codsector = ?mcodsec and codgrupo = tabgrupos.id and " + ;
		"tabpermisosfrm.fecpasiva = ?mfecpas " + ;
		"group by codgrupo", "mwkfrmotros"+nf)


	msql_lst1 = 'select puntomenu, id from mwkfrm33'+nf+' into cursor mwkfrm3'+nf

	msql_lst2 = 'select puntomenu, id from mwkfrm44'+nf+' into cursor mwkfrm4'+nf
else

	mret = sqlexec(mcon1, "select tabpermisosfrm.*, puntomenu " + ;
		"from tabpermisosfrm, tabfrm " + ;
		"where codusuario  = ?mcoduser and codgrupo = ?mcodgru and " + ;
		"codsector = ?mcodsec and codfrm = tabfrm.id and " + ;
		"tabpermisosfrm.fecpasiva = ?mfecpas " + ;
		" and tabfrm.fecpasiva = ?mfecpas " + ;
		"order by puntomenu", "mwkcmdx"+nf)

endif
