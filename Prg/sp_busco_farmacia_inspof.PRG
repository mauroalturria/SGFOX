*
* Busqueda de Insumos por nro. de POF
*
Parameters mbuspof

Use in select("mwkinspof")

mret = sqlexec(mcon1,"select TCE_insumocodigo,TFP_pactivo,TCE_medidauso,TCE_partida,TCE_fechapasiva" +;
	" from TabFarmCitose" +;
	" join TabFarmPActivo on TFP_inscod = TCE_insumocodigo"+;
	" where TCE_nropof = ?mbuspof","mwkinspof")

If mret < 0
	Messagebox("EN CONSULTA DE INSUMOS DEL POF",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.
