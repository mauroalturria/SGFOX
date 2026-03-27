*
* Consulta de Partes Quirurgicos fechas desde / hasta
*
parameters mfecdes, mfechas,mbusco

if used('mwkservicios')
	use in mwkservicios
endif
if used("mwkpquir")
	use in mwkpquir
endif
if used("mwkpquir00")
	use in mwkpquir00
endif
if used("mwkpacint01")
	use in mwkpacint01
endif
if used("mwkpacint02")
	use in mwkpacint02
endif
if used("mwkpacin")
	use in mwkpacin
endif
if vartype(mbusco)#"C"
	mbusco = ''
endif
mfecdesInt = mfecdes - 1
mfechasint = mfechas +1

mret = sqlexec(mcon1,"select * from servicios","mwkservicios")
if mret < 0
	messagebox("EN CONSULTA DE SERVICIOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
else
	mret = sqlexec(mcon1, " SELECT tabquirofano.ID , Anestesista ,Ayudante as Instrumentista ,"+;
		" BiopsiaIntraOp , BiopsioDiferida , Cardiologo , CirujanoTE , Comentario , DuracEst , "+;
		" Edad , EstComen  , TabQuirofano.Estado , FechaQuirof , HemoComen , Hemoterapia , HoraEst , "+;
		" HoraEstDesp  , HoraFin,HoraIngre, HoraIngquirof ,HoraIndAnes ,HoraFinAnes ,HoraEgre , HoraInic , Instrumen as Ayudante ,  MateComen , Material , "+;
		" NroProtocolo  ,TabQuirofano.NroQuirofano , Nroregistrac , OperCod , Operacion , PacNombre , Rayos,"+;
		" quirofano ,descrip,codmed,cirujano,ent_descrient,diagnostico,ent_codent,descrip,laboratorio,"+;
		" AnestesiaTipo,MatInstancia, FechaInternac,AnestesistaCod,AnestesiaTipo,"+;
		" AyudanteCod as InstrumentistaCod,codent, HemoOk,MatCondicional,bpresta.Nombre as nomanest1, "+;
		" mateok,TabQuirofano.Telefono,torre,MateProvee,anestesistanom, REG_fecnacimiento,"+;
		" REG_nrohclinica,CamaSolic, CamaSector,verificado, ProgrOrigen, TipoPacte, Servicio, SER_descripserv, TabQuirofano.codesp "+;
		" FROM TabQuirofano "+;
		" left join tabprotquir on tabprotquir.quirofano = tabquirofano.id "+;
		" left join tabEstados on tabEstados.id = TabQuirofano.estado "+;
		" left join entidades on entidades.ENT_codent = TabQuirofano.codent "+;
		" left join servicios on servicios.ser_codserv = TabQuirofano.servicio "+;
		" left join prestadores bpresta on bpresta.ID = TabQuirofano.anestesistacod "+;
		" left outer join registracio on Registracio.REG_nroregistrac = TabQuirofano.Nroregistrac "+;
		" inner join tabquirosala on tabquirofano.nroquirofano = tabquirosala.id and TQS_Prog = 1 "+;
		" where FechaQuirof >= ?mfecdes And FechaQuirof < ?mfechasint "+mbusco,"mwkpquir00")

	if mret < 0
		messagebox("EN CONSULTA DE PARTE QUIRURGICO 1"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	else

		mbusco1 = " and FechaHoraQuir >= ?mfecdesint And FechaHoraQuir <= ?mfechasint "

		mret = sqlexec(mcon1, "select TabProtQuir.*,Pac_codhci,Pac_fechaadmision, Pac_horaadmision, "+;
			"Pac_descripdiagn, Pac_fechaalta ,Pac_horaalta " + ;
			"from TabProtQuir ,pacientes " + ;
			"where Codadmision = pac_codadmision "+ mbusco1 , "mwkpacint01")

		if mret < 0
			messagebox("EN CONSULTA DE PARTE QUIRURGICO 2"+chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		endif

		select *,ttod(fechahoraquir) as fechaquir,nvl(quirofano,0) as qui from mwkpacint01 ;
			order by qui into cursor mwkpacina

		select * from mwkpacina group by id into cursor mwkpacin
		
		do sp_busco_quiroaux with 1 ,"mwkauxinstrumen",mfecdes
		do sp_busco_quiroaux with 2 ,"mwkauxanestesis",mfecdes

		select mwkpquir00.*,mwkMedrpzt.nombre,mwkMedrpzt.codesp as codespP,mwkauxinstrumen.descripcion as nominstrumen,;
			padr(iif(mwkpquir00.anestesista = 1,'',iif(mwkpquir00.anestesista = 2,;
			nvl(mwkpquir00.nomanest1,''),nvl(mwkpquir00.anestesistanom,''))) ,50) as nomanestesis, ;
			codadmision,Pac_codhci, Pac_fechaadmision, Pac_horaadmision, Pac_descripdiagn, Pac_fechaalta ,Pac_horaalta  ;
			from mwkpquir00 ;
			left join mwkMedrpzt on mwkMedrpzt.id = mwkpquir00.codmed ;
			left join mwkauxinstrumen on mwkauxinstrumen.id = InstrumentistaCod;			
			left join mwkpacin on mwkpacin.quirofano = mwkpquir00.id ;
			group by mwkpquir00.id into cursor mwkpquir   &&mwkpquir_adm
			
			**left join mwkauxinstrumen on mwkauxinstrumen.id = InstrumentistaCod;

*!*			select * from mwkpquir_adm where isnull(pac_codhci) and id in (select id from mwkpquir_nro where !isnull(pac_codhci) );
*!*				union all;
*!*				select * from mwkpquir_adm where isnull(pac_codhci) and id not in (select id from mwkpquir_nro where !isnull(pac_codhci) );
*!*				union all;
*!*				select * from mwkpquir_adm where !isnull(pac_codhci) ;
*!*				into cursor mwkpquir

	endif
endif
