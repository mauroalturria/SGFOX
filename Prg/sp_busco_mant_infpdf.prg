*
* Control de Informes Confirmados sin PDF generado
*

If used('mwkValeInf')
	Use in mwkValeInf
Endif

mret = sqlexec(mcon1, " select ID , CodMedFirma , CodPrest , CodPun , CodServVale , "+;
	" EstadoInforme , FechaAprobacion , FechaInforme , FechaRecepcion , "+;
	" InformePDFGenerado ,NroProtocolo , NroVale , TipoArch "+;
	" from informes "+;
	" where EstadoInforme <= 3 AND  FechaAprobacion is not null and TipoArch not in ('WAV','TXT')"+;
	" and InformePDFGenerado = 0 ","mwkValeInf")

If mret < 0
	Messagebox("EN CONSULTA DE INFORMES",48,"Validació")
Endif
