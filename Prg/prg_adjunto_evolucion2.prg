Parameters mcFile,mPrest, mCodPun, msector, mmedico, mnprot , mnrovale

* Este es el PRG original de Car pero modificado para obtener el PDF - 2026-06-03

mcFila = mcFile
mcExt = "PDF"
mdiahoy = sp_busco_fecha_serv('DT')
mnestado = 3
mitxt = ""

*!*------------------------------------------------------------------------------------------------------------------------------
*!*	mprest = mwkPresin.Pia_CodPrest
*!*	mcodpun = mwkVale.Val_codpun
*!*	msector  = mwkVale.val_codservvale
*!*	mmedico = Nvl(mwkVale.val_prestador,1)
*!*	mnprot   = mwkVale.val_NroProtocolo
*!*	mnrovale = mwkVale.val_CodValeAsist
*!*------------------------------------------------------------------------------------------------------------------------------

lcInforme = ""

lcInforme = sp_img2pdf (mcFila)
 
If Empty(lcInforme)
	Messagebox("No se pudo realizar la conversión. Comuniquese con Mesa de Ayuda",48,"Error de Conversión")
	Return .F.
Else
	If mcExt = "PDF"
		TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into informes ( CodPrest , CodPun ,
			 CodServVale, EstadoInforme , FechaInforme , CodMedFirma,
			 NroProtocolo, NroVale, TipoArch, informePDF, InformeSoloTexto,
			 InformePDFGenerado, FechaAprobacion)
			 values
			(?mprest, ?mcodpun, ?msector, ?mnestado, ?mdiahoy , ?mmedico,
			?mnprot, ?mnrovale, ?mcExt, ?lcInforme , ?mitxt,
			1, ?mdiahoy)
		ENDTEXT
	Else
		TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into informes ( CodPrest , CodPun ,
			 CodServVale, EstadoInforme , FechaInforme , CodMedFirma,
			 NroProtocolo, NroVale, TipoArch, informe, InformeSoloTexto,
			 InformePDFGenerado, FechaAprobacion)
			 values
			(?mprest, ?mcodpun, ?msector, ?mnestado, ?mdiahoy , ?mmedico,
			?mnprot, ?mnrovale, ?mcExt, ?lcInforme , ?mitxt,
			0, ?mdiahoy)
		ENDTEXT
	Endif
	If !Prg_EjecutoSql(lcSql,"mwk")
		Messagebox("ERROR AL GUARDAR",16,"ERROR")
		Return .F.
	Endif
Endif

Messagebox("FIN DEL PROCESO !!!",64,"AVISO")
Return .F.

