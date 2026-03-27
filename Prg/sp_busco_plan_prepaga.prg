****
** Busco sp_busco_plan_prepaga
****
lparameters mplan

	mret = sqlexec(mcon1, "select * from planes  where id<1000 and abreviatura = ?mplan ", "mwktabcfg")
	
	if mret < 0
	
		messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
		cancel
	endif	
