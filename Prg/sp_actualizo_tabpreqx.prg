Parameters tnOpcion, tnId,ccampos, mervicio ,mcomplejidad,mdiagnostico,mcodPrest,mapto ,mvacATT ,mconsInfEntrega ,manestesiaTipo ,;
	mdiagnostico ,xxalgo,mservicio ,mduracEst ,mfechaProg,mhoraEst,mtipoPac ,mconsInfFirma ,;
	mcamaSolic ,mcamaSector ,mbiopsiaIntraOp ,mlaboratorio ,mrayos ,mtorre ,mhemoterapia ,;
	mmaterial,mvacATT,mcodmed,mcoddiag,mcodent ,mestado,mfecPasiva ,mfechaQuiro,mregistracio ,mhemoDadores ,  mhemoGF  ,;
	mmateOK ,mhemoOK ,mestadogap,maisla,matestado,mhemounidades,mestadoACCX,mcdist,mAleLatex,msolclinico,mreqPreQX ,mdeposito,mcm,mcentrocx
If Vartype(mcdist)#"C"
	mcdist = Alltrim(Substr(myip,7))
Endif
If Vartype(msolclinico )#"N"
	msolclinico  = 0
Endif
If Vartype(mreqPreQX)#"N"
	mreqPreQX = 0
Endif

If Vartype(mcentrocx)#"N"
	mcentrocx= 0
Endif
If Vartype(mcm)#"N"
	mcm = 0
Endif
cactCM =''
If mcm >0
	cactCM =' ,PQ_deposito = ?mdeposito '
Endif

If Vartype(mdeposito )#"N"
	mdeposito = 0
Endif
tnfechah = sp_busco_fecha_serv("DT")
mfecnul= Ctod("01/01/1900")
tnpasivado = tnfechah
mgap= Nvl(mestadogap,1)
Do Case
Case tnOpcion = 1
	lcSql = "Insert into TabPQX  " + ;
		" (PQ_anestesiaTipo , PQ_apto , PQ_biopsiaIntraOp , PQ_camaSector , PQ_camaSolic , PQ_codPrest "+;
		", PQ_coddiag , PQ_codent , PQ_codmed , PQ_complejidad , PQ_consInfEntrega , PQ_consInfFirma "+;
		", PQ_duracEst , PQ_estado , PQ_fecPasiva , PQ_fechaProg , PQ_fechaQuiro , PQ_hemoDadores , PQ_hemoGF "+;
		",  PQ_hemoterapia , PQ_horaEst , PQ_laboratorio , PQ_mateOK , PQ_material , PQ_rayos "+;
		", PQ_registracio , PQ_servicio , PQ_tipoPac , PQ_torre , PQ_vacATT,PQ_estadoGAP,PQ_aislaInfecto,PQ_codambito"+;
		",PQ_hemoOk,PQ_hemounidades,PQ_alergiaLatex,UserDbUpd,PQ_solclinico,PQ_reqPreQX,pq_deposito, PQ_CMcirugia)"+;
		" Values " + ;
		" (?manestesiaTipo ,?mapto ,?mbiopsiaIntraOp ,?mcamaSector ,?mcamaSolic ,?mcodPrest "+;
		",?mcoddiag ,?mcodent ,?mcodmed ,?mcomplejidad ,?mconsInfEntrega ,?mconsInfFirma "+;
		",?mduracEst ,?mestado ,?mfecPasiva ,?mfechaProg ,?mfechaQuiro ,?mhemoDadores ,?mhemoGF "+;
		",?mhemoterapia ,?mhoraEst ,?mlaboratorio ,?mmateOK ,?mmaterial ,?mrayos "+;
		",?mregistracio ,?mservicio ,?mtipoPac ,?mtorre ,?mvacATT ,?mgap,?maisla,?mxambito"+;
		",?mhemoOK,?mhemounidades,?mAleLatex,?mcdist,?msolclinico,?mreqPreQX ,?mdeposito,?mcentrocx )"

Case tnOpcion = 2
***esto no existe
	lcSql = "Update TabPQX   " + ;
		" Set IF_admision = ?tnadmision , IF_codmed = ?Mcodmed , IF_observa = ?tnobserva , "+;
		" IF_pasivado  = ?mfecnul " + ;
		" Where id = ?tnId "
Case tnOpcion = 3
	lcSql = "Insert into ZabPQXLog  " + ;
		" (idpqx , PQ_aislaInfecto ,PQ_alergiaLatex, PQ_anestesiaTipo , PQ_apto , PQ_biopsiaIntraOp , PQ_camaSector , "+;
		" PQ_camaSolic , PQ_codPrest , PQ_codambito , PQ_codent , PQ_complejidad , PQ_consInfEntrega , "+;
		" PQ_consInfFirma , pq_deposito, PQ_CMcirugia , PQ_duracEst , PQ_estado , PQ_estadoACCX , PQ_estadoGAP , "+;
		" PQ_fechaProg , PQ_fechaQuiro , PQ_hemoDadores , PQ_hemoGF , PQ_hemoOK , PQ_hemoUnidades , "+;
		" PQ_hemoterapia , PQ_horaEst , PQ_laboratorio , PQ_mateEstado , PQ_mateOK , PQ_material , "+;
		" PQ_presuEstado , PQ_rayos , PQ_servicio , PQ_tipoPac , PQ_torre , PQ_vacATT , PQ_verifDatos,idmedact,PQ_CMcirugia)"+;
		" select ID, PQ_aislaInfecto ,PQ_alergiaLatex, PQ_anestesiaTipo , PQ_apto , PQ_biopsiaIntraOp , PQ_camaSector , "+;
		" PQ_camaSolic , PQ_codPrest , PQ_codambito , PQ_codent , PQ_complejidad , PQ_consInfEntrega , "+;
		" PQ_consInfFirma , PQ_CMcirugia , PQ_duracEst , PQ_estado , PQ_estadoACCX , PQ_estadoGAP , "+;
		" PQ_fechaProg , PQ_fechaQuiro , PQ_hemoDadores , PQ_hemoGF , PQ_hemoOK , PQ_hemoUnidades , "+;
		" PQ_hemoterapia , PQ_horaEst , PQ_laboratorio , PQ_mateEstado , PQ_mateOK , PQ_material ,"+;
		" PQ_presuEstado , PQ_rayos , PQ_servicio , PQ_tipoPac , PQ_torre , PQ_vacATT , PQ_verifDatos,?mcodmed as idmedact,?mcentrocx "+;
		" FROM TabPQX Where id = ?tnId "
	mRet = SQLExec(mcon1,lcsql  )
	If mret <= 0
		Do log_errores With Error(), Message(), Message(1), TRANSFORM(tnId)+ Program(), Lineno()
	Endif
	lcSql = "Update TabPQX set  " + ;
		"  PQ_anestesiaTipo = ?manestesiaTipo , PQ_apto = ?mapto , PQ_biopsiaIntraOp = ?mbiopsiaIntraOp  "+;
		", PQ_camaSector = ?mcamaSector  , PQ_camaSolic = ?mcamaSolic  , PQ_codPrest = ?mcodPrest  "+;
		", PQ_coddiag = ?mcoddiag , PQ_codent = ?mcodent , PQ_codmed = ?mcodmed , PQ_complejidad = ?mcomplejidad"+;
		", PQ_consInfEntrega = ?mconsInfEntrega , PQ_consInfFirma = ?mconsInfFirma  "+;
		", PQ_duracEst =?mduracEst  , PQ_estado = ?mestado  , PQ_fecPasiva = ?mfecPasiva , PQ_fechaProg = ?mfechaProg "+;
		" , PQ_fechaQuiro = ?mfechaQuiro , PQ_hemoDadores = ?mhemoDadores , PQ_hemoGF = ?mhemoGF  "+;
		",  PQ_hemoterapia = ?mhemoterapia , PQ_horaEst = ?mhoraEst  , PQ_laboratorio = ?mlaboratorio "+;
		" , PQ_mateOK = ?mmateOK , PQ_material = ?mmaterial , PQ_rayos = ?mrayos,PQ_hemoOk = ?mhemoOK   "+;
		", PQ_registracio = ?mregistracio  , PQ_servicio = ?mservicio  , PQ_tipoPac = ?mtipoPac  , PQ_torre = ?mtorre , PQ_vacATT = ?mvacATT "+;
		", PQ_estadoGAP = ?mgap ,PQ_aislaInfecto= ?maisla,PQ_mateEstado = ?matestado,PQ_hemounidades =?mhemounidades,PQ_estadoACCX = ?mestadoACCX "+;
		", PQ_alergiaLatex = ?mAleLatex, PQ_solclinico =?msolclinico, PQ_reqPreQX =?mreqPreQX ,UserDbUpd = ?mcdist,PQ_CMcirugia = ?mcentrocx " +;
		+cactCM +" Where id = ?tnId "
Case tnOpcion = 4
	If Vartype(mcodmed )="N"
		lcSql = "Insert into ZabPQXLog  " + ;
			" (idpqx , PQ_aislaInfecto ,PQ_alergiaLatex, PQ_anestesiaTipo , PQ_apto , PQ_biopsiaIntraOp , PQ_camaSector , "+;
			" PQ_camaSolic , PQ_codPrest , PQ_codambito , PQ_codent , PQ_complejidad , PQ_consInfEntrega , "+;
			" PQ_consInfFirma , PQ_deposito , PQ_duracEst , PQ_estado , PQ_estadoACCX , PQ_estadoGAP , "+;
			" PQ_fechaProg , PQ_fechaQuiro , PQ_hemoDadores , PQ_hemoGF , PQ_hemoOK , PQ_hemoUnidades , "+;
			" PQ_hemoterapia , PQ_horaEst , PQ_laboratorio , PQ_mateEstado , PQ_mateOK , PQ_material , "+;
			" PQ_presuEstado , PQ_rayos , PQ_servicio , PQ_tipoPac , PQ_torre , PQ_vacATT , PQ_verifDatos,idmedact,PQ_CMcirugia)"+;
			" select ID, PQ_aislaInfecto ,PQ_alergiaLatex, PQ_anestesiaTipo , PQ_apto , PQ_biopsiaIntraOp , PQ_camaSector , "+;
			" PQ_camaSolic , PQ_codPrest , PQ_codambito , PQ_codent , PQ_complejidad , PQ_consInfEntrega , "+;
			" PQ_consInfFirma , PQ_deposito , PQ_duracEst , PQ_estado , PQ_estadoACCX , PQ_estadoGAP , "+;
			" PQ_fechaProg , PQ_fechaQuiro , PQ_hemoDadores , PQ_hemoGF , PQ_hemoOK , PQ_hemoUnidades , "+;
			" PQ_hemoterapia , PQ_horaEst , PQ_laboratorio , PQ_mateEstado , PQ_mateOK , PQ_material ,"+;
			" PQ_presuEstado , PQ_rayos , PQ_servicio , PQ_tipoPac , PQ_torre , PQ_vacATT , PQ_verifDatos"+;
			",?mcodmed as idmedact,PQ_CMcirugia"+;
			" FROM TabPQX Where id = ?tnId "
	Else
		lcSql = "Insert into ZabPQXLog  " + ;
			" (idpqx , PQ_aislaInfecto ,PQ_alergiaLatex, PQ_anestesiaTipo , PQ_apto , PQ_biopsiaIntraOp , PQ_camaSector , "+;
			" PQ_camaSolic , PQ_codPrest , PQ_codambito , PQ_codent , PQ_complejidad , PQ_consInfEntrega , "+;
			" PQ_consInfFirma , PQ_deposito , PQ_duracEst , PQ_estado , PQ_estadoACCX , PQ_estadoGAP , "+;
			" PQ_fechaProg , PQ_fechaQuiro , PQ_hemoDadores , PQ_hemoGF , PQ_hemoOK , PQ_hemoUnidades , "+;
			" PQ_hemoterapia , PQ_horaEst , PQ_laboratorio , PQ_mateEstado , PQ_mateOK , PQ_material , "+;
			" PQ_presuEstado , PQ_rayos , PQ_servicio , PQ_tipoPac , PQ_torre , PQ_vacATT , PQ_verifDatos, PQ_CMcirugia)"+;
			" select ID, PQ_aislaInfecto ,PQ_alergiaLatex, PQ_anestesiaTipo , PQ_apto , PQ_biopsiaIntraOp , PQ_camaSector , "+;
			" PQ_camaSolic , PQ_codPrest , PQ_codambito , PQ_codent , PQ_complejidad , PQ_consInfEntrega , "+;
			" PQ_consInfFirma , PQ_deposito , PQ_duracEst , PQ_estado , PQ_estadoACCX , PQ_estadoGAP , "+;
			" PQ_fechaProg , PQ_fechaQuiro , PQ_hemoDadores , PQ_hemoGF , PQ_hemoOK , PQ_hemoUnidades , "+;
			" PQ_hemoterapia , PQ_horaEst , PQ_laboratorio , PQ_mateEstado , PQ_mateOK , PQ_material ,"+;
			" PQ_presuEstado , PQ_rayos , PQ_servicio , PQ_tipoPac , PQ_torre , PQ_vacATT , PQ_verifDatos ,PQ_CMcirugia"+;
			" FROM TabPQX Where id = ?tnId "
	Endif
	mRet = SQLExec(mcon1,lcsql  )
	If mret <= 0
		Do log_errores With Error(), Message(), lcsql  , TRANSFORM(tnId)+Program(), Lineno()
	Endif

	lcSql = "Update TabPQX set  " +ccampos +" Where id = ?tnId "
Otherwise

Endcase

mRet = SQLExec(mcon1,lcsql  )
If mret <= 0
	Do log_errores With Error(), Message(), lcsql  , Program(), Lineno()
	mresp = .F.
	Return .F.
Endif

