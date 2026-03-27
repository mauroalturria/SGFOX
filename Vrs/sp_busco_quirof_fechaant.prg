*
* Consulta de Partes Quirurgicos fechas desde / hasta
*
Parameters mfecdes, mfechas

If used('mwkservicios')
	Use in mwkservicios
Endif
If used("mwkpquir")
	Use in mwkpquir
Endif
If used("mwkpquir00")
	Use in mwkpquir00
Endif
If used("mwkpacint01")
	Use in mwkpacint01
Endif
If used("mwkpacint02")
	Use in mwkpacint02
Endif
If used("mwkpacin")
	Use in mwkpacin
Endif

mret = sqlexec(mcon1,"select * from servicios","mwkservicios")

If mret < 0
	Messagebox("EN CONSULTA DE SERVICIOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Else
	mret = sqlexec(mcon1, " SELECT tabquirofano.ID , Anestesista ,Ayudante as Instrumentista ,"+;
		" BiopsiaIntraOp , BiopsioDiferida , Cardiologo , CirujanoTE , Comentario , DuracEst , "+;
		" Edad , EstComen  , TabQuirofano.Estado , FechaQuirof , HemoComen , Hemoterapia , HoraEst , "+;
		" HoraEstDesp  , HoraFin , HoraInic , Instrumen as Ayudante ,  MateComen , Material , "+;
		" NroProtocolo  , NroQuirofano , Nroregistrac , OperCod , Operacion , PacNombre , Rayos,"+;
		" quirofano ,descrip,codmed,cirujano,ent_descrient,diagnostico,ent_codent,descrip,laboratorio,"+;
		" AnestesiaTipo,MatInstancia, FechaInternac,AnestesistaCod,AnestesiaTipo,"+;
		" AyudanteCod as InstrumentistaCod,codent, HemoOk,MatCondicional, "+;
		" mateok,TabQuirofano.Telefono,torre,MateProvee,prestadores.nombre,anestesistanom, "+;
		" CamaSolic, CamaSector, ProgrOrigen, TipoPacte, Servicio, SER_descripserv "+;
		" FROM TabQuirofano "+;
		" left join tabprotquir on tabprotquir.quirofano = tabquirofano.id "+;
		" left join tabEstados on tabEstados.id = TabQuirofano.estado "+;
		" left join prestadores on prestadores.id = TabQuirofano.codmed "+;
		" left join entidades on entidades.ENT_codent = TabQuirofano.codent "+;
		" left join servicios on servicios.ser_codserv = TabQuirofano.servicio "+;
		" where FechaQuirof >= ?mfecdes And FechaQuirof <= ?mfechas ","mwkpquir00")

	If mret < 0
		Messagebox("EN CONSULTA DE PARTE QUIRURGICO 1"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Else

		mbusco1 = " and pac_fechaadmision >= ?mfecdes  and pac_fechaadmision <= ?mfechas "

		mret = sqlexec(mcon1, "select " + ;
			"TabProtQuir.*,Pacientes.Pac_codhci " + ;
			"from TabProtQuir ,pacientes " + ;
			"where pac_codadmision = Codadmision and TipoPac = 1"+ mbusco1 , "mwkpacint01")

		If mret < 0
			Messagebox("EN CONSULTA DE PARTE QUIRURGICO 2"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")			
		Endif

		mbusco2 = " and FechaHoraQuir >= ?mfecdes And FechaHoraQuir <= ?mfechas "

		mret = sqlexec(mcon1, "select TabProtQuir.*, Pac_codhci" + ;
			" From TabProtQuir " + ;
			" Inner Join histambgua on histambgua.his_codadmision = TabProtQuir.Codadmision " + ;
			" Inner Join Pacientes on Pacientes.PAC_codhci = histambgua.his_nroregistrac " + ;
			" and PAC_codadmision = TabProtQuir.Codadmision " + ;
			" Where Tabprotquir.TipoPac = 2 &mbusco2 " , "mwkpacint02")
			
		If mret < 0
			Messagebox("EN CONSULTA DE PARTE QUIRURGICO 3"+chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
			Return
		Endif

		Select * from mwkpacint01 union all select * from mwkpacint02 into cursor mwkpacin

		Do sp_busco_quiroaux with 1 ,"mwkauxinstrumen"
		Do sp_busco_quiroaux with 2 ,"mwkauxanestesis"

		Select mwkpquir00.*,mwkauxinstrumen.descripcion as nominstrumen;
			, mwkauxanestesis.descripcion as nomanestesis,Pac_codhci ;
			from mwkpquir00 ;
			left join mwkauxinstrumen on mwkauxinstrumen.id = InstrumentistaCod;
			left join mwkauxinstrumen on mwkauxinstrumen.id = InstrumentistaCod;
			left join mwkpacin on mwkpacin.Pac_codhci = Nroregistrac;
			into cursor mwkpquir
	Endif
Endif
