****
** busco prestaciones por servicio y nemonico
****

Parameter mcodprest,mtipopac,mservicio

If Vartype(mtipopac)#"C"
	mtipopac = ''
Endif
If Vartype(mservicio)="N"
	mbusca = ' and pre_codservicio =?mservicio '
Else
	mbusca = ''
Endif

Use In Select("mwkbustexto")

Do Case
	Case  mtipopac = "AMB"
		mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
			"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios  " + ;
			",Tabprestambito.PA_duracion, Tabprestambito.PA_fecpasiva,"+;
			" Tabprestambito.PA_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona , Tabprestambito.PA_turnosmultip,ser_codserv  "+;
			',PRE_EdadDesde, PRE_EdadHasta '+;
			" FROM prestacions, servicios, servcargval " + ;
			" left outer join TabPRESTambito ON ( Tabprestambito.pa_codiprest= pre_codprest and Tabprestambito.PA_codambito = ?mxambito ) "+;
			" where pre_fechapasiva is null and " + ;
			"pre_codservicio = ser_codserv and " + ;
			"pre_automatica <> 'S' and " + ;
			"ser_fechapasiva is null and " + ;
			"pre_agendaturnos = 'S' and " + ;
			"ser_codserv = scv_codservicio and " + ;
			"pre_codprest = ?mcodprest " + mbusca +;
			"group by pre_codprest " + ;
			"ORDER BY pre_codprest", "mwkbustexto")

	Case  mtipopac = "GUA"
		mfecpas = Ctod('01/01/1900')

		mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
			"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios  " + ;
			",pre_duracion as PA_duracion, "+;
			" Pre_retiroestudios as PA_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ,ser_codserv "+;
			',PRE_EdadDesde, PRE_EdadHasta '+;
			" FROM prestacions, servicios, guardiaprestacion " + ;
			"where codprest = pre_codprest and " + ;
			"fechapasiva = ?mfecpas and " + ;
			"pre_fechapasiva is null and " + ;
			"pre_codservicio = ser_codserv and " + ;
			"pre_codprest = ?mcodprest " + ;
			"group by pre_codprest " + ;
			"ORDER BY pre_codprest", "mwkbustexto")

	Otherwise
		mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
			"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona   " + ;
			",pre_duracion as PA_duracion, "+;
			" Pre_retiroestudios as PA_retiroestudios,ser_codserv  "+;
			',PRE_EdadDesde, PRE_EdadHasta '+;
			" FROM prestacions, servicios " + ;
			"where pre_fechapasiva is null and " + ;
			"pre_codservicio = ser_codserv and " + ;
			"pre_codprest = ?mcodprest " + ;
			"group by pre_codprest " +  mbusca +;
			"ORDER BY pre_codprest", "mwkbustexto")
Endcase



