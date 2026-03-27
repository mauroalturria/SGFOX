****
** busco internados
****
Parameters madmi, mcursor,mbuscapac
If Vartype(mcursor)#"C"
	mcursor ="mwkpacact"
Endif
If Vartype(madmi)#"C"
	madmi = ''
Endif

If Vartype(mbuscapac)#"C"
	mbuscapac = ' where 1= 1 '
Endif
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = 	" and TSA_Sector  in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) "
Endif

If !Empty(madmi)
	Use In Select("mwkSecagrupnew")
	mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,TSA_Agrupa "+ ;
		",TSA_FechaDesde,TSA_FechaHasta "+;
		" FROM Tabagrup, Tabsecagrup WHERE TSA_Agrupa = Tabagrup.ID"+mwcm+;
		" AND TSA_Tipo = 5 ORDER BY sector, TSA_FechaHasta ", "mwkSecagrupnew")
	mwcm = Strtran(mwcm,"TSA_Sector","PAC_sectorinternac")
	mret = SQLExec(mcon1, "select PAC_nombrepaciente, PAC_edad, PAC_sectorinternac , " + ;
		"PAC_habitacion, PAC_cama, PAC_codadmision, PAC_categoria,PAC_fechaadmision, PAC_fechaalta, PAC_motivoadmision " + ;
		"from pacientes " +mbuscapac+;
		" and PAC_codadmision = ?madmi " +mwcm, mcursor )
Else
	If At("where",mbuscapac)=0
		mbuscapac = " where 1=1 "+mbuscapac
	ENDIF
	
	mwcm = Strtran(mwcm,"TSA_Sector","PAC_sectorinternac")
	
	mret = SQLExec(mcon1, "select PAC_nombrepaciente, PAC_edad, PAC_sectorinternac , pac_codhci,  pac_codhce, " + ;
		"PAC_habitacion, PAC_cama, PAC_codadmision, PAC_categoria,PAC_fechaadmision, PAC_fechaalta, PAC_motivoadmision " + ;
		"from pacientes " +;
		" inner join pacinternad on pin_codadmision  = pacientes.pac_codadmision " +mbuscapac +mwcm, mcursor )
Endif

If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif



