*
* Consulta de Insumos (drogas) para un plan de tratamiento citostatico.
*
Parameters mid

If used('mwkplaninsu')
	Use in mwkplaninsu
Endif

*!*	mret = sqlexec(mcon1,"select *,TabFarmPlani.id as lidplani,TFP_pactivo"+;
*!*		" from TabFarmPlani"+;
*!*		" join TabFarmPActivo on TFP_inscod = TabFarmPlani.TFI_insumocodig"+;
*!*		" where TFI_idplan = ?mid and TFI_fecpasiva is null"+;
*!*		" order by TFI_feciclo,TFI_hora","mwkplaninsu")

mret = sqlexec(mcon1,"select *,TabFarmPlani.id as lidplani,TFP_pactivo"+;
	" from TabFarmPlani"+;
	" join TabFarmPActivo on TFP_inscod = TabFarmPlani.TFI_insumocodig"+;
	" where TFI_idplan = ?mid "+;
	" order by TFI_feciclo,TFI_hora","mwkplaninsu")

If mret < 0
	Messagebox("EN CONSULTA DE INSUMOS DEL PLAN DE TRATAMIENTO"+chr(10)+;
		"CITOSTATICO - AVISE A SISTEMAS",16,"ERROR")
Endif
