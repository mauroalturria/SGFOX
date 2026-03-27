*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada *
* por descripción para listar combos    PRE_AgendaTurnos = "S"-> agenda                                       *
*********************************************************************************
lparameters mbusco,ltodas
if vartype(ltodas)#"N"
	ltodas = 0
endif
if vartype(mbusco)#"C"
	mbusco = ''
endif

if ltodas = 1
	mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest, pre_codservicio,ser_descripserv"+;
		",ser_codserv,scv_mnemonico, PRE_retiroestudios, Pre_Especialidad   " + ;
		",pre_EdadDesde,pre_EdadHasta,pre_AgendaTurnos,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona "+;   
		" from prestacions,servicios, servcargval "+;
		" where pre_codservicio = ser_codserv  and ser_codserv = servcargval.scv_codservicio " + ;
		" and scv_mnemonico is not null "+;
		" and (pre_automatica ='N' or pre_automatica is null )  " + mbusco +;
		" group by pre_codprest order by pre_descriprest " + ;
		"", "mwkprestac")
ELSE
	mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest, pre_codservicio,ser_descripserv"+;
		",ser_codserv,scv_mnemonico,PRE_retiroestudios, Pre_Especialidad " + ;
		",pre_EdadDesde,pre_EdadHasta,pre_AgendaTurnos,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona "+;  
		" from prestacions,servicios, servcargval  "+;
		" where pre_codservicio = ser_codserv  and ser_codserv = servcargval.scv_codservicio " + ;
		" and scv_mnemonico is not null and ser_fechapasiva is null "+;
		" and pre_fechapasiva is null " +;
		" and (pre_automatica ='N' or pre_automatica is null )  " + mbusco +;
		" group by pre_codprest order by pre_descriprest  " + ;
		"", "mwkprestac")

endif
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do log_errores with error(), message(), mbusco, program(), lineno()
endif
&&ORDER BY pre_descriprest

