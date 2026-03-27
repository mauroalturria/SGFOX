****
** busco Planes por entidad
****

parameter mbusca
if type('mbusca')#"C"
	if inlist(mncodent ,100,101,102)
		mbusca = 'where CodEntAg = 100 '
	else
		mbusca = " where id = 0 "    &&ID = ?mbusca "
	endif
endif
if used ("mwkTplan")
	use in mwkTplan
endif
mfecpas = ctod("01/01/1900")
mret = sqlexec(mcon1,"select * "+;
	" from Planes " + mbusca + " and FecPasivaPlan = ?mfecpas "+;
	" order by descripcion"  , "mwkTplan")
if mret<1
	=aerr(eros)
*	messagebox(eros(3))
endif

