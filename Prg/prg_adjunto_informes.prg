Parameters mPrest, mCodPun, msector, mmedico, mnprot , mnrovale    

Private mcFila, mcExt
Store "" To mcExt, mcFila

mcFila = Getfile("","Seleccione un Archivo")

If Empty(mcFila)
	Return .F.
Endif

mcExt = Justext(mcFila)
mcName = Juststem(mcFila)
mcDir = Addbs(Justpath(mcFila))


*!*	?mcFila
*!*	?mcExt
*!*	?mcName
*!*	?mcDir
*!*------------------------------------------------------------------------------------------------------------------------------
mdiahoy = sp_busco_fecha_serv('DT')
mnestado = 3
mitxt = ""
*!*	mprest = mwkPresin.Pia_CodPrest
*!*	mcodpun = mwkVale.Val_codpun
*!*	msector  = mwkVale.val_codservvale
*!*	mmedico = Nvl(mwkVale.val_prestador,1)
*!*	mnprot   = mwkVale.val_NroProtocolo
*!*	mnrovale = mwkVale.val_CodValeAsist
*!*------------------------------------------------------------------------------------------------------------------------------

Select 0
Create Table "C:\temp\informes\Adjunto01.dbf" Free (informe M)
Select Adjunto01
Append Blank

miinforme = ''
cfile = mcDir + mcName + "." + mcExt
Do prg_LoadBin With cfile,miinforme

If !Empty(miinforme)
	Replace informe With miinforme
	Use
	LL = Fopen("C:\temp\informes\Adjunto01.dbf",12)
	Fseek(LL,43)
	Fwrite(LL,'G')
	Fclose(LL)
	Use In 0 C:\temp\informes\Adjunto01.Dbf Alias __DATA
Endif

If mcExt = "PDF"
	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into informes ( CodPrest , CodPun ,
			 CodServVale, EstadoInforme , FechaInforme , CodMedFirma,
			 NroProtocolo, NroVale, TipoArch, informePDF, InformeSoloTexto,
			 InformePDFGenerado, FechaAprobacion)
			 values
			(?mprest, ?mcodpun, ?msector, ?mnestado, ?mdiahoy , ?mmedico,
			?mnprot, ?mnrovale, ?mcExt, ?__DATA.informe , ?mitxt,
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
			?mnprot, ?mnrovale, ?mcExt, ?__DATA.informe , ?mitxt,
			0, ?mdiahoy)
	ENDTEXT
Endif 

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
Endif

Use In Select("__DATA")

If File("C:\temp\informes\Adjunto01.dbf")
	Delete File ("C:\temp\informes\Adjunto01.dbf")
	Delete File ("C:\temp\informes\Adjunto01.FPT")
Endif 	
	
Messagebox("FIN DEL PROCESO !!!",64,"AVISO")
