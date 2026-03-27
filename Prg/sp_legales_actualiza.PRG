*
* Registro de movimientos ALTAS, MODIFICACIONES
*
Lparameters mform

mproviene = mform.lproviene
mtipopac  = mform.tpaciente

mpage1 = mform.PGLegales.Page1
mpage2 = mform.PGLegales.Page2
mpage3 = mform.PGLegales.Page3

mtipomov  = mform.tipomov
mestado   = mwkEstado.subestado

mfesin    = .txtfsin.value   && .pasoafecha(.txtfsin.value)

mfreclamo = .txtrecla.value  && .pasoafecha(.txtrecla.value)
if mfreclamo = {//}
  mfreclamo = ctod('01/01/1900')
endif

mfdenprev = .txtdenpre.value && Denuncia Preventiva
if mfdenprev = {//}
  mfdenprev = ctod('01/01/1900')
endif

With mpage1
	mactor = .txtactor.value
	mparen = .cboparen.value
	If mtipopac = 'R'
		mpacie = mwkplegales.reg_nroregistrac
		mpacee = 0
	Else       && 'E'
		mpacie = 0
		mpacee = mwkplegales.reg_nroregistrac
	Endif
	mcoden = mwkplegales.ent_codent
	mdeman = .txtdemandados.value
*!*	masegu = 0 && mwkAsegura.id && mwkAsegura.subestado
	mestad = mwkEstado.subestado
	mjuzga = .txtjuzgado.value
	mmontr = mwkMontosr0.subestado
	mmonti = .txtimpor.value
*!*	mdescr = alltrim(.txthecho.value)
*!*	mdescr = ''
	mhecho = mwkHechosg.TLH_idcod && mwkHechosg.id
	mriesg = mwkRiesgo.subestado
	mobito = iif(.chkobito.value=0,'N','S')
Endwith

mfecnul = ctod('01/01/1900')

With mpage2
	motros = .txtotrosprest.value
	mservr = iif(.cboservicio.displayvalue<>'',mwkServ.ser_codserv,0)
*!*	mmedbj = 0 &&.chkmedbaj.value
	mfctrl = .txtfmedia.value && mform.pasoafecha(.txtfmedia.value)
	mfemed = iif(mfctrl={//},mfecnul,mfctrl)
	mmonof = iif(.cbomontofre.displayvalue<>'',mwkMontosr1.subestado,0)
	mimpof = iif(.cbomontofre.displayvalue<>'',.txtimpofre.value,0)
	monaco = iif(.cbomontoac.displayvalue<>'' ,mwkMontosr2.subestado,0)
	mimpac = iif(.cbomontoac.displayvalue<>'' ,.txtimpoac.value,0)
	mmonsc = iif(.cbomontacsc.displayvalue<>'',mwkMontosr3.subestado,0)
	mimpsc = iif(.cbomontacsc.displayvalue<>'',.txtimpacsc.value,0)
	mfctrl = .txtfac.value    && mform.pasoafecha(.txtfac.value)
	mfeacu = iif(mfctrl={//},mfecnul,mfctrl)
	mfctrl = .txtfdem.value   && mform.pasoafecha(.txtfdem.value)
	mfedem = iif(mfctrl={//},mfecnul,mfctrl)
	mfctrl = .txtfsent.value  && mform.pasoafecha(.txtfsent.value)
	mfesen = iif(mfctrl={//},mfecnul,mfctrl)
	mmonse = iif(.cbomonsent.displayvalue<>'',mwkMontose0.subestado,0)
	mimpse = iif(.cbomonsent.displayvalue<>'',.txtimpsent.value,0)
	mmossc = iif(.cbomonsentsc.displayvalue<>'',mwkMontose1.subestado,0)
	mimssc = iif(.cbomonsentsc.displayvalue<>'',.txtimpsentsc.value,0)
Endwith

musuar = mwkusuario.idusuario
mfeact = sp_busco_fecha_serv('DT')

If len(alltrim(mpage3.txtcomentario.value))>0
	mcomen = ttoc(mfeact)+', '+musuar+': '+alltrim(mpage3.txtcomentario.value)+chr(13)
	If len(alltrim(mpage3.txtcomentario2.value))>0
		mcomen = mcomen + alltrim(mpage3.txtcomentario2.value)
	Endif
Else
	mcomen = alltrim(mpage3.txtcomentario2.value)
Endif

If mtipomov = 'ALTA'

	mret = sqlexec(mcon1,"insert into TabLGDema (TLD_actor,TLD_nroregistrac,TLD_codent,TLD_demandados,"+;
		"TLD_idestado,TLD_juzgado,TLD_idmontoreq,TLD_montoreq,TLD_idhecho,"+;
		"TLD_idriesgomed,TLD_fecsiniestro,TLD_otrosprest,TLD_idservicio,TLD_fecinimed,"+;
		"TLD_idmontofre,TLD_montofre,TLD_idmontacor,TLD_montacor,TLD_idmontosc,TLD_montosc,TLD_fecacuerdo,"+;
		"TLD_fecdemanda,TLD_fecsenten,TLD_idmonsent,TLD_monsent,TLD_idmonsentsc,TLD_monsentsc,TLD_comentarios,"+;
		"TLD_idparen,TLD_obito,TLD_idusuario,TLD_fechamov,TLD_ipadress,TLD_freclamo,"+;
		"TLD_idproviene,TLD_nroregisext,TLD_fecdenprev)"+;
		" values (?mactor,?mpacie,?mcoden,?mdeman,?mestado,?mjuzga,"+;
		"?mmontr,?mmonti,?mhecho,?mriesg,?mfesin,?motros,?mservr,?mfemed,?mmonof,?mimpof,"+;
		"?monaco,?mimpac,?mmonsc,?mimpsc,?mfeacu,?mfedem,?mfesen,?mmonse,?mimpse,?mmossc,?mimssc,"+;
		"?mcomen,?mparen,?mobito,?musuar,?mfeact,?myIp,?mfreclamo,?mproviene,?mpacee,?mfdenprev)")

	If mret < 0
		Messagebox("EN REGISTRO DE LA DEMANDA"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		return
	Else
		If used('mwknrorden')
			Use in mwknrorden
		Endif
		mret = sqlexec(mcon1,"select id as nroreq from TabLGDema where TLD_nroregistrac=?mpacie "+;
			"and TLD_ipadress=?myIp ","mwknrorden")
		If mret > 0
			If used('mwknrorden')
				If reccount('mwknrorden')>0
					mbusca = mwknrorden.nroreq
					mret = sqlexec(mcon1,"update TabLGDema set TLD_ipadress='' where id=?mbusca")
					If mret < 0
						Messagebox("EN ACTUALIZACION DE REQUERIMIENTO/DEMANDA",16,"ERROR")
*!*					Else
*!*							If reccount('mwkmedgrid')>0
*!*								Select mwkmedgrid
*!*								Go top
*!*								Scan
*!*									mnombr = mwkmedgrid.nombre
*!*									mcodig = mwkmedgrid.codigo
*!*									mtipo  = mwkmedgrid.tipo
*!*									mret = sqlexec(mcon1,"insert into TabLGMedv (TLM_idreclamo,TLM_codmed,TLM_nombremed,TLM_tipo) "+;
*!*										"values (?mbusca,?mcodig,?mnombr,?mtipo)")
*!*									If mret < 0
*!*										Messagebox("EN REGISTRO DE MEDICOS",16,"ERROR")
*!*									Endif
*!*								Endscan
*!*							Endif
					Endif
				Endif
			Endif
		Else
			Messagebox("EN BUSQUEDA DE REQUERIMIENTO/DEMANDA"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			mbusca = 0
		Endif
	Endif
Else
	mbusca = mwklegales.orden
	mret = sqlexec(mcon1,"update TabLGDema set "+;
		"TLD_actor = ?mactor,"+;
		"TLD_nroregistrac = ?mpacie,"+;
		"TLD_codent = ?mcoden,"+;
		"TLD_demandados = ?mdeman,"+;
		"TLD_idestado = ?mestado,"+;
		"TLD_juzgado = ?mjuzga,"+;
		"TLD_idmontoreq = ?mmontr,"+;
		"TLD_montoreq = ?mmonti,"+;
		"TLD_idhecho = ?mhecho,"+;
		"TLD_idriesgomed = ?mriesg,"+;
		"TLD_fecsiniestro = ?mfesin,"+;
		"TLD_otrosprest = ?motros,"+;
		"TLD_idservicio = ?mservr,"+;
		"TLD_fecinimed = ?mfemed,"+;
		"TLD_idmontofre = ?mmonof,"+;
		"TLD_montofre = ?mimpof,"+;
		"TLD_idmontacor = ?monaco,"+;
		"TLD_montacor = ?mimpac,"+;
		"TLD_idmontosc = ?mmonsc,"+;
		"TLD_montosc = ?mimpsc,"+;
		"TLD_fecacuerdo = ?mfeacu,"+;
		"TLD_fecdemanda = ?mfedem,"+;
		"TLD_fecsenten = ?mfesen,"+;
		"TLD_idmonsent = ?mmonse,"+;
		"TLD_monsent = ?mimpse,"+;
		"TLD_idmonsentsc = ?mmossc,"+;
		"TLD_monsentsc = ?mimssc,"+;
		"TLD_comentarios = ?mcomen,"+;
		"TLD_idparen = ?mparen,"+;
		"TLD_obito = ?mobito,"+;
		"TLD_idusuario = ?musuar,"+;
		"TLD_fechamov = ?mfeact,"+;
		"TLD_idproviene = ?mproviene,"+;
		"TLD_nroregisext = ?mpacee,"+;
		"TLD_freclamo = ?mfreclamo,"+;
		"TLD_fecdenprev= ?mfdenprev"+;
		" where id = ?mbusca")
	If mret < 0
		Messagebox("EN MODIFICACION DE LA DEMANDA"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif
Endif

If reccount('mwkmedgrid')>0
	mret = sqlexec(mcon1,"delete from TabLGMedv where TLM_idreclamo = ?mbusca")
	If mret > 0
		Select mwkmedgrid
		Go top
		Scan
			mnombr = mwkmedgrid.nombre
			mcodig = mwkmedgrid.codigo
			mtipo  = mwkmedgrid.tipo
			mret = sqlexec(mcon1,"insert into TabLGMedv (TLM_idreclamo,TLM_codmed,TLM_nombremed,TLM_tipo) "+;
				"values (?mbusca,?mcodig,?mnombr,?mtipo)")
			If mret < 0
				Messagebox("EN REGISTRO DE MEDICOS",16,"ERROR")
			Endif
		Endscan
	Else
		Messagebox("EN ACTUALIZACION DE MEDICOS",16,"ERROR")
	Endif
Endif

If reccount('mwkmedgridB')>0
	mret = sqlexec(mcon1,"delete from TabLGAsegv where TAV_idreclamo = ?mbusca")
	If mret > 0
		Select mwkmedgridB
		Go top
		Scan
			midpol = mwkmedgridB.idpoliza
			midase = mwkmedgridB.idaseg
			mret = sqlexec(mcon1,"insert into TabLGAsegv (TAV_idreclamo,TAV_idasegura,TAV_idpolizas) "+;
				"values (?mbusca,?midase,?midpol)")
			If mret < 0
				Messagebox("EN REGISTRO POLIZAS",16,"ERROR")
			Endif
		Endscan
	Else
		Messagebox("EN ACTUALIZACION DE POLIZAS",16,"ERROR")
	Endif
Endif

If mret > 0

	If 'MOVER A MALA PRAXIS' $ mform.lbltit.caption
		mest1 = 0
		mest2 = 0
		mret1 = sqlexec(mcon1,"insert into TabLGEvo ( TLE_iddemanda,TLE_idusuario,TLE_fechamov,"+;
			"TLE_idestant,TLE_idesact) "+;
			"values(?mbusca,?musuar,?mfeact,?mest1,?mest2)")
		If mret1 < 0
			Messagebox("EN REGISTRO EVOLUCION DE ESTADOS, PASAJE A MALA PRAXIS."+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Endif
	Endif

	If mform.pestado <> mwkEstado.subestado
		mest1 = mform.pestado
		mest2 = mwkEstado.subestado
		mret1 = sqlexec(mcon1,"insert into TabLGEvo ( TLE_iddemanda,TLE_idusuario,TLE_fechamov,"+;
			"TLE_idestant,TLE_idesact) "+;
			"values(?mbusca,?musuar,?mfeact,?mest1,?mest2)")
		If mret1 < 0
			Messagebox("EN REGISTRO EVOLUCION DE ESTADOS",16,"ERROR")
		Endif
	Endif
	
Endif
