*
* HDO Lectura de Items a trazar y etiquetas
*
Lparameters mbuspof, mevento

Use In Select("mwketqrhdo")

mret = SQLExec(mcon1,"select * from tabfarmetqcitos"+;
	" where TEC_nropof = ?mbuspof"+;
	" and TEC_fecpasiva is null","mwketqrhdo")

If mret < 0
	MTABLA = "ETIQUETAS HDO BUSQUEDA POF (ACTIVO)"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

If Reccount("mwketqrhdo") = 0

	Use In Select("mwketqrhdo")
	mret = SQLExec(mcon1,"select * from tabfarmetqcitos"+;
		" where TEC_nropof = ?mbuspof","mwketqrhdo")

	If mret < 0
		MTABLA = "ETIQUETAS HDO BUSQUEDA POF (BAJA)"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	If Reccount("mwketqrhdo") > 0 And mwketqrhdo.TEC_fecpasiva > {//}
		msg = "EL POF SE ENCUENTRA DADO DE BAJA, FECHA: "+Dtoc(mwketqrhdo.TEC_fecpasiva)
	Else
		msg = "EL POF NO HA SIDO UBICADO EN MAESTROS"
	Endif

	Messagebox(msg,48,"ATENCION")

	Return .F.

Endif

Use In Select("mwkitemhdo")

*!*
*!* ANTERIOR
*!*
*!*	mret = sqlexec(mcon1,"select TabTraMov.*, TGT_InsCod, TGT_des, TGT_Rsoc from TabTraMov"+;
*!*	    " join TabTraGTIN on TGT_Gtin = TabTraMov.TTM_Gtin"+;
*!*		" where TTM_nropof = ?mbuspof"+;
*!*		" and TTM_evento = ?mevento and TTM_transcod = 0","mwkitemhdo")

*!* 2015-02-03 Mauro. consulto por insumos previamente trazados en recepcion
*!*
*!*	mret = SQLExec(mcon1,"select * from TabFarmCitosI "+;
*!*		" join TabFarmCitosE on TCE_nropof = ?mbuspof "+;
*!*		" and TCE_partida = TabFarmCitosI.TCI_partida "+;
*!*		" group by TCI_gtin, TCI_insumocodigo, TCI_serie, TCI_lote","mwkitemhdo")

*!*
*!* 2015-02-20 Mauro. Optimizo busqueda para que traiga por POF (s/log) + Partida
*!*

mbusEmipof = 'EMITE '+mbuspof

*!* 2015-06-15

*!*	mret = SQLExec(mcon1,"select * from TabFarmCitosI" +;
*!*		 " join TabFarmCitosE on TCE_nropof = ?mbuspof" +;
*!*		 " and TCE_partida = TabFarmCitosI.TCI_partida"+;
*!*		 " join TabFarmLog on TabFarmLog.TFL_partida = TabFarmCitosI.TCI_partida"+;
*!*		 " and TabFarmLog.TFL_lote  = TabFarmCitosI.TCI_lote" +;
*!*		 " and TabFarmLog.TFL_gtin  = TabFarmCitosI.TCI_gtin" +;
*!*		 " and TabFarmLog.TFL_serie = TabFarmCitosI.TCI_serie" +;
*!*		 " and TabFarmLog.TFL_motivo = ?mbusEmipof" +;
*!*		 " where TCI_resto > 0"+;
*!*		 " group by TCI_gtin, TCI_insumocodigo, TCI_serie, TCI_lote","mwkitemhdo")


mret = SQLExec(mcon1,"select * from TabFarmCitosI"+;
	  " join TabFarmCitosE on TCE_nropof = ?mbuspof" +;
	  " and TCE_partida = TabFarmCitosI.TCI_partida" +;
	  " join TabFarmLog on TabFarmLog.TFL_partida = TabFarmCitosI.TCI_partida" +;
	  " and TabFarmLog.TFL_lote  = TabFarmCitosI.TCI_lote" +;
	  " and TabFarmLog.TFL_gtin  = TabFarmCitosI.TCI_gtin" +;
	  " and TabFarmLog.TFL_serie = TabFarmCitosI.TCI_serie" +;
	  " and TabFarmLog.TFL_motivo = ?mbusEmipof" +;
	  " where 1=1"+;
	  " group by TCI_gtin, TCI_insumocodigo, TCI_serie, TCI_lote","mwkitemhdo")


If mret < 0
	MTABLA = "TRAZABILIDAD, ITEMS A TRAZAR"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.

*!*	// 1
*!*	select * from TabTraLogDis WHERE TLD_nropof = ?mbuspof
*!*	// 2
*!*	select * from TabFarmCitosE where TCE_nropof = 'POF013367'  (TCE_partida)
*!*	select * from TabFarmCitosE where TCE_nropof = ?mbuspof

*!*	// 3
*!*	select * from TabFarmCitosI
*!*	join TabFarmCitosE on TCE_nropof = ?mbuspof and TCE_partida = TabFarmCitosI.TCI_partida

*!* TCI_gtin, TCI_insumocodigo, TCI_insumodescrip, TCI_marca, TCI_serie, TCI_lote, TCI_vence
*!* where TCI_partida = '20150123-55705' and TCI_utilizado > 0 group by TCI_gtin, TCI_lote, TCI_serie

