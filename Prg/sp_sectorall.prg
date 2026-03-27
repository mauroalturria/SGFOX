****
**  Busco sectores internacion
****

	mret = sqlexec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala from sectores " + ;
							"order by sec_descripsec", "mwksectorint")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	CANCEL
endif	