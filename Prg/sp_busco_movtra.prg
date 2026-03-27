*
* Busqueda de Insumos, trazados para control con fuera de pendientes
*
Use in select("mwkltrazado")

mret = sqlexec(mcon1,"select TTM_gtin,TTM_serie,TTM_transcod"+;
	" from TabTraMov"+;
	" where TTM_transcod > 0", "mwkltrazado")

If mret < 0
	MTABLA = "MOVIMIENTOS TRAZADOS"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
