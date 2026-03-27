parameters tnOpcion, tnId, tnCodPrest, tnCodPun, tnCodServVale, tnEstadoInforme , tdFechaInforme , tnCodMedFirma , ;
			 tnNroProtocolo , tnNroVale , tcTipoArch, tcInformeSoloTexto, ;
			 tnInformePDFGenerado, twinforme, tdFechaAprobacion, tdFechaRecepcion, ttFechaHoraEstudio




*!*	&& TEST NRO 1
*!*	tnOpcion = 1
*!*	tnId = 1
*!*	tnCodPrest = 2969
*!*	tnCodPun = 23420742
*!*	tnCodServVale = 7700
*!*	tnEstadoInforme = 5
*!*	tdFechaInforme = Date()
*!*	tnCodMedFirma = 1
*!*	tnNroProtocolo = 1
*!*	tnNroVale = 1
*!*	tcTipoArch = "jpg"
*!*	tcInformeSoloTexto = ''
*!*	tnInformePDFGenerado = 0
*!*	tdFechaAprobacion = Date()
*!*	tdFechaRecepcion = Date()
*!*	ttFechaHoraEstudio = Date()
*!*	ldFecnull = Ctod("01/01/1900")
*!*	twinforme = "?CIMA.DDDD" && ANDA
*!*	twinforme = ""
*!*	*!*	*!*	twinforme = Filetostr("c:\desaguemes\Bmp\0.jpg") && NO
*!*	*!*	*!*	twinforme = CIMA.DDDD && NO

Do Case
	Case tnOpcion = 1

		Text To lcSql Textmerge Noshow Pretext 7

				insert into informes ( CodPrest , CodPun ,  CodServVale,
					 EstadoInforme , FechaInforme , CodMedFirma ,
					 NroProtocolo , NroVale , TipoArch, InformeSoloTexto,
					 InformePDFGenerado, FechaAprobacion, FechaRecepcion, FechaHoraEstudio, informe )
				 values (?tnCodPrest, ?tnCodPun, ?tnCodServVale,
					 ?tnEstadoInforme , ?tdFechaInforme , ?tnCodMedFirma ,
					?tnNroProtocolo , ?tnNroVale , ?tcTipoArch, ?tcInformeSoloTexto,
					?tnInformePDFGenerado, ?tdFechaAprobacion, ?tdFechaRecepcion, ?ttFechaHoraEstudio, <<twinforme>>)

		Endtext 

	Case tnOpcion = 2

		Text To lcSql Textmerge Noshow Pretext 7

				Update informes Set 
					CodPrest = ?tnCodPrest , 
					CodPun = ?tnCodPun,   
					CodServVale = ?tnCodServVale,
					EstadoInforme = ?tnEstadoInforme, 
					FechaInforme = ?tdFechaInforme, 
					CodMedFirma = ?tnCodMedFirma,
					NroProtocolo = ?tnNroProtocolo, 
					NroVale = ?tnNroVale, 
					TipoArch = ?tcTipoArch, 
					InformeSoloTexto = ?tcInformeSoloTexto,
					InformePDFGenerado = ?tnInformePDFGenerado, 
					FechaAprobacion = ?tdFechaAprobacion, 
					FechaRecepcion = ?tdFechaRecepcion, 
					FechaHoraEstudio = ?ttFechaHoraEstudio, 
					informe = <<twinforme>> )
					Where Id = ?tnId

		Endtext 

	Case tnOpcion = 3 && anulacion
		tnEstadoInforme = 5
		
		Text To lcSql Textmerge Noshow Pretext 7
			Update informes Set 
				EstadoInforme = ?tnEstadoInforme 
				Where Id = ?tnId
		Endtext 		

Endcase


If !prg_ejecutosql(lcSql , "mwkAux", .T.)
	Return .F.
Endif
