****
** busco sectores
****

parameter msql_sec1, msql_sec2, mabm, mcoduser,nf
if type('nf')#"C"
	nf=''
endif
mcursor = "mwksector1" + nf
if used(mcursor)
	use in &mcursor
endif
mcursor = "mwksector2" + nf
if used(mcursor)
	use in &mcursor
endif

mcursor = "mwksector3" + nf
if used(mcursor)
	use in &mcursor
endif

mcursor = "mwksec1" + nf
if used(mcursor)
	use in &mcursor
endif

mcursor = "mwksec2" + nf
if used(mcursor)
	use in &mcursor
endif


mfecpas = ctod('01/01/1900')

do case
	case mabm = 0		&& para ver cuales hay y cuales faltan

		mret = sqlexec(mcon1, "select * from tabsectores " + ;
			"where tabsectores.id not in(select codsector " + ;
			"from tabsectorusuario where codusuario = ?mcoduser " + ;
			" and  tabsectorusuario.fecpasiva = ?mfecpas) " + ;
			"order by descrip", "mwksector1" + nf )

		mret = sqlexec(mcon1, "select tabsectores.id, descrip, preferido,codusuario " + ;
			"from tabsectorusuario, tabsectores " + ;
			"where codusuario = ?mcoduser and " + ;
			"codsector = tabsectores.id " + ;
			" and  tabsectorusuario.fecpasiva = ?mfecpas " + ;
			"order by descrip", "mwksector2" + nf )

		msql_sec1 = 'select descrip, id from mwksector1' + nf +' into cursor mwksec1' + nf
		msql_sec2 = 'select descrip, id, preferido from mwksector2' + nf +' into cursor mwksec2' + nf

		select descrip, id from ('mwksector1' + nf ) into cursor ('mwksec1' + nf )
		select descrip, id, preferido from ('mwksector2' + nf ) into cursor ('mwksec2' + nf )
		select descrip, id, preferido from ('mwksector2' + nf ) into cursor ('mwkseccbo2' + nf )


	case mabm = 1		&& por alta

		mret = sqlexec(mcon1, "select * from tabsectores order by descrip", "mwksector1" + nf )

		msql_sec1 = 'select descrip, id from mwksector1' + nf +' into cursor mwksec1' + nf

		return msql_sec1

	case mabm = 2 	&& para ver sectores de los usuario

		mret = sqlexec(mcon1, "select tabsectores.id,codsector as codsec, descrip, preferido,codusuario " + ;
			"from tabsectorusuario, tabsectores " + ;
			"where codsector = tabsectores.id " + ;
			" and  tabsectorusuario.fecpasiva = ?mfecpas " + ;
			"order by descrip", "mwksectorusu")

	case mabm = 3 	&& para ver sectores de un usuario

		mret = sqlexec(mcon1, "select tabsectores.id, descrip, preferido,codusuario " + ;
			"from tabsectorusuario, tabsectores " + ;
			"where codusuario = ?mcoduser and " + ;
			"codsector = tabsectores.id " + ;
			" and  tabsectorusuario.fecpasiva = ?mfecpas " + ;
			"order by descrip", "mwksector3"+nf)

endcase
