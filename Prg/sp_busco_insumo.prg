************
*Busco insumos 
************
lparameters mctexto,mgrupo,mpasivo
if vartype(mgrupo)#"C"
	mgrupo = " in ('D','O','A','C') "
endif
if vartype(mpasivo)#"N"
	mpasivo = " and ins_fechapasivo is null "
endif
mret =	sqlexec(mcon1,"SELECT ins_descriinsumo,insumos,ins_codPuntero,Ins_grupo,INS_codinsumo "+;
	" FROM insumos where ins_grupo "+ mgrupo +" AND ins_descriinsumo LIKE '%&mctexto%' "+;
	 mpasivo ,"mwkinsumo")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
