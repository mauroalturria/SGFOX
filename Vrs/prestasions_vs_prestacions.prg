*****
**
*****

*	public mcon1, mcon3
	
	do sp_conexion
	
	mret = sqlexec(mcon1, "select pre_codprest, pre_descriprest, pre_fechapasiva, " + ;
							"pre_codservicio, pre_automatica, pre_especialidad " + ;
							"from prestacions where pre_agendaturnos = 'S'","mwkpre1")
							

	= sqldisconnect(mcon1)
	
	do sp_conexion_tablas
	
	mret = sqlexec(mcon3, "select pre_codprest as tcod, pre_descriprest as tdes, pre_fechapasiva as tfec, " + ;
							"pre_codservicio as tser, pre_automatica as taut, pre_especialidad as tesp " + ;
							"from prestacions ","mwkpre3")
							

	= sqldisconnect(mcon3)
	
	select pre_codprest, pre_descriprest, pre_fechapasiva, pre_codservicio, pre_automatica, ;
		pre_especialidad, tdes, tfec, tser, taut, tesp ;
	from mwkpre1 left outer join mwkpre3 on pre_codprest = tcod ;
	order by pre_codprest ;
	into cursor mwkpre04															