*
* Log Prescripciones Medicas / Planificación
*
Parameters midevo
*, mtipo


mltabla = "Prescripción Médica - Soluciones Principales"
mFecPasiva = Ctod("01/01/1900")

*
* LOG Soluciones Principales / Medicamentos
*
*!*	Use In Select("mwkctrlf")

** Buscamos fecha de modificacion mas alta.
**mret = SQLExec(mcon1,"select top 1 * from TabIntPmSolu where PS_idevol = ?midevo order by id desc","mwkctrlf")

*!*	If mret < 0
*!*		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*!*		Return .F.
*!*	Endif

*!*	mFec = Dtot({//})
*!*	If Used("mwkctrlf")
*!*		If Reccount("mwkctrlf")>0
*!*			mFec = mwkctrlf.PS_fechormodif
*!*		Endif
*!*	Endif

*!*	If !Empty(mFec)


**mret = SQLExec(mcon1,"select * from TabIntPmSoluLg where PS_idevol = ?midevo and PS_fechormodif = ?mfec","mwkctrlf")

*!*		If mret < 0
*!*			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*			Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*!*			Return .F.
*!*		Endif

*!*		If Reccount("mwkctrlf") = 0

*!*			mret = SQLExec(mcon1,"insert into TabIntPmSoluLg (PS_admision, PS_idevol, PS_tipo, PS_guia, PS_insumo, PS_volumen,"+;
*!*				" PS_unidadvol, PS_goteo, PS_goteovol,"+;
*!*				" PS_goteotmp,PS_goteotuni,PS_goteogtsmin, PS_goteomacmic,PS_goteomlhr, PS_via, PS_fechoraini, PS_urgente,"+;
*!*				" PS_fecpasiva, PS_motivo, PS_usuarioalta, PS_fechoralta, PS_usuariomodif, PS_fechormodif, PS_estadodia,"+;
*!*				" PS_cantidad,PS_unidad,PS_cantpres,PS_unipres,PS_comentarios,PS_baxter, PS_observa, PS_idorg, PS_idac)"+;
*!*				" SELECT PS_admision, PS_idevol, PS_tipo, PS_guia, PS_insumo, PS_volumen, PS_unidadvol, PS_goteo, PS_goteovol,"+;
*!*				" PS_goteotmp,PS_goteotuni,PS_goteogtsmin, PS_goteomacmic,PS_goteomlhr, PS_via, PS_fechoraini, PS_urgente,"+;
*!*				" PS_fecpasiva, PS_motivo, PS_usuarioalta, PS_fechoralta, PS_usuariomodif, PS_fechormodif, PS_estadodia,"+;
*!*				" PS_cantidad,PS_unidad,PS_cantpres,PS_unipres,PS_comentarios,PS_baxter, PS_observa, TabIntPmSolu.ID, TabIntPmSolu.PS_idac"+;
*!*				" from TabIntPmSolu"+;
*!*				" where TabIntPmSolu.PS_idevol = ?midevo and TabIntPmSolu.PS_fechormodif = ?mfec")

mret = SQLExec(mcon1,"insert into TabIntPmSoluLg (PS_admision, PS_idevol, PS_tipo, PS_guia, PS_insumo, PS_volumen,"+;
	" PS_unidadvol, PS_goteo, PS_goteovol,"+;
	" PS_goteotmp,PS_goteotuni,PS_goteogtsmin, PS_goteomacmic,PS_goteomlhr, PS_via, PS_fechoraini, PS_urgente,"+;
	" PS_fecpasiva, PS_motivo, PS_usuarioalta, PS_fechoralta, PS_usuariomodif, PS_fechormodif, PS_estadodia,"+;
	" PS_cantidad,PS_unidad,PS_cantpres,PS_unipres,PS_comentarios,PS_baxter, PS_observa, PS_idorg, PS_idac)"+;
	" SELECT PS_admision, PS_idevol, PS_tipo, PS_guia, PS_insumo, PS_volumen, PS_unidadvol, PS_goteo, PS_goteovol,"+;
	" PS_goteotmp,PS_goteotuni,PS_goteogtsmin, PS_goteomacmic,PS_goteomlhr, PS_via, PS_fechoraini, PS_urgente,"+;
	" PS_fecpasiva, PS_motivo, PS_usuarioalta, PS_fechoralta, PS_usuariomodif, PS_fechormodif, PS_estadodia,"+;
	" PS_cantidad,PS_unidad,PS_cantpres,PS_unipres,PS_comentarios,PS_baxter, PS_observa, TabIntPmSolu.ID, TabIntPmSolu.PS_idac"+;
	" from TabIntPmSolu"+;
	" where TabIntPmSolu.PS_idevol = ?midevo and TabIntPmSolu.PS_fecpasiva = ?mfecPasiva")

If mret < 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

*!*		Endif

*!*	Endif

*!*	Use In Select("mwkctrlf")

*
* Agregados
*

*!*	mret = SQLExec(mcon1,"select top 1 * from TabIntPmAgre where PA_idevol = ?midevo order by id desc","mwkctrlf")

*!*	If mret < 0
*!*		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*!*		Return .F.
*!*	Endif

*!*	mFec = Dtot({//})
*!*	If Used("mwkctrlf")
*!*		If Reccount("mwkctrlf")>0
*!*			mFec = mwkctrlf.PA_fechormodif
*!*		Endif
*!*	Endif

mltabla = "Prescripción Médica - Insumos agregados"

*!*	If !Empty(mFec)

*!*		mret = SQLExec(mcon1,"select * from TabIntPmAgreLg where PA_idevol = ?midevo and PA_fechormodif = ?mfec","mwkctrlf")

*!*		If mret < 0
*!*			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*			Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*!*			Return .F.
*!*		Endif

*!*		If Reccount("mwkctrlf") = 0


*!*			mret = SQLExec(mcon1,"insert into TabIntPmAgreLg"+;
*!*				" (PA_admision, PA_idevol,PA_tipo, PA_guia, PA_insumo, PA_cantidad, PA_unidadvol, PA_fecpasiva,"+;
*!*				" PA_motivo,PA_usuarioalta, PA_fechoralta, PA_usuariomodif, PA_fechormodif, PA_estadodia,"+;
*!*				" PA_cantpres,PA_unipres, PA_comentarios, PA_baxter, PA_idorg, PA_idac)"+;
*!*				" SELECT PA_admision, PA_idevol,PA_tipo, PA_guia, PA_insumo, PA_cantidad, PA_unidadvol, PA_fecpasiva,"+;
*!*				" PA_motivo,PA_usuarioalta, PA_fechoralta, PA_usuariomodif, PA_fechormodif, PA_estadodia,"+;
*!*				" PA_cantpres,PA_unipres, PA_comentarios, PA_baxter, TabIntPmAgre.ID, TabIntPmAgre.PA_idac"+;
*!*				" from TabIntPmAgre"+;
*!*				" where PA_idevol = ?midevo and PA_fechormodif = ?mfec")

mret = SQLExec(mcon1,"insert into TabIntPmAgreLg"+;
	" (PA_admision, PA_idevol,PA_tipo, PA_guia, PA_insumo, PA_cantidad, PA_unidadvol, PA_fecpasiva,"+;
	" PA_motivo,PA_usuarioalta, PA_fechoralta, PA_usuariomodif, PA_fechormodif, PA_estadodia,"+;
	" PA_cantpres,PA_unipres, PA_comentarios, PA_baxter, PA_idorg, PA_idac, PA_IdOptDMax, PA_ObsDMax)"+;
	" SELECT PA_admision, PA_idevol,PA_tipo, PA_guia, PA_insumo, PA_cantidad, PA_unidadvol, PA_fecpasiva,"+;
	" PA_motivo,PA_usuarioalta, PA_fechoralta, PA_usuariomodif, PA_fechormodif, PA_estadodia,"+;
	" PA_cantpres,PA_unipres, PA_comentarios, PA_baxter, TabIntPmAgre.ID, TabIntPmAgre.PA_idac, PA_IdOptDMax, PA_ObsDMax "+;
	" from TabIntPmAgre"+;
	" where PA_idevol = ?midevo and PA_fecPasiva = ?mfecPasiva")

If mret < 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

*!*		Endif

*!*	Endif

*!*	Use In Select("mwkctrlf")

*
* Planificacion
*

*!*	mret = SQLExec(mcon1,"select top 1 * from TabIntPmPlan where PP_idevol = ?midevo order by id desc","mwkctrlf")

*!*	If mret < 0
*!*		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*!*		Return .F.
*!*	Endif

*!*	mFec = Dtot({//})
*!*	If Used("mwkctrlf")
*!*		If Reccount("mwkctrlf")>0
*!*			mFec = mwkctrlf.PP_fechormodif
*!*		Endif
*!*	Endif

mltabla = "Prescripción Médica - Planificación"

*!*	If !Empty(mFec)

*!*		mret = SQLExec(mcon1,"select * from TabIntPmPlanLg where PP_idevol = ?midevo and PP_fechormodif = ?mfec","mwkctrlf")

*!*		If mret < 0
*!*			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*			Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*!*			Return .F.
*!*		Endif

*!*		If Reccount("mwkctrlf") = 0


*!*			mret = SQLExec(mcon1,"insert into TabIntPmPlanLg"+;
*!*				" (PP_admision, PP_idevol, PP_tipo, PP_guia, PP_dosis, PP_unidadvol, PP_fecpasiva, " +;
*!*				" PP_motivo, PP_usuarioalta, PP_fechoralta, PP_usuariomodif,"+;
*!*				" PP_fechormodif, PP_frecuencia, PP_urgente, PP_estadodia, PP_valfrec,PP_baxter, PP_idopt, PP_FecHorProxDosis, PP_insumo, PP_idorg)"+;
*!*				" SELECT PP_admision, PP_idevol, PP_tipo, PP_guia, PP_dosis, PP_unidadvol, PP_fecpasiva, " +;
*!*				" PP_motivo, PP_usuarioalta, PP_fechoralta, PP_usuariomodif,"+;
*!*				" PP_fechormodif, PP_frecuencia, PP_urgente, PP_estadodia, PP_valfrec,PP_baxter, PP_idopt, PP_FecHorProxDosis, PP_insumo, TabIntPmPlan.ID"+;
*!*				" from TabIntPmPlan"+;
*!*				" where PP_idevol = ?midevo and PP_fechormodif = ?mfec")

mret = SQLExec(mcon1,"insert into TabIntPmPlanLg"+;
	" (PP_admision, PP_idevol, PP_tipo, PP_guia, PP_dosis, PP_unidadvol, PP_fecpasiva, " +;
	" PP_motivo, PP_usuarioalta, PP_fechoralta, PP_usuariomodif,"+;
	" PP_fechormodif, PP_frecuencia, PP_urgente, PP_estadodia, PP_valfrec,PP_baxter, PP_idopt, PP_FecHorProxDosis, PP_insumo, PP_idorg, PP_IdOptDMax, PP_ObsDMax)"+;
	" SELECT PP_admision, PP_idevol, PP_tipo, PP_guia, PP_dosis, PP_unidadvol, PP_fecpasiva, " +;
	" PP_motivo, PP_usuarioalta, PP_fechoralta, PP_usuariomodif,"+;
	" PP_fechormodif, PP_frecuencia, PP_urgente, PP_estadodia, PP_valfrec,PP_baxter, PP_idopt, PP_FecHorProxDosis, PP_insumo, TabIntPmPlan.ID, PP_IdOptDMax, PP_ObsDMax "+;
	" from TabIntPmPlan"+;
	" where PP_idevol = ?midevo and PP_fecPasiva = ?mfecPasiva")

If mret < 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

*!*		Endif
*!*	Endif

*!*	Use In Select("mwkctrlf")

Return .T.



*!*	Do Case
*!*	Case mtipo = 1 && Soluciones Principales

*!*		mltabla = "Prescripción Médica - Soluciones Principales"

*!*		mret = SQLExec(mcon1,"insert into TabIntPmSoluLg (PS_admision, PS_idevol, PS_tipo, PS_guia, PS_insumo, PS_volumen,"+;
*!*			" PS_unidadvol, PS_goteo, PS_goteovol,"+;
*!*			" PS_goteotmp,PS_goteotuni,PS_goteogtsmin, PS_goteomacmic,PS_goteomlhr, PS_via, PS_fechoraini, PS_urgente,"+;
*!*			" PS_fecpasiva, PS_motivo, PS_usuarioalta, PS_fechoralta, PS_usuariomodif, PS_fechormodif, PS_estadodia,"+;
*!*			" PS_cantidad,PS_unidad,PS_cantpres,PS_unipres,PS_comentarios,PS_baxter, PS_observa)"+;
*!*			" SELECT PS_admision, PS_idevol, PS_tipo, PS_guia, PS_insumo, PS_volumen, PS_unidadvol, PS_goteo, PS_goteovol,"+;
*!*			" PS_goteotmp,PS_goteotuni,PS_goteogtsmin, PS_goteomacmic,PS_goteomlhr, PS_via, PS_fechoraini, PS_urgente,"+;
*!*			" PS_fecpasiva, PS_motivo, PS_usuarioalta, PS_fechoralta, PS_usuariomodif, PS_fechormodif, PS_estadodia,"+;
*!*			" PS_cantidad,PS_unidad,PS_cantpres,PS_unipres,PS_comentarios,PS_baxter, PS_observa"+;
*!*			" from TabIntPmSolu"+;
*!*			" where TabIntPmSolu.PS_idevol = ?midevo")

*!*	Case mtipo = 2 && Insumos agregados

*!*		mltabla = "Prescripción Médica - Insumos agregados"

*!*		mret = SQLExec(mcon1,"insert into TabIntPmAgreLg"+;
*!*			" (PA_admision, PA_idevol,PA_tipo, PA_guia, PA_insumo, PA_cantidad, PA_unidadvol, PA_fecpasiva,"+;
*!*			" PA_motivo,PA_usuarioalta, PA_fechoralta, PA_usuariomodif, PA_fechormodif, PA_estadodia,"+;
*!*			" PA_cantpres,PA_unipres, PA_comentarios, PA_baxter)"+;
*!*			" SELECT PA_admision, PA_idevol,PA_tipo, PA_guia, PA_insumo, PA_cantidad, PA_unidadvol, PA_fecpasiva,"+;
*!*			" PA_motivo,PA_usuarioalta, PA_fechoralta, PA_usuariomodif, PA_fechormodif, PA_estadodia,"+;
*!*			" PA_cantpres,PA_unipres, PA_comentarios, PA_baxter"+;
*!*			" from TabIntPmAgre"+;
*!*			" where PA_idevol = ?midevo")


*!*	Case mtipo = 3 && Planificacion

*!*		mltabla = "Prescripción Médica - Planificación"

*!*		mret = SQLExec(mcon1,"insert into TabIntPmPlanLg"+;
*!*			" (PP_admision, PP_idevol, PP_tipo, PP_guia, PP_dosis, PP_unidadvol, PP_fecpasiva, " +;
*!*			" PP_motivo, PP_usuarioalta, PP_fechoralta, PP_usuariomodif,"+;
*!*			" PP_fechormodif, PP_frecuencia, PP_urgente, PP_estadodia, PP_valfrec,PP_baxter, PP_idopt, PP_FecHorProxDosis, PP_insumo)"+;
*!*			" SELECT PP_admision, PP_idevol, PP_tipo, PP_guia, PP_dosis, PP_unidadvol, PP_fecpasiva, " +;
*!*			" PP_motivo, PP_usuarioalta, PP_fechoralta, PP_usuariomodif,"+;
*!*			" PP_fechormodif, PP_frecuencia, PP_urgente, PP_estadodia, PP_valfrec,PP_baxter, PP_idopt, PP_FecHorProxDosis, PP_insumo"+;
*!*			" from TabIntPmPlan"+;
*!*			" where PP_idevol= ?midevo")

*!*	Endcase
