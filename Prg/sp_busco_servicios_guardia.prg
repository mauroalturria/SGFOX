****
** busco las especialidades de guardia
****

	mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv from servicios, servcargval " + ;
					"where ser_guardia = 'S' and ser_codserv = servcargval.scv_codservicio " + ;
					"and scv_mnemonico is not null order by ser_descripserv", "mwkserv")
					
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 48, "Validacion")
		cancel
	endif					
					