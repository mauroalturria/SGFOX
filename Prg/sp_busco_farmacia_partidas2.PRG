*
* Busqueda de Partidas de Stock relacionado c/Planilla Tratamiento y día del
* ciclo de aplicación
*
Lparameters mbusca

If used('mwkcitosp')
	If reccount('mwkcitosp')>0

		If used('mwkdplan')
			Use in mwkdplan
		Endif

		mret = sqlexec(mcon1,"select *, TabFarmPlanI.id as lidplani, TabFarmPActivo.TFP_pactivo"+;
			" from TabFarmPlanI"+;
			" join TabFarmPlan on TabFarmPlan.Id=TabFarmPlanI.TFI_idplan and TabFarmPlan.TFP_registracio=?mbusca"+;
			" join TabFarmPActivo on TabFarmPActivo.TFP_inscod=TabFarmPlanI.TFI_insumocodig"+;
			" where TabFarmplanI.TFI_fecpasiva is null","mwkdplan")

	Endif
Endif

If used('mwkcitosp1')
	Use in mwkcitosp1
Endif

If used('mwkcitosp2')
	Use in mwkcitosp2
Endif

