****
** Actualizo nro de registracio en ambulatorio por pasaje de consumos o unificacion
***

Parameter nroregistra, newregistra, mfecdesp, mfechas

If Type ('mfecdesp') = "C" Or Vartype(mfecdesp) ="T"
	mret = prg_ejecutosql1("select protocolo from tabambulatorio " + ;
		"where nroregistrac = ?nroregistra" + ;
		" and fechahoraing>=?mfecdesp "+;
		" and fechahoraing<?mfechas ","mwknewreg" )
	mret = prg_ejecutosql1("update tabambulatorio set nroregistrac = ?newregistra " + ;
		"where nroregistrac = ?nroregistra" + ;
		" and fechahoraing>=?mfecdesp "+;
		" and fechahoraing<?mfechas ")
	Select mwknewreg
	Scan
		miprot = protocolo
		mret = prg_ejecutosql1("update Tabambevol set EA_nroregistrac = ?newregistra " + ;
			"where EA_nroregistrac = ?nroregistra and EA_protocolo = ?miprot ")
		mret = prg_ejecutosql1("update Tabautprevias set APV_Registracio = ?newregistra " + ;
			"where APV_Protocolo = ?miprot ")
	Endscan
Else
	mret = prg_ejecutosql1("update tabambulatorio set nroregistrac = ?newregistra " + ;
		"where nroregistrac = ?nroregistra")

	mret = prg_ejecutosql1("update Tabambevol set EA_nroregistrac = ?newregistra " + ;
		"where EA_nroregistrac = ?nroregistra")

	mret = prg_ejecutosql1("update Tabambgestserologia  set SN_Registracio = ?newregistra " + ;
		"where SN_Registracio = ?nroregistra")

	mret = prg_ejecutosql1("update Tabambgesta set TAG_nroregis = ?newregistra " + ;
		"where TAG_nroregis = ?nroregistra")

	mret = prg_ejecutosql1("update Tabantecpac set AT_registracio = ?newregistra " + ;
		"where AT_registracio = ?nroregistra")

	mret = prg_ejecutosql1("update Tabautprevias set APV_Registracio = ?newregistra " + ;
		"where APV_Registracio = ?nroregistra")

	If mret < 0
		Messagebox('EN ACTUALIZACION DE MAESTROS - Unificacion -',0,'ERROR')
	Endif
Endif
**** idem para historico
If Type ('mfecdesp') = "C" Or Vartype(mfecdesp) ="T"
	mret = prg_ejecutosql1("select protocolo from tabambulatoriohis " + ;
		"where nroregistrac = ?nroregistra" + ;
		" and fechahoraing>=?mfecdesp "+;
		" and fechahoraing<?mfechas ","mwknewreg" )
	mret = prg_ejecutosql1("update tabambulatoriohis set nroregistrac = ?newregistra " + ;
		"where nroregistrac = ?nroregistra" + ;
		" and fechahoraing>=?mfecdesp "+;
		" and fechahoraing<?mfechas ")
	Select mwknewreg
	Scan
		miprot = protocolo
		mret = prg_ejecutosql1("update Tabambevolhis set EA_nroregistrac = ?newregistra " + ;
			"where EA_nroregistrac = ?nroregistra and EA_protocolo = ?miprot ")
		mret = prg_ejecutosql1("update Tabautprevias set APV_Registracio = ?newregistra " + ;
			"where APV_Protocolo = ?miprot ")
	Endscan
Else
	mret = prg_ejecutosql1("update tabambulatoriohis set nroregistrac = ?newregistra " + ;
		"where nroregistrac = ?nroregistra")

	mret = prg_ejecutosql1("update Tabambevolhis set EA_nroregistrac = ?newregistra " + ;
		"where EA_nroregistrac = ?nroregistra")

	If mret < 0
		Messagebox('EN ACTUALIZACION DE MAESTROS - Unificacion -',0,'ERROR')
	Endif
Endif

*** Tabla TabRelReg (2017/09/20)

mret = prg_ejecutosql1("update TabRelReg set TRR_RegDest = ?newregistra where TRR_RegDest = ?nroregistra")
If mret<0
	=Aerror(eros)
	Messagebox("Error en la Unificación (RelReg)",48,"Unificación de Historias Clínicas")
Endif

mret = prg_ejecutosql1("update TabRelReg set TRR_RegOrig = ?newregistra where TRR_RegOrig = ?nroregistra")
If mret<0
	=Aerror(eros)
	Messagebox("Error en la Unificación (RelReg)",48,"Unificación de Historias Clínicas")
Endif

*** Tablas de Neo

mret = prg_ejecutosql1("update ZabNeoIEAbdomen set ABD_nroregistraRN  = ?newregistra " + ;
	"where ABD_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIEAbdomen , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIEAntro set ANT_nroregistraRN  = ?newregistra " + ;
	"where ANT_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIEAntro, AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIEAspecto set ASP_nroregistraRN  = ?newregistra " + ;
	"where ASP_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIEAspecto, AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIEHemato set HEM_nroregistraRN= ?newregistra " + ;
	"where HEM_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIEHemato, AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIEInfecto set INF_nroregistraRN = ?newregistra " + ;
	"where INF_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIEInfecto, AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIEMalforma set MAL_nroregistraRN = ?newregistra " + ;
	"where MAL_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIEMalforma , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIEMetabolico set MET_nroregistraRN = ?newregistra " + ;
	"where MET_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIEMetabolico , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIENeuro set NEU_nroregistraRN = ?newregistra " + ;
	"where NEU_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIENeuro , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIENutri  set NUT_nroregistraRN = ?newregistra " + ;
	"where NUT_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIENutri  , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIEOseo set OSE_nroregistraRN = ?newregistra " + ;
	"where OSE_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIEOseo , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIEPiel set PIE_nroregistraRN = ?newregistra " + ;
	"where PIE_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIEPiel , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIEQuiro set QUI_nroregistraRN = ?newregistra " + ;
	"where QUI_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIEQuiro , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update ZabNeoIERespira set RES_nroregistraRN = ?newregistra " + ;
	"where RES_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR ZabNeoIERespira , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update  ZabNeoVarios set VAR_nroregistraRN = ?newregistra " + ;
	"where VAR_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR  ZabNeoVarios , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update  ZabNeoAntecApgar set NAA_registracioRN = ?newregistra " + ;
	"where NAA_registracioRN = ?nroregistra")

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR  ZabNeoAntecApgar , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update  ZabNeoAntecDatosParto set NDP_nroregistraRN = ?newregistra " + ;
	"where NDP_nroregistraRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR  ZabNeoAntecDatosParto , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update  ZabNeoAntecMatCom set AMC_registracioRN = ?newregistra " + ;
	"where AMC_registracioRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR  ZabNeoAntecMatCom , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update  ZabNeoAntecMatMed set AMM_registacionRN = ?newregistra " + ;
	"where AMM_registacionRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR  ZabNeoAntecMatMed , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update  ZabNeoAntecMatPlus set AMP_registacionRN = ?newregistra " + ;
	"where AMP_registacionRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR  ZabNeoAntecMatPlus , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update  ZabNeoAntecMaterno set NAM_registracioRN = ?newregistra " + ;
	"where NAM_registracioRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR  ZabNeoAntecMaterno , AVISAR A SISTEMAS",16, "Validacion")
Endif


mret = prg_ejecutosql1("update  ZabNeoAntecNacimiento set NAN_registracioRN = ?newregistra " + ;
	"where NAN_registracioRN = ?nroregistra")
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR AL ACTUALIZAR  ZabNeoAntecNacimiento , AVISAR A SISTEMAS",16, "Validacion")
Endif