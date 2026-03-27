*
* Actualización Partida, Insumos Trazados con anterioridad
*
Lparameters mlgtin, mlserie, mlote, mvence, mpartida

mret = sqlexec(mcon1,"update TabTramov set TTM_partida = ?mpartida"+;
	" where TTM_gtin = ?mlgtin "+;
	" and TTM_serie = ?mlserie "+;
	" and TTM_lote = ?mlote "+;
	" and TTM_vence = ?mvence")

If mret < 0
	=aerror(merror)
	Messagebox(merror(3))
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
