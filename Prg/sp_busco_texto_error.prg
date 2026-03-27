****
** Busto texto de error en validacion de vales
****

parameters mcoderror

	mret = sqlexec(mcon1, "select textoerror from taberrores where coderror = ?mcoderror", "mwktaberror")
	
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 16,"Validacion")
		do prg_cancelo
	endif
		