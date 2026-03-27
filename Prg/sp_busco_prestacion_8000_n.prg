****
** busco prestaciones por servicio 8000
****

parameter mcodserv
if type ('mcodserv')#"N"
	mbusserv = '(8000,5800)'
else
	mbusserv = "("+trans(mcodserv) + ")"	
endif
	
 	mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
						"pre_especialidad, pre_duracion, ser_descripserv " + ;
						"FROM prestacions, servicios " + ;
						"where pre_codservicio = ser_codserv and " + ;
						"pre_codservicio in "+mbusserv +" and pre_fechapasiva is null " + ;
						"group by pre_codprest " + ;
						"ORDER BY pre_codprest", "mwkbustexto")
						
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 48, "Validacion")
		cancel
	endif					
