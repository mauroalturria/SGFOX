*
* Busqueda Log de movimientos Farmacia Medicamentos Citostáticos
*
Lparameters mcod, mpar

mwhere = ''

If Vartype('mcod') = "C"
	mwhere = " where TFL_insumocodigo = ?mcod"
Endif

If Vartype('mpar') = "C"
	If Len(Alltrim(mwhere))>0
		mwhere = mwhere + " and "
	Else
		mwhere = " where "
	Endif
	mwhere = mwhere +"TFL_partida = ?mpar"
Endif

If Used('mwkfarmlog')
	Use In mwkfarmlog
Endif

*TabFarmPactivo.TFP_pactivo

*!*	mret = SQLExec(mcon1,"select TFL_partida,TFL_insumocodigo,TabFarmPactivo.TFP_insdes,"+;
*!*		" TFL_motivo,TFL_potencia,TFL_idusuario,TFL_fechamov, TabFarmbaseco.TBC_dosis,"+;
*!*		" TabFarmbaseco.TBC_udosis,TFL_lote,TFL_vence,TFL_gtin,TFL_serie"+;
*!*		" from TabFarmLog"+;
*!*		" left join TabFarmbaseco on TBC_inscod = TFL_insumocodigo"+;
*!*		" left join TabFarmPactivo on TFP_inscod = TFL_insumocodigo " + mwhere+;
*!*		" group by TFL_partida,TFL_insumocodigo,TFL_fechamov,TFL_lote,TFL_vence,"+;
*!*		" TFL_serie,TFL_potencia","mwkfarmlog")

*!*	*!*	" group by TFL_partida,TFL_insumocodigo,TFL_fechamov,TFL_lote,TFL_vence","mwkfarmlog")

*!*	If mret < 0
*!*		Messagebox("EN CONSULTA DE LOG MEDICAMENTOS CITOSTATICOS"+Chr(10)+;
*!*			"AVISE A SISTEMAS",16,"ERROR")
*!*		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*		Return .F.
*!*	Endif

*** Marcelo Torres, 15/09/2025
*** Separo la dispensación del resto de registros, porque agrupaba y mostraba un solo item dispensado
*** Afectaba a la vista de insumos dispensados. Lo demas se veia bien.
mret = SQLExec(mcon1,"select TFL_partida,TFL_insumocodigo,TabFarmPactivo.TFP_insdes,"+;
	" TFL_motivo,TFL_potencia,TFL_idusuario,TFL_fechamov, TabFarmbaseco.TBC_dosis,"+;
	" TabFarmbaseco.TBC_udosis,TFL_lote,TFL_vence,TFL_gtin,TFL_serie"+;
	" from TabFarmLog"+;
	" left join TabFarmbaseco on TBC_inscod = TFL_insumocodigo"+;
	" left join TabFarmPactivo on TFP_inscod = TFL_insumocodigo " + mwhere,"mwkfarmlog")

*" group by TFL_partida,TFL_insumocodigo,TFL_fechamov,TFL_lote,TFL_vence,"+;
*	" TFL_serie,TFL_potencia"

SELECT * FROM mwkfarmlog ;
WHERE ALLTRIM(UPPER(TFL_motivo)) = 'DISPENSACIÓN' INTO CURSOR mwkfarmlogdispensa

SELECT * FROM mwkfarmlog ;
WHERE ALLTRIM(UPPER(TFL_motivo)) != 'DISPENSACIÓN' ;
group by TFL_partida,TFL_insumocodigo,TFL_fechamov,TFL_lote,TFL_vence,TFL_serie,TFL_potencia ;
INTO CURSOR mwkfarmlog_b

SELECT * FROM mwkfarmlog_b ;
UNION all;
select * FROM mwkfarmlogdispensa;
into CURSOR mwkfarmlog


If mret < 0
	Messagebox("EN CONSULTA DE LOG MEDICAMENTOS CITOSTATICOS"+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
