****
** Inserto en prestacions
****

	DO SP_CONEXION
	
	mret = sqlexec(mcon1, "insert into prestacions (prestacions, pre_codprest, " + ;
			"pre_descriprest, pre_codservicio, pre_automatica, pre_tipocpto, " + ;
			"pre_nomenclada, pre_cargasincontro, pre_cargayconforme, pre_usomatdescart, " + ;
			"pre_especialidad, pre_agendaturnos, pre_internacion, pre_duracion) " + ;
 			"values(42010170, 42010170, 'CONSULTA EXTENSION DE PSICOPATOLOGIA', " + ;
 			"2200, 'N', 12, 'N', 'N', 'N', 'N', 'PSIC', 'S', 'N', 30)")
 					
 					
 	=SQLDISCONNECT(MCON1)				