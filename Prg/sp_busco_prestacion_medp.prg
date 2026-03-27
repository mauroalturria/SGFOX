*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            *
*********************************************************************************
Lparameters mbusco,qbusco,micodesp
If Type('mbusco')#"C"
	mbusco= ''
endif
If Type('micodesp')#"C"
	mbusesp = ''
Else
	mbusesp = "medpresta.codesp = ?micodesp and "
Endif

If Type('qbusco')#"N"
	qbusco = 1
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
Endif
mfecturno = sp_busco_fecha_serv("DD")
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
		"from medpresta, prestacions,prestadores " + ;
		" left outer join TabPRESTambito ON ( Tabprestambito.PA_codambito = ?mxambito "+;
		" and Prestacions.PRE_codprest = Tabprestambito.PA_codiprest) "

Else
	mccpoambp = ",pre_duracion as PA_duracion, pre_fechapasiva as PA_fecpasiva,"+;
		" pre_retiroestudios as PA_retiroestudios, pre_turnosmultip as PA_turnosmultip "+;
		"from medpresta, prestacions,prestadores "
Endif

mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, Pre_retiroestudios,PRE_TipoMuestra,nombre " + ;
	mccpoambp  + ;
	"where medpresta.codprest = prestacions.pre_codprest and " + ;
	"pre_fechapasiva is null and " + cagen + mbusesp + ;
	"pre_agendaturnos = 'S' and medpresta.codmed = prestadores.id and " + ;
	"medpresta.fecvigenh > ?mfecturno and " + ;
	"medpresta.fecvigenh <> medpresta.fecvigend " + mccpoamb+mbusco+;
	"group by pre_descriprest,medpresta.codmed " + ;
	"ORDER BY pre_descriprest,nombre", "mwkpresmed")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
***?mfecturno >= medpresta.fecvigend OR
****		"medpresta.generaagen = 1 and "
