*
* Busqueda de Insumos Prescripcion Medica x ID de Evolución + Observaciones Enfermeria
*
Lparameters lidevol

Use In Select("mwkpmsp")
Use In Select("mwkpmag")
Use In Select("mwkpmpl")
Use In Select("mwkobsenf")

mfnull = Ctod("01/01/1900")

mret = SQLExec(mcon1,"select * from TabIntPmSolu"+;
	" where PS_idevol = ?lidevol and PS_fecpasiva = ?mfnull and PS_estadodia = 1","mwkpmsp")

*" order by PS_guia","mwkpmsp")

If mret < 0
	mltabla = "PRESCRIPCIONES MEDICAS - SOLUCIONES PRINCIPALES"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mret = SQLExec(mcon1,"select * from TabIntPmAgre"+;
	" where PA_idevol = ?lidevol and PA_fecpasiva = ?mfnull and PA_estadodia = 1"+;
	" order by PA_guia","mwkpmag")

If mret < 0
	mltabla = "PRESCRIPCIONES MEDICAS - AGREGADOS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mret = SQLExec(mcon1,"select * from TabIntPmPlan"+;
	" where PP_idevol = ?lidevol and PP_fecpasiva = ?mfnull and PP_estadodia = 1"+;
	" order by PP_guia","mwkpmpl")

If mret < 0
	mltabla = "PRESCRIPCIONES MEDICAS - PLANIFICACION"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mret = SQLExec(mcon1,"select * from TabIntObsEnf"+;
	" where OBS_idevol = ?lidevol and OBS_fecpasiva = ?mfnull and OBS_sector <> 4","mwkobsenf")

If mret < 0
	mltabla = "OBSERVACIONES ENFERMERIA"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif


Return .T.
