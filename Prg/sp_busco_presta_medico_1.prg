****
** busco prestaciones por servicio y nemonico
****

Parameter mcodmed,mfecdiat,lsolofecha
If Vartype(lsolofecha)#"N"
	lsolofecha = 0
Endif
mccentro = Iif(mxambito = 1,Iif(mxcentromedico =1," and (sala not like '%LIMA%' AND sala not like '%CP%' ) ",;
		Iif(mxcentromedico =2, " and sala like '%LIMA%' "," AND sala like '%CP%' "  )),' ')

Use In Select("mwkbustexto")

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
Endif
If mxambito >1
	mccpoambp = ",Tabprestambito.PA_duracion, Tabprestambito.PA_fecpasiva,"+;
		" Tabprestambito.PA_retiroestudios, Tabprestambito.PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		" FROM prestacions, servicios, medpresta " + ;
		" left outer join TabPRESTambito ON ( Tabprestambito.PA_codambito = ?mxambito "+;
		" and Prestacions.PRE_codprest = Tabprestambito.PA_codiprest) "

Else
	mccpoambp = ",pre_duracion as PA_duracion, pre_fechapasiva as PA_fecpasiva,"+;
		" pre_retiroestudios as PA_retiroestudios, pre_turnosmultip as PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		"FROM prestacions, servicios, medpresta "
Endif


If Type('mfecdiat') = "D"
	ndiasem = Dow(mfecdiat)
	mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
		"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ,medpresta.usuario   " + ;
		mccpoambp + "where pre_codprest = codprest and " + ;
		' medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
		' ?mfecdiat between medpresta.fecvigend and medpresta.fecvigenh and ' + ;
		' medpresta.diasem = ?ndiasem and '+;
		"pre_codservicio = ser_codserv and " + ;
		"codmed  = ?mcodmed " + ;
		" and PRE_fechapasiva is null  " +mccpoamb +mccentro +;
		"group by pre_codprest " + ;
		"ORDER BY pre_codprest", "mwkbustexto")
Else
	mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
		"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ,medpresta.usuario   " + ;
		mccpoambp + ;
		"where pre_codprest = codprest and " + ;
		' medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
		"pre_codservicio = ser_codserv and " + ;
		"codmed  = ?mcodmed " + ;
		" and PRE_fechapasiva is null  " +mccpoamb+mccentro +;
		"group by pre_codprest " + ;
		"ORDER BY pre_codprest", "mwkbustexto")
Endif
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 48, "Validacion")
	Do prg_cancelo
Endif


