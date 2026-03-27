****
** busco sectores
****

parameter msql_sec1, msql_sec2, mabm, mcoduser,nf
if type('nf')#"C"
	nf=''
endif
mfecpas = ctod('01/01/1900')

if mabm = 1		&& por alta

	mret = sqlexec(mcon1, "select * from tabsectores order by descrip", "mwksector1" + nf )

	msql_sec1 = 'select descrip, id from mwksector1' + nf +' into cursor mwksec1' + nf

	return msql_sec1

endif

if mabm = 0		&& para ver cuales hay y cuales faltan

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

endif
if mabm = 3 	&& para ver sectores de un usuario

	mret = sqlexec(mcon1, "select tabsectores.id, descrip, preferido,codusuario " + ;
		"from tabsectorusuario, tabsectores " + ;
		"where codusuario = ?mcoduser and " + ;
		"codsector = tabsectores.id " + ;
		" and  tabsectorusuario.fecpasiva = ?mfecpas " + ;
		"order by descrip", "mwksector3"+nf)

endif
