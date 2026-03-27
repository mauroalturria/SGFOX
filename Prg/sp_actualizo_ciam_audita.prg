*
* Actualizacion de CIAM - AUDITORIAS DE INTERNACION
*
Lparameters mform

Dimension mv[20]

midus = Alltrim(mwkusuario.idusuario)
mfeca = sp_busco_fecha_serv('DT')
mtipo = mform.tipomov

mpaso = .T.

Store '' To mv

With mform

	mv[01] = .txtfecing.Value
	mv[02] = .txthingreso.Value
	mv[03] = .txtnroafi.Value
	mv[04] = .txtdocumento.Value
	mv[05] = .txtnombre.Value
	mv[06] = Iif(.txtfecnac.Value={//},Ctod('01/01/1900'),.txtfecnac.Value)
	mv[07] = .txtdiagnostico.Value
	mv[08] = .lcboclinica && mwkClinica.lid
	mv[09] = .mcentidad   &&.txtosocial.value
	mv[10] = mwksecint.Id
	mv[11] = mwktipo.lidmot
	mv[12] = .cbosexo.DisplayValue
	mv[13] = .txtedad.Value
	mv[14] = Iif(.chkegreso.Value=1,.txtcierre.Value,Ctod("01/01/1900"))
	mv[15] = Iif(.chkegreso.Value=1,.txthegreso.Value,0)
	mv[16] = .txtpadron.Value
	mv[17] = .txtregistracio.Value

*!*	mv[18] = Iif(.txtfcambio.Value = {//},Ctod('01/01/2100'),.txtfcambio.Value)

	mv[18] = Iif(.txtfcambio.Value = {//}, Ttod(mfeca), .txtfcambio.Value)

	mv[19] = .txthcambio.Value

	mv[20] = .chkllama.Value

	mctrlfec = .lgfec

Endwith

If mtipo = 'ALTA'

*
* p/control
*

* Marcelo Torres, 28/05/2012
* Verificamos que el paciente no este vigente.
*------------------------
	mret = SQLExec(mcon1,"select TCI_fecegr from TabCiamAudInt " + ;
		"where TCI_nroafi=?mv[03] and TCI_fecegr = '1900-01-01'","mwkctraud" )

	If mret<=0  &&error en la consulta sql
		Messagebox("ERROR EN CONSULTA AUDITORIA DE INTERNACION",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Else

		If Reccount("mwkctraud") > 0
			Messagebox("EL PACIENTE AUN NO HA EGRESADO. NO PUEDE VOLVER A INGRESARLO",26,"Validación")
			Return .F.
		Endif

	Endif
*------------------------

	If mv[01] = mctrlfec
		mrespu = Messagebox("FECHA DE INGRESO, ES EL DIA DE HOY ?",32+4,"Validación")
		If mrespu = 7
			mret = -1
			Return .F.
		Endif
	Endif

*!*		If mv[20] = 1
*!*			mrespu = messagebox("INGRESO CON LLAMADO REALIZADO ?",32+4,"Validación")
*!*			If mrespu = 7
*!*				mret = -1
*!*				Return
*!*			Endif
*!*		Endif

	mret = SQLExec(mcon1,"insert into TabCiamAudInt "+;
		"(TCI_fecing,TCI_hhmming,TCI_nroafi,TCI_nrodoc,TCI_nombrepac,TCI_fecnac,TCI_diagnos,"+;
		"TCI_idcentro,TCI_identi,TCI_idtipo,TCI_idmotivo,TCI_sexo,TCI_txtedad,TCI_fecegr,"+;
		"TCI_hhmmegr,TCI_enpadron,TCI_enregistracio,TCI_usuario,TCI_fecmov,TCI_llamado)"+;
		" values (?mv[01],?mv[02],?mv[03],?mv[04],?mv[05],?mv[06],?mv[07],"+;
		"?mv[08],?mv[09],?mv[10],?mv[11],?mv[12],?mv[13],?mv[14],?mv[15],"+;
		"?mv[16],?mv[17],?midus,?mfeca,1)")

*!*		?mv[20]

	If mret < 0
		mpaso = .F.
		Messagebox("EN REGISTRO AUDITORIA DE INTERNACION"+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Else
		If Used('mwkctraud')
			Use In mwkctraud
		Endif

* Obtenemos el Id del registro nuevo.
		mret = SQLExec(mcon1,"select id as lid from TabCiamAudInt"+;
			" where TCI_usuario=?midus and TCI_fecmov=?mfeca","mwkctraud")
		If mret > 0
			Select mwkctraud
			Go Top
			mlidctrl = mwkctraud.lid
		Else
			mpaso = .F.
			Messagebox("EN BUSQUEDA AUDITORIA DE INTERNACION"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .T.
		Endif
	Endif

Else

	mlidctrl  = mform.nidaud
	mfec2 = sp_busco_fecha_serv('DD')

	mret = SQLExec(mcon1,"update TabCiamAudInt set "+;
		"TCI_fecing=?mv[01],TCI_hhmming=?mv[02],TCI_nroafi=?mv[03],TCI_nrodoc=?mv[04],TCI_nombrepac=?mv[05],"+;
		"TCI_fecnac=?mv[06],TCI_diagnos=?mv[07],TCI_idcentro=?mv[08],TCI_identi=?mv[09],TCI_idtipo=?mv[10],"+;
		"TCI_idmotivo=?mv[11],TCI_sexo=?mv[12],TCI_txtedad=?mv[13],TCI_fecegr=?mv[14],TCI_hhmmegr=?mv[15],"+;
		"TCI_enpadron=?mv[16],TCI_enregistracio=?mv[17],TCI_usuario=?midus,TCI_fecmov=?mfeca,TCI_llamado=?mv[20]"+;
		" where id=?mlidctrl")

	If mret < 0
		mpaso = .F.
		Messagebox("EN ACTUALIZACION AUDITORIA DE INTERNACION"+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

Endif


If mpaso And mtipo <> 'ALTA' &&vamos a grabar el log.

	If Used('mwklogctrl')
		Use In mwklogctrl
	Endif

	mfct = Ctod("01/01/2100")

	mret = SQLExec(mcon1,"select * from TabCiamAudIntLog"+;
		" where TCL_idaudint = ?mlidctrl and TCL_fechasta =?mfct","mwklogctrl")

	mlins = .F.
	mStm = ""
	mret = 1

	mValAnterior = ""
	mValNuevo    = ""
	If .lgfec <> .txtfecing.Value  && fecha ingreso
		mValAnterior = Dtoc(.lgfec)
		mValNuevo    = Dtoc(mv[01])

		mret = GrabaLog(mlidctrl,'FECHA INGRESO',mValAnterior,mValNuevo,mfeca,midus)

	Endif
	If mret > 0 And .lhming    <> .txthingreso.Value  && hora ingreso
		mValAnterior = .lhming
		mValNuevo    = mv[02]

		mret = GrabaLog(mlidctrl,'HORA INGRESO',mValAnterior,mValNuevo,mfeca,midus)

	Endif
	If mret > 0 And .lnrodoc    <> .txtdocumento.Value  && cambio campo nro. documento
		mValAnterior = Str(.lnrodoc)
		mValNuevo    = Str(mv[04])

		mret = GrabaLog(mlidctrl,'DOCUMENTO',mValAnterior,mValNuevo,mfeca,midus)

	Endif
	If mret > 0 And .lnroafi <> .txtnroafi.Value  && cambio campo nro. de afiliado
		mValAnterior = Str(.lnroafi)
		mValNuevo    = Str(.txtnroafi.Value)

		mret = GrabaLog(mlidctrl,'NRO AFILIADO',mValAnterior,mValNuevo,mfeca,midus)

	Endif
	If mret > 0 And .lnompac <> .txtnombre.Value  && cambio campo nombre
		mValAnterior = Alltrim(.lnompac)
		mValNuevo    = Alltrim(.txtnombre.Value)

		mret = GrabaLog(mlidctrl,'APELLIDO NOMBRE',mValAnterior,mValNuevo,mfeca,midus)

	Endif
	If mret > 0 And .lsexo <> .cbosexo.Value   && cambio combo sexo
		mValAnterior = Iif(.lsexo = 1,"M","F")
		mValNuevo    = Iif(.cbosexo.Value = 1,"M","F")

		mret = GrabaLog(mlidctrl,'SEXO',mValAnterior,mValNuevo,mfeca,midus)

	Endif
	If mret > 0 And .lfecnac <> .txtfecnac.Value   && cambio de fecha nacimiento
		mValAnterior = Dtoc(.lfecnac)
		mValNuevo    = Dtoc(.txtfecnac.Value)

		mret = GrabaLog(mlidctrl,'FECHA NACIMIENTO',mValAnterior,mValNuevo,mfeca,midus)

	Endif
	If mret > 0 And .ldiagno    <> .txtdiagnostico.Value  && cambio de diagnostico
		mValAnterior = .ldiagno
		mValNuevo    = .txtdiagnostico.Value

		mret = GrabaLog(mlidctrl,'DIAGNOSTICO',mValAnterior,mValNuevo,mfeca,midus)

	Endif
	If mret > 0 And .lchllama   <> .chkllama.Value  && llamado realizado
		mValAnterior = Iif(.lchllama=1,"SI","NO")
		mValNuevo    = Iif(.chkllama.Value=1,"SI","NO")

		mret = GrabaLog(mlidctrl,'LLAMADO REALIZADO',mValAnterior,mValNuevo,mfeca,midus)

	Endif
	If mret > 0 And mform.sintant <> mwksecint.Id     && cambio sector de internacion

		mValAnterior = Alltrim(mform.sintantd)
		mValNuevo    = Alltrim(mform.CboInterna.DisplayValue)

		mlmsg = "SECTOR INTERNACION " + Dtoc(mv[18]) + " " + Transform(mv[19],"99:99")

*!*		mret = GrabaLog(mlidctrl,'SECTOR INTERNACION',mValAnterior,mValNuevo,mfeca,midus)

		mret = GrabaLog(mlidctrl, mlmsg, mValAnterior, mValNuevo, mfeca, midus)

	Endif
	If mret > 0 And .lcboidmot <> .cbopriori.DisplayValue   && Prioridad o motivo.
		mValAnterior = .lcboidmot
		mValNuevo    = .cbopriori.DisplayValue

		mret = GrabaLog(mlidctrl,'PRIORIDAD',mValAnterior,mValNuevo,mfeca,midus)

	Endif
	If mret > 0 And .txtcierre.Value <> {//} And .txtcierre.Enabled    && fecha de egreso
		mValAnterior = ""
		mValNuevo    = Dtoc(.txtcierre.Value)

		mret = GrabaLog(mlidctrl,'FECHA EGRESO',mValAnterior,mValNuevo,mfeca,midus)

	Endif

	If mret < 0
		Messagebox("EN ACTUALIZACION LOG AUDITORIA DE INTERNACION",16,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

Endif
Release mv

Return .T.


*-------------
Function GrabaLog(nId,cDescrip,cValAnt,cValNuevo,tFecha,cUsuario)
*-------------

Local nValor As Number

nValor = SQLExec(mcon1,"insert into TabCiamAudIntLog"+;
	" (TCL_idaudint,TCL_descrip,TCL_valante,TCL_valnuevo,TCL_fecmov,TCL_usuario) values"+;
	" (?nId,?cDescrip,?cValAnt,?cValNuevo,?tFecha,?cUsuario)")
Return nValor

