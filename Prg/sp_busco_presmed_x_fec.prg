*
* Busqueda de Insumos Prescripcion Medica x ID de Evolución + Observaciones Enfermeria
*
Lparameters lidevol,xdfec

Use In Select("mwkpmsp")
Use In Select("mwkpmag")
Use In Select("mwkpmpl")
Use In Select("mwkobsenf")
mfiltro = ''
IF VARTYPE(xdfec)="D"
	mfecdes = prg_dtoc(xdfec)
	mfiltro = ' and  ICI_fechaHora>= ?mfecdes '
endif	
IF VARTYPE(xdfec)="T"
	mfecdes = prg_dtoc(TTOD(xdfec))
	mfiltro = ' and  ICI_fechaHora>= ?mfecdes '
endif	
mfnull = Ctod("01/01/1900")
mret = SQLExec(mcon1,"select *,ICI_usuario->nomape,ICI_insumo->INS_descriinsumo as desinsumo,0 as PS_insumo from TabIntCuiIns "+;
	" where ICI_idevol = ?lidevol " +mfiltro ,"mwkpmprog")

If mret < 0
	mltabla = "PRESCRIPCIONES MEDICAS - programacion enfermeria"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif
SELECT mwkpmprog
IF RECCOUNT('mwkpmprog')>0
	GO bottom
	mfhcum = ICI_fechaHora-15*60
ELSE
	mfhcum = sp_busco_fecha_serv("DT")-8*3600
endif
mfecum = TTOD(mfhcum)

mret = SQLExec(mcon1,"select TabIntPmSolu.*,INS_codpuntero "+;
	" from TabIntPmSolu inner join insumos on Insumos.INS_codinsumo = Tabintpmsolu.PS_insumo "+;
	" where PS_idevol = ?lidevol and (PS_fecpasiva = ?mfnull or  PS_fecpasiva >= ?mfecum) and PS_estadodia = 1","mwkpmsp")
	
	*" order by PS_guia","mwkpmsp")

If mret < 0
	mltabla = "PRESCRIPCIONES MEDICAS - SOLUCIONES PRINCIPALES"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mret = SQLExec(mcon1,"select * from TabIntPmAgre"+;
	" where PA_idevol = ?lidevol and (PA_fecpasiva = ?mfnull or  PA_fecpasiva >= ?mfecum)  and PA_estadodia = 1"+;
	" order by PA_guia","mwkpmag")

If mret < 0
	mltabla = "PRESCRIPCIONES MEDICAS - AGREGADOS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mret = SQLExec(mcon1,"select TabIntPmPlan.*,INS_codpuntero from TabIntPmPlan"+;
	" inner join insumos on Insumos.INS_codinsumo = TabIntPmPlan.PP_insumo "+;
	" where PP_idevol = ?lidevol and (PP_fecpasiva = ?mfnull or  PP_fecpasiva >= ?mfecum)  and PP_estadodia = 1"+;
	" order by PP_guia","mwkpmpl")

If mret < 0
	mltabla = "PRESCRIPCIONES MEDICAS - PLANIFICACION"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mret = SQLExec(mcon1,"select * from TabIntObsEnf"+;
	" where OBS_idevol = ?lidevol and (OBS_fecpasiva = ?mfnull or OBS_fecpasiva >=?mfecum) and OBS_sector <> 4  ","mwkobsenf")

If mret < 0
	mltabla = "OBSERVACIONES ENFERMERIA"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif


Return .T.
