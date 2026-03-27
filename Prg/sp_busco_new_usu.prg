****
** busco sectores
****

parameter mcoduser,mcodsec
	mfecpasiva = ctod('01/01/1900')
	mret = sqlexec(mcon1, "select tabusuario.*, " + ;
		"TabSectorUsuario.codgrupo " + ;
		"from tabusuario, TabSectorUsuario  " + ;
		"where tabusuario.id <> ?mcoduser "+;
 		" and TabSectorUsuario.codusuario= tabusuario.id "+;
		" and tabusuario.fecpasiva = ?mfecpasiva   " + ;
		" and TabSectorUsuario.fecpasiva = ?mfecpasiva   " + ;
		" group by nomape order by nomape ", "mwknewusu")
	if mret<1
		=aerr(eros)
		Message("error en cursor")
	endif
	&&		" and TabSectorUsuario.codsector= ?mcodsec" + ;
