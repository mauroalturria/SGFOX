****
** busco sectores
****

parameter nf,msql_sec1, msql_sec2, mabm, mcoduser

mfecpas = ctod('01/01/1900')

if mabm = 1		&& por alta

	mret = sqlexec(mcon1, "select * from tabsectores order by descrip", "mwkssector1"+nf)

	msql_sec1 = 'select descrip, id from mwkssector1'+nf+' into cursor mwkssec1'+nf

	return msql_sec1

endif

if mabm = 0		&& para ver cuales hay y cuales faltan

	mret = sqlexec(mcon1, "select * from tabsectores " + ;
		"where tabsectores.id not in(select codsector " + ;
		"from tabsectorusuario where codusuario = ?mcoduser) " + ;
		"order by descrip", "mwkssector1"+nf)

	mret = sqlexec(mcon1, "select tabsectores.id, descrip, preferido " + ;
		"from tabsectorusuario, tabsectores " + ;
		"where codusuario = ?mcoduser and " + ;
		"codsector = tabsectores.id " + ;
		" and  tabsectorusuario.fecpasiva = ?mfecpas " + ;
		"order by descrip", "mwkssector2"+nf)

	msql_sec1 = 'select descrip, id from mwkssector1'+nf+' into cursor mwkssec1'+nf
	msql_sec2 = 'select descrip, id, preferido from mwkssector2'+nf+' into cursor mwkssec2'+nf

	select descrip, id from ('mwkssector1'+nf) into cursor ('mwkssec1'+nf)
	select descrip, id, preferido from ('mwkssector2'+nf) into cursor ('mwkssec2'+nf)
	select descrip, id, preferido from ('mwkssector2'+nf) into cursor ('mwksseccbo2'+nf)

endif
if mabm = 3 	&& para ver sectores de un usuario

	mret = sqlexec(mcon1, "select tabsectores.id, descrip, preferido " + ;
		"from tabsectorusuario, tabsectores " + ;
		"where codusuario = ?mcoduser and " + ;
		"codsector = tabsectores.id " + ;
		" and  tabsectorusuario.fecpasiva = ?mfecpas " + ;
		"order by descrip", "mwkssector3"+nf)

endif
