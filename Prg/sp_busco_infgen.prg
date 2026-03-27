*
* Busco Informes 
*
Parameters mOpcion, mfechad, mfechah

*!*	mOpcion = 1
*!*	mfechad = date()- 300*5
*!*	mfechah = date()
*!*	do sp_conexion

do case

	Case mOpcion = 1
*!*			 generados entre 2 fechas
		mret = sqlexec(mcon1, " select ID, CodMedFirma, CodPrest, CodPun, CodServVale, "+;
			"EstadoInforme, FechaAprobacion, FechaInforme, FechaRecepcion, "+;
			"InformePDFGenerado, NroProtocolo, NroVale, TipoArch "+;
			"from informes "+;
			"where EstadoInforme < 5 and  FechaAprobacion is not null and " + ;
			"FechaInforme >= ?mfechad and FechaInforme < ?mfechah " + ;
			" "  ,"mwkValeInfGen")  &&InformePDFGenerado = 1

EndCase

If mret < 0
	Messagebox("EN CONSULTA DE INFORMES",48,"VALIDACION")
	Cancel 
Endif
