*
* Esquema de Farmacia, grabación
*
parameters mform
with mform
	dimension vdat[4]
	vdat[1] = .txtpresta.value
	vdat[2] = .txtesquema.value
	vdat[3] = mwkformulas.subestado
	vdat[4] = .chkprequi.value
	mlbusid = .qid

	if .qtipo = "A"
		use in select("mwkdatos")
		mret = sqlexec(mcon1,"select id as lid from TabFarmEsq where TFE_codprest=?vdat[1]","mwkdatos")
		if mret < 0
			messagebox("EN ACTUALIZACION DE ESQUEMAS FARMACIA",16,"ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
			return .f.
		endif
		if used("mwkdatos")
			if reccount("mwkdatos")>0
				mlbusid = mwkdatos.lid
			endif
		endif
		use in select("mwkdatos")
	endif

	if mlbusid > 0
		mret = sqlexec(mcon1,"update TabFarmEsq set"+;
			" TFE_codprest    = ?vdat[1],"+;
			" TFE_esquema     = ?vdat[2],"+;
			" TFE_formula     = ?vdat[3],"+;
			" TFE_prequimio   = ?vdat[4],"+;
			" TFE_fechapasiva = NULL "+;
			" where id = ?mlbusid")
	else
		mret = sqlexec(mcon1,"insert into TabFarmEsq"+;
			"(TFE_codprest,TFE_esquema,TFE_formula,TFE_prequimio,TFE_fechapasiva)"+;
			" values "+;
			"(?vdat[1],?vdat[2],?vdat[3],?vdat[4],NULL)")
	endif

	release vdat
	if mret < 0
		messagebox("EN ACTUALIZACION DE ESQUEMAS FARMACIA",16,"ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
		return .f.
	endif

endwith
return .t.
