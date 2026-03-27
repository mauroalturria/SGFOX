*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            *
*********************************************************************************
Lparameters mctexto,mbusco,lbusco, tcAfterWhere,lescx  && 1-desc 2-codigo

If Vartype(mbusco)#"C"
	mbusco = ''
Endif
If Vartype(lbusco)#"N"
	lbusco  = 1
Endif
If Used("mwkbustexto")
	Use In mwkbustexto
Endif
If Vartype(tcAfterWhere )#"C"
	tcAfterWhere = ''
Endif
If Vartype(lescx)#"N"
	lescx  = 0
Endif

If "LIKE" $ Upper(mctexto)
	mctexto = mctexto
Else
	If lbusco = 1
		mctexto = " and UPPER(pre_descriprest) LIKE '%&mctexto%' "
	Else
		mctexto = " and pre_codprest = " + mctexto
	Endif
Endif
If mxambito > 1
	mccpoambp = ",Tabprestambito.PA_duracion, Tabprestambito.PA_fecpasiva,"+;
		" Tabprestambito.PA_retiroestudios, Tabprestambito.PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta , PRE_Lateralidad ,PRE_tipozona  '+;
		"FROM prestacions  " + ;
		" left outer join TabPRESTambito ON ( Tabprestambito.PA_codambito = ?mxambito "+;
		" and Prestacions.PRE_codprest = Tabprestambito.PA_codiprest) "
Else
	mccpoambp = ",pre_duracion as PA_duracion, pre_fechapasiva as PA_fecpasiva,"+;
		" pre_retiroestudios as PA_retiroestudios, pre_turnosmultip as PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta , PRE_Lateralidad ,PRE_tipozona  '+;
		"FROM prestacions "
Endif
If mwkexe.nomexe = "PISOS" And lescx = 0
	mjoin = "inner join servicios on prestacions.pre_codservicio = servicios.ser_codserv  "  + ;
		"inner join SERVCARGVAL on SERVCARGVAL.SCV_codservicio = servicios.ser_codserv  "
Else
	mjoin = "left join servicios on prestacions.pre_codservicio = servicios.ser_codserv  "
Endif

mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios,pre_TipoMuestra,ser_codserv "+;
	" ,cast('' as char(5)) as xper, PRE_cargasincontro,cast(0 as integer) as xcrit " + ;
	mccpoambp +;
	mjoin + tcAfterWhere + " " + ;
	"where pre_automatica <> 'S' and pre_fechapasiva is null " + mctexto + " "  + mbusco +;
	"group by pre_codprest " + ;
	"ORDER BY pre_codprest", "mwkbustexto")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do prg_cancelo
Endif


*						" " + ;
