*********************************************************************************
* BUSCA PRESTACIONES DE NUTRICION
*********************************************************************************
mret = sqlexec(mcon1,"select TabNutPrest.* " + ;
	" FROM TabNutPrest " + ;
	" where TNP_dieta < 9 " , "mwkprestnut")

*!*	mret = sqlexec(mcon1,"select PRE_descriprest, PRE_codprest,TabNutPrest.* " + ;
*!*		" FROM prestacions "+;
*!*		" left join TabNutPrest on PRE_codprest = TNP_codPrest " + ;
*!*		" where TNP_dieta < 9 and PRE_codservicio=9400  and PRE_fechapasiva is null " +;
*!*		" order by PRE_descriprest " , "mwkprestSC")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
endif