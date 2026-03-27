*
* Busqueda de Insumos cargados en Planilla de Tratamientos x ID_Planilla ó Registracio
*
Lparameters midplan, mregistro

If used("mwkplandat")
	Use in mwkplandat
Endif

If vartype(midplan)#"N"
	midplan=0
Endif

If vartype(mregistro)#"N"
	mregistro=0
Endif

If mregistro > 0
	mjoin  = " join TabFarmPlan on TabFarmPlan.Id=TabFarmPlanI.TFI_idplan"+;
		" and TabFarmPlan.TFP_registracio=?mregistro"
	mwhere = " where TabFarmPlanI.TFI_fecpasiva is null "
Else
	mjoin  = ""
	mwhere = " where TabFarmPlanI.TFI_fecpasiva is null and TabFarmPlanI.TFI_idplan=?midplan "
Endif

mret = sqlexec(mcon1,"select TFI_feciclo,TFI_hora,TFP_pactivo,TFI_insumocodig,TFI_agrupa,TFI_dosis"+;
	" from TabFarmPlanI " + mjoin +;
	" join TabFarmPActivo on TFP_pactivo=TFI_pactivo " + mwhere,"mwkplandat")
	
*	" join TabFarmPActivo on TFP_inscod=TFI_insumocodig " + mwhere,"mwkplandat")	

If mret < 0
	Messagebox("EN CONSULTA DE PLANILLAS DE TRATAMIENTOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif

