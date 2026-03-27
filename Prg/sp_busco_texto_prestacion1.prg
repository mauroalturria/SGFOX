****
** Pedido de prestaciones Vales Demanda Espontanea
****
Lparameters mespec
If Type('mespec')#"C"
	mespec=''
Endif
If Used("mwkbustexto")
	Use In mwkbustexto
Endif
If mxambito >1
	mccpoambp = ",Tabprestambito.PA_duracion, Tabprestambito.PA_fecpasiva,"+;
		" Tabprestambito.PA_retiroestudios, Tabprestambito.PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		"FROM prestacions, servicios, servcargval " + ;
		" left outer join TabPRESTambito ON ( Tabprestambito.PA_codambito = ?mxambito "+;
		" and Prestacions.PRE_codprest = Tabprestambito.PA_codiprest) "
Else
	mccpoambp = ",pre_duracion as PA_duracion, pre_fechapasiva as PA_fecpasiva,"+;
		" pre_retiroestudios as PA_retiroestudios, pre_turnosmultip as PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		"FROM prestacions, servicios, servcargval "
Endif


mbuscar = Iif(mespec#'', ' pre_especialidad = ?mespec and ' , '')
mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona   " + ;
	mccpoambp +"where pre_fechapasiva is null and " + ;
	"pre_codservicio = ser_codserv and " + ;
	"pre_automatica <> 'S' and " + ;
	"pre_agendaturnos = 'S' and " + ;
	"ser_codserv = scv_codservicio and " + ;
	"scv_mnemonico is not null and " + mbuscar +;
	"ser_fechapasiva is null and " + ;
	"pre_descriprest LIKE '%&mctexto%' " + ;
	"group by pre_codprest " + ;
	"ORDER BY pre_descriprest", "mwkbustexto")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do prg_cancelo
Endif
