*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            *
*********************************************************************************
msec = " and POrigen = "+iif( INLIST(mwkexe.nomexe,'PISOS','PRESUPUESTOS','ADMISION'),'1','2')+" "

mret = sqlexec(mcon1,"select TabPPrest.id,TabPPrest.pvalor,pre_descriprest, codprest,"+;
	" pre_codprest,pdetalle FROM prestacions,TabPPrest " + ;
	" where pre_fechapasiva is null and pre_codprest = codprest "+ msec +;
	" order by pre_descriprest ", "mwkprestpres")

*"ORDER BY pre_descriprest" selo lo saque porque tardaba
if mret < 0
	=aerr(eros)
*	messagebox(eros(3))
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
endif


