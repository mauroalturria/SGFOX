************************
************************
* Bsuco entidades con coseguro para un tipopac
************************
lparameters tpac
if vartype(tpac)#"C"
	tpac = "AMB"
endif
if used('mwkfecserv')
	mfechah = ttod(mwkfecserv.fechahora)
else
	mfechah = date()
endif
mret =sqlexec(mcon1,"SELECT ENT_descrient, ENT_codent FROM entidades,coseguros  "+;
	" WHERE ENT_codent = entidad and fechahasta>= ?mfechah and tipopac = ?tpac "+;
	" GROUP BY ENT_codent order by ENT_descrient ","MWKEnti")

if mret<0

	=aerr(eros)
	messagebox(eros(3))
endif
