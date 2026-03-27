****
**  Busco las entidades del paciente
****

Parameter mnroregistra,tcCursor
*!*	Do sp_busco_estados With 57,' and Tipo = 3 ','mwkbloqueaplan'
*!*	mcpoplan = ''
*!*	If mwkbloqueaplan.estado = 0
mcpoplan = ',AFI_idplan '
*!*	Else
*!*		mcpoplan = ', CAST(registracio.reg_distrito  as integer) as AFI_idplan '
*!*	Endif


If !Used('mwktabambito')
	mret = SQLExec(mcon1,"select * from TabAmbito", "mwktabambito")
Endif
If mxambito >1

	Select mwktabambito
	Locate For Id = mxambito
	mccpoamb = " where INLIST(ENT_codagrup, "+Alltrim(mwktabambito.tipoent)+") "
Else
	mccpoamb = ''
Endif

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkafient'
Endif

mret = SQLExec(mcon1,"select AFI_nroafiliado, ENT_descrient, AFI_codentidad, AFI_fechabaja, " + ;
	"ENT_fecpas, ENT_codent, ENT_turnoshabilit, ENT_capita, ENT_tipo,ENT_nroprestadorexterno ,ENT_codagrup  " +mcpoplan + ;
	"from afiliacion, entidades,registracio " + ;
	"where afiliacion.registracio =?mnroregistra and registracio.registracio =?mnroregistra and " + ;
	"afiliacion.AFI_codentidad = entidades.ENT_codent", tcCursor)


If !Used('mwkplantodo')
	mret = SQLExec(mcon1,"select id,CodEntAg,plancoseg from planes  where FecPasivaPlan ='1900-01-01'  "+;
		" order by descripcion desc","mwkplantodo")
	Select Id,CodEntAg From mwkplantodo;
		group By codentag Having Count(Id)=1 Into Cursor mwkunplan
Endif
Select * From &tcCursor,mwkunplan Where  ENT_codent=CodEntAg ;
	Into Cursor mwkcontrola
Select * From &tcCursor,mwkplantodo Where AFI_idplan=mwkplantodo.Id ;
	AND ENT_codent Not In (Select ENT_codent From mwkcontrola);
	GROUP By ENT_codent,CodEntAg Into Cursor mwkcontrolasc
Select mwkcontrola
Scan
	If mwkcontrola.Id<>NVL(mwkcontrola.AFI_idplan,-1)
		xcodent = mwkcontrola.ENT_codent
		midplan = mwkcontrola.Id
		mret = SQLExec(mcon1, "update afiliacion  set AFI_idplan = ?midplan "+;
			"  where registracio  = ?mnroregistra and AFI_codentidad =?xcodent ")
	Endif
Endscan
Select mwkcontrolasc
Scan
	If NVL(mwkcontrolasc.ENT_codagrup,mwkcontrolasc.ENT_codent)<>mwkcontrolasc.CodEntAg
		xcodent = mwkcontrolasc.ENT_codent
		midplan = Null
		mret = SQLExec(mcon1, "update afiliacion  set AFI_idplan = ?midplan "+;
			"  where registracio  = ?mnroregistra and AFI_codentidad =?xcodent ")
	Endif
Endscan
If Reccount('mwkcontrola')>0 Or  Reccount('mwkcontrolasc')>0
	mret = SQLExec(mcon1,"select AFI_nroafiliado, ENT_descrient, AFI_codentidad, AFI_fechabaja, " + ;
		"ENT_fecpas, ENT_codent, ENT_turnoshabilit, ENT_capita, ENT_tipo,ENT_nroprestadorexterno ,ENT_codagrup  " +mcpoplan + ;
		"from afiliacion, entidades,registracio " + ;
		"where afiliacion.registracio  =?mnroregistra and registracio.registracio =?mnroregistra and " + ;
		"afiliacion.AFI_codentidad = entidades.ENT_codent", tcCursor)
Endif

If mret < 0
	Messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE',16,'Validacion')
	Do prg_cancelo
Else
	msql1 = "select AFI_nroafiliado, ENT_descrient,  " + ;
		"iif(!isnull(AFI_fechabaja), AFI_fechabaja, ctod(' /  /  ') ) as fecha, " + ;
		"iif(!isnull(AFI_fechabaja) or  !isnull(ENT_fecpas), 1,0 ) as xactivo, " + ;
		"AFI_codentidad, AFI_fechabaja, ENT_fecpas, ENT_codent, ENT_turnoshabilit, "+;
		"ENT_capita, ENT_codagrup, ENT_tipo,ENT_nroprestadorexterno " +mcpoplan + ;
		"from &tcCursor &mccpoamb order by xactivo, ENT_descrient into cursor mwkafient1"

Endif
