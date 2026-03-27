lparameters nroregistra, newregistra

if vartype(mcon3)= "U"
	public mcon3
	mcon3 = 0
endif
moldambito = mxambito

mcon3 = 0
if !used("mwktabambito")
	do sp_busco_tabla_id with 'tabambito', '  ','mwktabambito'
	select mwktabambito
	locate for id = mxambito
endif
do sp_busco_estados with 126, '',"mwksuperamb"
mcon1a = mcon1
do sp_conexion_sa with "OTROAMBITO"
if mcon3>0
	mcon1 = mcon3
	mcadcon = mwkambitoini.ini
	nlineas = alines(mimatini,mcadcon)
	lEXE = ascan(mimatini,"[OTROAMBITO]")
	lexeini = lEXE +1
	lsuper = ascan(mimatini,"[SUPER]", lexeini)
	mSuper 	= val(mimatini(1+lsuper))
	select mwksuperamb
	locate for estado = msuper
	mxambito = msuper
***
	mfecha 		= sp_busco_fecha_serv('DT')
	musuario 	= mwkusuario.idusuario
	fecnul=ctod("01/01/1900")
	do sp_actua_nroreg_control with nroregistra, newregistra
	mret = SQLExec(mcon1,"update turnos set afiliado = ?newregistra " + ;
		"where afiliado = ?nroregistra")
	if mret < 0
		=aerr(eros)
		messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
	endif
	mret = SQLExec(mcon1,"update turnoshis set afiliado = ?newregistra " + ;
		"where afiliado = ?nroregistra")

	if mret < 0
		=aerr(eros)
		messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
	endif

	mret = SQLExec(mcon1,"update turnoscancel set afiliado = ?newregistra " + ;
		"where afiliado = ?nroregistra")
	if mret < 0
		=aerr(eros)
		messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
	endif
	mret = SQLExec(mcon1,"update tabfacturas set nroregistracio = ?newregistra " + ;
		"where nroregistracio = ?nroregistra")

	if mret < 0
		=aerr(eros)
		messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
	endif
	mret = SQLExec(mcon1,"update Tabambonco set TAO_registracio = ?newregistra " + ;
		"where TAO_registracio = ?nroregistra")

	mret = SQLExec(mcon1,"update TabProtocolo set tpregistrac = ?newregistra " + ;
		"where tpregistrac= ?nroregistra")
	if mret < 0
		=aerr(eros)
		messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
	endif
	mret = SQLExec(mcon1,"update tabambulatorio set nroregistrac = ?newregistra " + ;
		"where nroregistrac = ?nroregistra")

	mret = SQLExec(mcon1,"update Tabambevol set EA_nroregistrac = ?newregistra " + ;
		"where EA_nroregistrac = ?nroregistra")

	mret = SQLExec(mcon1,"update Tabambgestserologia  set SN_Registracio = ?newregistra " + ;
		"where SN_Registracio = ?nroregistra")

	mret = SQLExec(mcon1,"update Tabambgesta set TAG_nroregis = ?newregistra " + ;
		"where TAG_nroregis = ?nroregistra")

	mret = SQLExec(mcon1,"update Tabantecpac set AT_registracio = ?newregistra " + ;
		"where AT_registracio = ?nroregistra")

	mret = SQLExec(mcon1,"update Tabautprevias set APV_Registracio = ?newregistra " + ;
		"where APV_Registracio = ?nroregistra")

	if mret < 0
		messagebox('EN ACTUALIZACION DE MAESTROS - Unificacion -',0,'ERROR')
	endif


*******


	mcon1 = mcon1a
	do sp_desconexion_sa with "sp_control_bristol"
	use in select("mwksuperamb")
	mxambito = moldambito
endif
release mcon3
