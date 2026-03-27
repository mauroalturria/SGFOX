*
* Busqueda de Partidas de Stock relacionado c/Planilla Tratamiento y día del
* ciclo de aplicación
*
Lparameters mbusca

*set step on

If used('mwkcitosp')

	If reccount('mwkcitosp')>0
		If used('mwkdplan')
			Use in mwkdplan
		Endif

		mret = sqlexec(mcon1,"select TabFarmPlanI.*,TabFarmPlanI.id as lidplani,TabFarmPActivo.TFP_pactivo"+;
			", TFP_fecpasiva "+;
			" from TabFarmPlanI"+;
			" join TabFarmPlan on TabFarmPlan.Id = TabFarmPlanI.TFI_idplan and"+;
			" TabFarmPlan.TFP_registracio=?mbusca"+;
			" join TabFarmPActivo"+;
			" on TabFarmPActivo.TFP_pactivo = TabFarmPlanI.TFI_pactivo"+;
			" where TFP_fecpasiva is null and TFI_fecpasiva is null"+;
			" group by TFI_insumocodig,TFI_feciclo,TFI_hora","mwkdplan")

*!* ", TFP_fecpasiva "+;
* agregado group by
* " and TabFarmPActivo.TFP_inscod=TabFarmPlanI.TFI_insumocodig","mwkdplan")
* " on TabFarmPActivo.TFP_inscod=TabFarmPlanI.TFI_insumocodig","mwkdplan")

	Endif
Endif

*!* set step on

If used('mwkcitosp1')
	Use in mwkcitosp1
Endif

If used('mwkcitosp2')
	Use in mwkcitosp2
Endif

