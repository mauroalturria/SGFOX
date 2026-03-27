*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada   *
* por descripción agrega tipo de atencion de coseguros                          *
*********************************************************************************
Lparameters mbusco,menti
If Vartype(mbusco)#"C"
	mbusco = ''
Endif
If Used("mwkbustexto")
	Use In mwkbustexto
Endif
If Vartype(menti)#"N"
	magrupa = 	"group by pre_codprest, "

Else
	magrupa = ''

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

mret = SQLExec(mcon1,"select pre_descriprest, Cosegurostipoatencion.Descripcion,pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona  ,coseprac.entidad " + ;
	mccpoambp + ;
	" left join coseprac on pre_codprest = Coseprac.Prestacion "+;
	" left join CosegurosTipoAtencion on Cosegurostipoatencion.TipoAten = Coseprac.TipoAtenAmb "+;
	"where pre_fechapasiva is null and " + ;
	"pre_codservicio = ser_codserv and " + ;
	"pre_automatica <> 'S' and " + ;
	"pre_agendaturnos = 'S' and " + ;
	"ser_codserv = scv_codservicio and " + ;
	"scv_mnemonico is not null and " + mbusco +;
	"ser_fechapasiva is null and " + ;
	"pre_descriprest LIKE '%&mctexto%' " + magrupa +;
	"ORDER BY pre_descriprest,entidad", "mwkbustexto")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do prg_cancelo
Endif


*						"pre_automatica <> 'S' and " + ;

