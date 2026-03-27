*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
* MODIFICADO:09/05/2002
*************************************************
* Cursor de Impresion del listado de Medpresta
*************************************************

mhoy=sp_busco_fecha_serv('DD')
mfecnul = Ctod("01/01/1900")
mccpoamb = ''
If mxambito >1
	mccpoamb = "  and C.codambito = ?mxambito "
Endif
If mxambito >1
	mccpoambp = ",Tabprestambito.PA_duracion, Tabprestambito.PA_fecpasiva,"+;
		" Tabprestambito.PA_retiroestudios, Tabprestambito.PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta,c.sala '+;
		'FROM Prestadores AS A,Prestacions AS B, Medpresta AS C, Servicios AS D, '+;
		'Especialid AS E, TabProfesion AS F ' +;
		" left outer join TabPRESTambito ON ( Tabprestambito.PA_codambito = ?mxambito "+;
		" and B.PRE_codprest = Tabprestambito.PA_codiprest) "

Else
	mccpoambp = ",pre_duracion as PA_duracion, pre_fechapasiva as PA_fecpasiva,"+;
		" pre_retiroestudios as PA_retiroestudios, pre_turnosmultip as PA_turnosmultip "+;
		',PRE_EdadDesde, PRE_EdadHasta,c.sala '+;
		'FROM Prestadores AS A,Prestacions AS B, Medpresta AS C, Servicios AS D, '+;
		'Especialid AS E, TabProfesion AS F '
Endif
mret=SQLExec(mcon1,'SELECT F.Titulo,A.nombre,E.ESP_descripcion as Especialidad, '+;
	'c.codprest,B.pre_descriprest,c.codserv,D.ser_descripserv,B.pre_duracion, ' +;
	'C.diasem,C.horadesde,C.horahasta,C.duracion,C.Sala,C.usuario,C.fhgraba, '+;
	'C.porcentaje,C.cantidad,internado,guardia,C.fecvigend,C.fecvigenh,C.generaagen ,' +;
	'C.Reservados, C.Demanda ' + ;
	mccpoambp +;
	'WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mhoy) and A.Id=C.Codmed '+;
	'AND B.Pre_Codprest=C.Codprest AND D.Ser_Codserv=C.Codserv AND '+;
	'trim(E.ESP_Codesp)=C.Codesp ' +;
	'AND A.codprof=F.id AND NOT c.diasem is Null '+ mbusqlis + mccpoamb +;
	'GROUP BY c.codmed,c.diasem,C.fecvigend,c.fecvigenh, c.horadesde,c.codprest,C.generaagen ' +;
	'ORDER BY A.Nombre,C.Diasem,C.fecvigend,c.fecvigenh,C.Horadesde,'+;
	'E.ESP_descripcion,B.pre_descriprest,C.generaagen ','MwkListaMedPrest')

If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_selecciono_medpresta'
Endif
