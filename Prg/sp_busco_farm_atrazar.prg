*
* Detalle de Registros en cola de trazabilidad evento 849 u otros
*
Lparameters mcod, meven, mwhere

Use in select("mwkatrazar")

mret = sqlexec(mcon1,"select TabTramov.id as lid, TTM_gtin,TGT_inscod,TTM_serie,TTM_lote,TTM_vence,TTM_fechorini,"+;
    " TTM_fechorfin,TTM_transerr,TTM_transtxte,TGT_des, TGT_inscod, TGT_rsoc"+;
    " from TabTramov"+;
	" Join TabTraGTIN on TGT_gtin = TabTramov.TTM_gtin "+;
	" where TTM_evento = ?mcod"+;
	" and TTM_tipomov = ?meven &mwhere group by TTM_gtin, TTM_serie","mwkatrazar")

If mret < 0
	MTABLA = "TRAZABILIDAD MOVIMIENTOS"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
