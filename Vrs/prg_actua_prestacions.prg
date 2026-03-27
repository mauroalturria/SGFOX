****
**
****

	mcon1= SQLCONNECT('Conec01','_system','sys')

	mret = sqlexec(mcon1, 'select pre_codprest, pre_descriprest, pre_fechapasiva, ' + ;
							'pre_codservicio, pre_especialidad, pre_agendaturnos, ' + ;
							'pre_duracion, pre_turnosmultip from prestacions ' + ;
							'where pre_agendaturnos <> null','mwkpresta')
							
							
	=sqldisconnect(mcon1)
	
	mcon1= SQLCONNECT('Conec03','_system','sys')

	mret = sqlexec(mcon1, 'select pre_codprest, pre_descriprest, pre_fechapasiva, ' + ;
							'pre_codservicio, pre_especialidad, pre_agendaturnos, ' + ;
							'pre_duracion, pre_turnosmultip from prestacions ' + ;
							'where pre_agendaturnos <> null','mwkprestab')

	=sqldisconnect(mcon1)