************************
************************
* Bsuco entidades con coseguro para un tipopac
************************
lparameters tpac
if vartype(tpac)#"C"
	tpac = "AMB"
endif

mret = sqlexec(mcon1, "select entidad from coseguros  " + ;
	"where fechahasta>={fn curdate()} and tipopac = ?tpac "+;
	" group by entidad " , "mwkentcose")
if mret<0
	=aerr(eros)
	messagebox(eros(3))
endif
