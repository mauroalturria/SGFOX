*-----------------------------------------------------------------------------------------------------------------*
*
* Busqueda de unidades stock registrado para Farmacia, registro de stock sisetma Auditoria de Sotck Insumos
*
*-----------------------------------------------------------------------------------------------------------------*
Lparameters mcod, mpar


Use In Select("mwkfarmlog")
mretorno = 0

mret = SQLExec(mcon1,"select TFL_partida,TFL_insumocodigo,TabFarmPactivo.TFP_insdes,"+;
	" TFL_motivo,TFL_potencia,TFL_idusuario,TFL_fechamov, TabFarmbaseco.TBC_dosis,"+;
	" TabFarmbaseco.TBC_udosis,TFL_lote,TFL_vence,TFL_gtin,TFL_serie"+;
	" from TabFarmLog"+;
	" left join TabFarmbaseco on TBC_inscod = TFL_insumocodigo" +;
	" left join TabFarmPactivo on TFP_inscod = TFL_insumocodigo " +;
	" where TFL_insumocodigo = ?mcod and TFL_partida = ?mpar and TFL_motivo like '%STK%'"+;
	" group by TFL_insumocodigo, TFL_lote, TFL_vence, TFL_gtin, TFL_serie, TFL_fechamov","mwkfarmlog")

If mret < 0
	Messagebox("EN CONSULTA DE LOG MEDICAMENTOS CITOSTATICOS"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return mretorno
Endif

If Used("mwkfarmlog")
	If Reccount("mwkfarmlog")>0
		Select mwkfarmlog
		Go Top
		Scan All
			If Nvl(mwkfarmlog.TFL_potencia,0) > 0 And Nvl(mwkfarmlog.TBC_dosis,0) > 0
				mretorno = mretorno + (mwkfarmlog.TFL_potencia / mwkfarmlog.TBC_dosis)
			Else
				mretorno = mretorno + mwkfarmlog.TFL_potencia
			Endif
		Endscan
	Endif
Endif

Use In Select("mwkfarmlog")

Return mretorno


