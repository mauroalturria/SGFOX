*******
* Busca insumos para presupuestos
*******
lparameters mWhere

if used('mwkPrinsumo')
	select mwkPrinsumo
	use
endif

mret =	sqlexec(mcon1,"select TabPinsumo.id,ins_descriinsumo as descr,"+;
	"ins_CodPuntero as codinsumo,pvalor FROM insumos,TabPinsumo "+;
	" where  ins_fechapasivo is null and ins_CodPuntero  = codInsumo "+;
	"order by ins_descriinsumo ","mwkPrinsumo")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
