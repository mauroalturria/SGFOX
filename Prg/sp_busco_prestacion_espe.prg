****
** Busqueda de Prestaciones a partir de una especialidad
****

Parameter mcodespe, mbusca

If Vartype(mbusca)#"C"
	mbusca = ''
Endif
If Vartype(mfecturno)#"D" And Vartype(mfecturno)#"T"
	mfecturno = mwkfecserv.fechahora
Endif
If Used("mwkbustexto")
	Use In mwkbustexto
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
Endif
If mxambito >1
	mccpoambp = ",Tabprestambito.PA_duracion, Tabprestambito.PA_fecpasiva,"+;
		" Tabprestambito.PA_retiroestudios, Tabprestambito.PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		" from medpresta, prestacions " + ;
		" left outer join TabPRESTambito ON ( Tabprestambito.PA_codambito = ?mxambito "+;
		" and Prestacions.PRE_codprest = Tabprestambito.PA_codiprest) "
Else
	mccpoambp = ",pre_duracion as PA_duracion, pre_fechapasiva as PA_fecpasiva,"+;
		" pre_retiroestudios as PA_retiroestudios, pre_turnosmultip as PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		" from medpresta, prestacions "
Endif


If Not "," $ mcodespe

	mret=SQLExec(mcon1,"select pre_descriprest, pre_codprest, " + ;
		"pre_codservicio, pre_especialidad, pre_duracion,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona   " + ;
		mccpoambp + ;
		"where medpresta.codprest = prestacions.pre_codprest and " + ;
		' medpresta.fecvigend <> medpresta.fecvigenh and PRE_fechapasiva is null and ' + ;
		"medpresta.codesp = ?mcodespe and medpresta.fecvigenh >= ?mfecturno and " + ;
		"medpresta.generaagen =  1 " + mbusca + " " + mccpoamb+;
		"group by pre_descriprest order by pre_descriprest" , "mwkbustexto")
Else

	mret=SQLExec(mcon1,"select pre_descriprest, pre_codprest, " + ;
		"pre_codservicio, pre_especialidad, pre_duracion,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona   " + ;
		mccpoambp+ ;
		"where medpresta.codprest = prestacions.pre_codprest and and PRE_fechapasiva is null and " + ;
		' medpresta.fecvigend <> medpresta.fecvigenh and medpresta.fecvigenh >= ?mfecturno and ' + ;
		"medpresta.codesp in ( " + mcodespe + " ) and " + ;
		"medpresta.generaagen =  1 " + mbusca + " " + mccpoamb+;
		"group by pre_descriprest order by pre_descriprest" , "mwkbustexto")

Endif
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0

Endif
