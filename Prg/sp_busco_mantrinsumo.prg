lparameters mWhere


	mret =	sqlexec(mcon1,"select ins_descriinsumo as descr,ins_CodPuntero as codinsumo,"+;
	" TabMantinsumo.id FROM insumos,TabMantinsumo "+;
	" where  ins_fechapasivo is null and "+;
	" ins_CodPuntero  = codInsumo order by ins_descriinsumo " ,"mwkPrinsumo")

if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
