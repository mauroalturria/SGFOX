****
** busca turnos dados paa una entidad y una prestacion
****

	do sp_conexion

	mfecdes = ctod('01/03/2004')
	mfechas = ctod('31/03/2004')
	
	mret = sqlexec(mcon1, "select horatur as fecha, nombre as profesional, " 	 + ;
							"reg_nombrepac as paciente, pre_descriprest as prestacion, " + ;
							"codreserva, turnos.usuario, fechatomado, reg_telefonos, reg_numdocumento " + ;
							"from turnos, prestadores, registracio, prestacions " + ;
							"where turnos.afiliado = reg_nroregistrac and " + ;
								"turnos.codmed = prestadores.id and " + ;
								"turnos.codprest = pre_codprest and " + ;
								"turnos.codent in (965, 971) and " + ;
								"turnos.codesp in('OFTA', 'OFTI') and " +  ;
								"turnos.fechatur >= ?mfecdes and " + ;
								"turnos.fechatur <= ?mfechas and " + ;
								"turnos.tipoturno < 9 " + ;
							"order by  fecha", "mwktodos")

	if mret < 0 
		messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS', 16,'Validacion')
		=sqldisconnect(mcon1)
		cancel
	endif
	
	=sqldisconnect(mcon1)