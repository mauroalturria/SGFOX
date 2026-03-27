*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            *
*********************************************************************************
Lparameters qbusco,micodesp,mihora

If Type('micodesp')#"C"
	mbusesp = ''
Else
	mbusesp = "medpresta.codesp = ?micodesp and "
Endif
If Type('mihora')#"N"
	mbushora = ''
Else
	mbushora = " medpresta.hhmmdes <= ?mihora and medpresta.hhmmhas > ?mihora and "
Endif
If Type('qbusco')#"N"
	qbusco = 1
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
Endif

cagen = ''
If  qbusco = 1
	cagen = " medpresta.generaagen = 1 and "
Endif
If Used('mwkbustexto')
	Select mwkbustexto
	Use
Endif
If mxambito >1
	mccpoambp = ",Tabprestambito.PA_duracion, Tabprestambito.PA_fecpasiva,"+;
		" Tabprestambito.PA_retiroestudios, Tabprestambito.PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		"from medpresta, prestacions " + ;
		" left outer join TabPRESTambito ON ( Tabprestambito.PA_codambito = ?mxambito "+;
		" and Prestacions.PRE_codprest = Tabprestambito.PA_codiprest) "

Else
	mccpoambp = ",pre_duracion as PA_duracion, pre_fechapasiva as PA_fecpasiva,"+;
		" pre_retiroestudios as PA_retiroestudios, pre_turnosmultip as PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		"from medpresta, prestacions "
Endif

mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona  " + ;
	mccpoambp  + ;
	"where medpresta.codprest = prestacions.pre_codprest and " + ;
	"pre_fechapasiva is null and " + cagen + mbusesp + mbushora +;
	"pre_agendaturnos = 'S' and " + ;
	"medpresta.fecvigenh > ?mfecturno and " + ;
	"medpresta.fecvigenh <> medpresta.fecvigend and " + ;
	"medpresta.codmed = ?mid_medico "+ mccpoamb+;
	"group by pre_descriprest " + ;
	"ORDER BY pre_descriprest", "mwkbustexto")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
***?mfecturno >= medpresta.fecvigend OR
****		"medpresta.generaagen = 1 and "
