Parameters  tbAnd,lconfranja
*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada   *
* por descripción para listar combos  de turnos                                 *
*********************************************************************************
If Used("mwkbustexto")
	Use In mwkbustexto
Endif
If Vartype(lconfranja)<>"N"
	lconfranja = 0
Endif
mconfranja = ''
If lconfranja = 1
	mconfranja = " and pre_codprest in (SELECT codprest FROM medpresta " + ;
		" WHERE &mccpoamb  fecvigend <> fecvigenh and fecvigenh >= {fn curdate()} )"
Endif

If mxambito >1
	mccpoambp = ",Tabprestambito.PA_duracion, Tabprestambito.PA_fecpasiva,"+;
		" Tabprestambito.PA_retiroestudios, Tabprestambito.PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		"FROM prestacions, servicios " + ;
		" left outer join TabPRESTambito ON ( Tabprestambito.PA_codambito = ?mxambito "+;
		" and Prestacions.PRE_codprest = Tabprestambito.PA_codiprest) "
Else
	mccpoambp = ",pre_duracion as PA_duracion, pre_fechapasiva as PA_fecpasiva,"+;
		" pre_retiroestudios as PA_retiroestudios, pre_turnosmultip as PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		"FROM prestacions, servicios "
Endif

If Not tbAnd
	mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
		"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona   " + ;
		mccpoambp  + ;
		"where pre_fechapasiva is null and " + ;
		"pre_agendaturnos = 'S' and " + ;
		"pre_codservicio = ser_codserv "+ mctexto +mconfranja + ;
		" group by pre_codprest " + ;
		"ORDER BY pre_codprest", "mwkbustexto")

*!*			and " + ;
*!*			"pre_descriprest LIKE '%&mctexto%' " + ;

Else
	mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
		"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona   " + ;
		mccpoambp  + ;
		"where pre_fechapasiva is null and " + ;
		"pre_agendaturnos = 'S' and " + ;
		"pre_codservicio = ser_codserv " + mctexto +mconfranja + ;
		"group by pre_codprest " + ;
		"ORDER BY pre_codprest", "mwkbustexto")

Endif

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

