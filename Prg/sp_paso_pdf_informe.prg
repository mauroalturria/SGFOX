Parameters tcNroVale, tcRuta, tbAnulaAnt
Clear

If Pcount()=0
	tcNroVale = '31459309'
	tcNroVale = '029561298'
	
	tcRuta = '\\debian\PUBLIC\NICO (NO BORRAR)\ecg\Temp\'
	tcRuta = "c:\desaguemes\Exe\temp\" 
Endif 	

lnNroVale = Int(Val(tcNroVale))
lcNroVale = Transform(lnNroVale)

lcRutaSal = Addbs(Addbs(tcRuta) + "Salida")

Public laArchi
Declare laArchi[100,5]

lcDirF = tcRuta + "*_" + lcNroVale + "*.pdf"

lnCant = Adir(laArchi,lcDirF)

If lnCant = 0
	Messagebox("NO EXISTE EL PDF",64,"AVISO DEL SISTEMA")
	Return .f.
Endif 

Wait Window "CONECTANDO CON EL SERVIDOR..." Nowait 

do sp_conexion 

Wait Window "PROCESANDO..." Nowait 


Do While .t.
	If tbAnulaAnt
		Wait Window "ANULANDO ANTERIORES..." Nowait 
		Text To lcsql Textmerge Noshow Pretext 7
			Update informes Set EstadoInforme = 5 Where nrovale = ?lnNroVale And TipoArch = 'PDF'
		Endtext 
		
		If !Prg_EjecutoSql(lcSql,"mwkUpd")
			exit
		Endif  
	Endif 	
	*!*------------------------------------------------------------------------------------------------------------------------------
	Wait Window "BUSCANDO DATOS DEL VALE..." Nowait 
 	Text To lcsql Textmerge Noshow Pretext 7
		Select * From ValesAsist Where Val_CodValeAsist = ?lnNroVale 
	Endtext 

	If !Prg_EjecutoSql(lcSql,"mwkVale")
		exit
	Endif  
	*!*------------------------------------------------------------------------------------------------------------------------------
	Wait Window "BUSCANDO PRESTACIONES DEL VALE..." Nowait 	
 	Text To lcsql Textmerge Noshow Pretext 7
		Select Top 1 * From PRESINSUVAS
		Where Pia_ValesAsist = ?mwkVale.Valesasist
		and pia_cantsolicitada > 0
		order by pia_secuen_carga
	Endtext 

	If !Prg_EjecutoSql(lcSql,"mwkPresin")
		exit
	Endif  
	*!*------------------------------------------------------------------------------------------------------------------------------
	Wait Window "BUSCANDO DATOS DEL PACIENTE..." Nowait 
 	Text To lcsql Textmerge Noshow Pretext 7
		Select * From Pacientes Where pac_CodAdmision = ?mwkVale.Val_CodAdmision
	Endtext 

	If !Prg_EjecutoSql(lcSql,"mwkPac")
		exit
	Endif  

	*!*------------------------------------------------------------------------------------------------------------------------------
 	If !Directory(lcRutaSal)
		Md (lcRutaSal)
	Endif 	
	*!*------------------------------------------------------------------------------------------------------------------------------
	mdiahoy = sp_busco_fecha_serv('DT') 

	mprest = mwkPresin.Pia_CodPrest
	mcodpun = mwkVale.Val_codpun
	sector  = mwkVale.val_codservvale
	nestado = 3
	cfecha  = mdiahoy 
	mmedico = Nvl(mwkVale.val_prestador,1)
	nprot   = mwkVale.val_NroProtocolo
	mnrovale = mwkVale.val_CodValeAsist
	cext = 'PDF'
	
	&& DATA.informe
	mitxt = ''
	Wait Window "GUARDANDO ARCHIVOS..." Nowait 
	
 	For lnArchi = 1 To lnCant
		?laArchi(lnArchi,1) 
		*!*------------------------------------------------------------------------------------------------------------------------------

		select 0
		create table "C:\temp\informes\informe01.dbf" free (informe M)
		select informe01
		append blank

		miinforme = ''
		cfile = tcRuta + laArchi(lnArchi,1)
		do prg_LoadBin with cfile,miinforme
		
		if !empty(miinforme )
			replace informe with miinforme
			use
			LL = fopen("C:\temp\informes\informe01.dbf",12)
			fseek(LL,43)
			fwrite(LL,'G')
			fclose(LL)
			use in 0 C:\temp\informes\informe01.dbf alias __DATA
		Endif 
				
		*lcFile = Filetostr(tcRuta + laArchi(lnArchi,1))

 		Text To lcsql Textmerge Noshow Pretext 7
			Insert into informes ( CodPrest , CodPun , 
				 CodServVale, EstadoInforme , FechaInforme , CodMedFirma,
				 NroProtocolo, NroVale, TipoArch, informePDF, InformeSoloTexto,
				 InformePDFGenerado, FechaAprobacion) 
				 values
				(?mprest, ?mcodpun, ?sector, ?nestado, ?cfecha, ?mmedico,
				?nprot, ?mnrovale, ?cext, ?__DATA.informe , ?mitxt,
				1, ?mdiahoy)
		Endtext 
				 
		If !Prg_EjecutoSql(lcSql,"mwk")
			Exit 
		Endif   
		*!*------------------------------------------------------------------------------------------------------------------------------
 	
		Rename (tcRuta + laArchi(lnArchi,1)) To (lcRutaSal + laArchi(lnArchi,1))
	Next 
	Wait Window "FIN..." Nowait 
	
	Exit 
Enddo 

DO sp_desconexion WITH "PASANDO PDF"
	 
Use In Select("mwkVale") 
Use In Select("mwkPac") 
