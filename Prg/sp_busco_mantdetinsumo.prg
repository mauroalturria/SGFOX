lparameters midotins 

*********************************************************************************
* Busco los insumos que tiene la orden
*********************************************************************************
IF USED('mwkPrinsumo')
   SELECT mwkPrinsumo
   use
ENDIF 

	mret =	sqlexec(mcon1,"select cantidad,ins_descriinsumo as Insumo,"+;
	" ins_CodInsumo as CodInsumo,ins_CodPuntero,"+;
	" TabMantdetinsumo.id,idotins FROM TabMantdetinsumo ,insumos "+;
	" where  ins_fechapasivo is null and"+;
	" ins_CodPuntero  = codPuntero and idotins = ?midotins "+;
	" order by ins_descriinsumo  ","mwkPrinsumo02")
 
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
