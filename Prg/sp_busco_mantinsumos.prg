************
*Busco insumos para presupuestos,grupo C
************
lparameters mctexto

mret =	sqlexec(mcon1,"SELECT ins_descriinsumo,ins_codinsumo,ins_codPuntero,insumos,Ins_grupo "+;
" FROM insumos where ins_grupo in ('C') AND ins_descriinsumo LIKE '%&mctexto%'"+;
" and ins_fechapasivo is null " ,"mwkinsumo")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
