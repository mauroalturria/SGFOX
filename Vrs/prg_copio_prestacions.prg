****
**
****

*	public mcon1, mcon3
	
	do sp_conexion
	
	mret = sqlexec(mcon1, "select pre_codprest, pre_descriprest, pre_fechapasiva, " + ;
							"pre_codservicio, pre_automatica, pre_especialidad, " + ;
							"pre_agendaturnos, pre_duracion, pre_retiroestudios, " + ;
							"pre_turnosmultip " + ;
							"from prestacions where pre_agendaturnos = 'S'","mwk1")
							

	= sqldisconnect(mcon1)
	
	do sp_conexion_tablas
	
	do while !eof('mwk1')
		m_fechapasiva  = mwk1.pre_fechapasiva
		m_codservicio  = mwk1.pre_codservicio
		m_automatica   = ALLT(mwk1.pre_automatica)
		m_especialidad = ALLT(mwk1.pre_especialidad)
		m_agendaturnos = ALLT(mwk1.pre_agendaturnos)
		m_duracion     = mwk1.pre_duracion
		m_turnosmultip = nvl(mwk1.pre_turnosmultip, 0)
		m_codigo	   = mwk1.pre_codprest
			
		mret = sqlexec(mcon3, "update prestacions set " + ;
								"pre_fechapasiva  = ?m_fechapasiva,  " + ;
								"pre_codservicio  = ?m_codservicio,  " + ; 
								"pre_automatica   = ?m_automatica,   " + ;
								"pre_especialidad = ?m_especialidad, " + ;
								"pre_agendaturnos = ?m_agendaturnos, " + ;
								"pre_duracion     = ?m_duracion,     " + ;
								"pre_turnosmultip = ?m_turnosmultip  " + ;
							"where pre_codprest = ?m_codigo")
	
		Skip 1 in mwk1
	enddo

	= sqldisconnect(mcon3)





