*************************
*AUTOR: Claudia Antoniow
*FECHA:25/06/2002
*************************
*Modificado:19/06/2003
*************************
Parameter vr_codmed,lvigen,vr_fecvig


If Vartype(vr_fecvig)<>"D"
	vr_fecvig = sp_busco_fecha_serv('DD')
ENDIF
mfecha = vr_fecvig 
If Type('lvigen')#"N"
	lvigen = 0
Endif

If mxambito >1
	mccpoamb = "  a.codambito = ?mxambito and "
Else
	mccpoamb = ' a.id>5000 and '
Endif
cvigen = Iif(lvigen=0,'',' and fecvigenh >= ?mfecha and fecvigenh <> fecvigend ')

mret=SQLExec(mcon1, " SELECT a.*,b.abreviatura, c.descripcion " +;
	" FROM tabreservado as a,tabtipoturno as b, tabcriterios as c " +;
	" WHERE &mccpoamb centromedico = ?mxcentromedico and codmed = ?vr_codmed and a.tipoturno = b.tipoturno " +;
	" AND a.criterio = c.id  " +cvigen + ;
	" ORDER BY diasem,horadesde,fecvigenh desc,fecvigend desc ","MwkResGI")

*" AND (guardia >0 OR internado >0) "+;
*" and ?vr_fecha > fecvigend  and fecvigenh " + ;
*and fecvigenh >= ?fechahoy
If mxambito = 1
	mccpoamb = ' '
Endif

If mret < 0
	Messagebox('ERROR DE CURSOR, REINTENTE',16,'VALIDACION')
	mret=0
Else
	Sele MwkResGI
	Go Top
	If !Eof("MwkResGI")

		msql3  =" SELECT iif(diasem = 2, 'Lun ',iif(diasem = 3, 'Mar ', "+ ;
			"iif(diasem = 4, 'Mie ',iif(diasem = 5, 'Jue ', "+ ;
			"iif(diasem = 6, 'Vie ',iif(diasem = 7, 'Sab ','Dom')))))) + "+;
			"iif(isnull(left(ttoc(horadesde,2),5) + ' ' + left(ttoc(horahasta,2),5)), "+;
			"space(18),left(ttoc(horadesde,2),5) + ' ' + left(ttoc(horahasta,2),5)) as Horario, "+;
			"abreviatura as tipoturno, fecvigend as fdesde, fecvigenh as fhasta, "

		msql3_1=		"iif(isnull(guardia)  , space(8), left(ttoc(guardia,2), 8)) as guardia,   "+;
			"iif(isnull(internado), space(8), left(ttoc(internado,2),8)) as Internado, "

		msql3_2= 	"iif(isnull(horardesde),space(8), left(ttoc(horardesde,2), 8)) as desde,"+;
			"iif(isnull(horarhasta),space(8), left(ttoc(horarhasta,2), 8)) as hasta, "

		msql3_3=		"iif(isnull(horares1), space(8) ,  left(ttoc(horares1,2),8)) as Hora1, "+;
			"iif(isnull(horares2), space(8) ,  left(ttoc(horares2,2),8)) as Hora2, "+;
			"iif(isnull(horares3), space(8) ,  left(ttoc(horares3,2),8)) as Hora3, "+;
			"iif(isnull(horares4), space(8) ,  left(ttoc(horares4,2),8)) as Hora4, "+;
			"iif(isnull(horares5), space(8) ,  left(ttoc(horares5,2),8)) as Hora5, "

		msql3_4=	"iif(isnull(horares6), space(8) ,  left(ttoc(horares6,2),8)) as Hora6, "+;
			"iif(isnull(horares7), space(8) ,  left(ttoc(horares7,2),8)) as Hora7, "+;
			"iif(isnull(horares8), space(8) ,  left(ttoc(horares8,2),8)) as Hora8, "+;
			"iif(isnull(horares9), space(8) ,  left(ttoc(horares9,2),8)) as Hora9, "+;
			"iif(isnull(horares10),space(8) ,  left(ttoc(horares10,2),8)) as Hora10,"


		msql3_5=	"iif(isnull(cantidad),0,cantidad) as cantidad, descripcion, id FROM MwkResGI INTO CURSOR MwkGridGI1"


		msql3= msql3 + msql3_1 +  msql3_2 +  msql3_3 +  msql3_4 + msql3_5

	Endif
Endif
