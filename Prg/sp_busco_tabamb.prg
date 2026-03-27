****
** busco los permisos de ambito	
****
parameter nf,msql_amb1, msql_amb2, mcual, mcoduser,mtipo

if mcual = 1
	mret = sqlexec(mcon1, "select * from tabambito ", "mwkamb11"+nf)

	msql_amb1 = "select ambito,id " + ;
		"from mwkamb11"+nf+" order by ambito into cursor mwkamb0"+nf

endif

if mcual = 0		&& para ver cuales hay y cuales faltan
	mfecpas = ctod('01/01/1900')
	mret = sqlexec(mcon1, "select * from tabambito " + ;
		"where tabambito.id not in(select codambito " + ;
		"from Tabpermisosambito where codusuario = ?mcoduser and " + ;
		" fecpasiva = ?mfecpas ) " + ;
		"order by ambito", "mwkamb11"+nf)

	mret = sqlexec(mcon1, "select tabambito.id, ambito " + ;
		"from Tabpermisosambito, tabambito " + ;
		"where codusuario  = ?mcoduser and " + ;
		"Tabpermisosambito.fecpasiva = ?mfecpas and " + ;
		"codambito = tabambito.id " + ;
		"order by ambito", "mwkamb22"+nf)

	msql_amb1 = 'select ambito,id from mwkamb11'+nf+'  order by ambito into cursor mwkamb1'+nf
	msql_amb2 = 'select ambito, id from mwkamb22'+nf+'  order by ambito into cursor mwkamb2'+nf

endif


if mcual = 3		&& accesos de un codigovax
	mfecpas = ctod('01/01/1900')
	mret = sqlexec(mcon1, "select tabambito.id, ambito " + ;
		"from Tabpermisosambito, tabambito,tabusuario  " + ;
		"where " + ;
		"Tabpermisosambito.codusuario = tabusuario.id and "+;
		"Tabpermisosambito.fecpasiva = ?mfecpas  and " + ;
		" tabusuario.codigovax = ?mcoduser and " + ;
		"codamb = tabambito.id " + ;
		"order by ambito", "mwkamb22"+nf)

	msql_amb2 = 'select ambito,id from mwkamb22'+nf+'  order by ambito into cursor mwkamb2'+nf

endif
