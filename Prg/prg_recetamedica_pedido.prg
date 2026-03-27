** Llama a Receta Médica Digital
** Fecha: 2020/07
** Fabián

Parameters paciente,medico,afiliado,entidad,tipo
* Tipo 1=nro de registracion / Tipo 2=nro hclinica / Tipo 3 =DNI
* nPasoEstado/Estado: 0 No envia / 1 Envía / 2 Recibe Ok (Token) / 3 Recibe Farmacia

* Para probar:
*!*	Do sp_conexion
*!*	paciente = 820225
*!*	medico = 1234
*!*	afiliado = 25251068
*!*	entidad = 709
*!*	tipo = 1
* -----------------

mregistracion = 0
nPasoEstado = 0
nModificaMail = 0 && 1 = El médico modifica el mail

Do Case
Case tipo = 1
	lcwhere = ' where reg_nroregistrac = ?Paciente'
Case tipo = 2
	lcwhere = ' where reg_nrohclinica = ?Paciente'
Case tipo = 3
	lcwhere = ' where reg_nrodocumento = ?Paciente'
Endcase

lcSql = 'Select * from registracio ' + lcwhere
If !Prg_EjecutoSql(lcSql,"mwkRDMdatos","")
	Return .F.
Endif

If !Used('mwkRDMdatos')
	Messagebox('No hay datos existentes',48,'Aviso')
	Return .F.
Endif

Select mwkRDMdatos
If !Reccount('mwkRDMdatos')>0
	Messagebox('No hay datos existentes',48,'Aviso')
	Return .F.
Endif

mregistracion = mwkRDMdatos.reg_nroregistrac
mvalidomail = Alltrim(mwkRDMdatos.reg_email)
lcMailvalido = ''

* Busco Teléfono Celular (No está habilitado el servicio todavía (Mail 27/07/2020)

lcSql = ""
lcSql = 'select * from prestadores where id = ?medico'
If !Prg_EjecutoSql(lcSql,"mwkRDMmedico","")
	Return .F.
Endif

* Afiliación del paciente
*!*	mnroafiliado = afiliado && Ver si este parámetro viene en 0 o falso
*!*	*lcSql = 'select * from AFILIACION where REGISTRACIO = ?mregistracion and afi_nroafiliado = ?mnroafiliado and afi_fechabaja is null'
*!*	lcSql = 'select * from AFILIACION where REGISTRACIO = ?mregistracion and afi_codentidad = ?entidad and afi_fechabaja is null'

*!*	If !Prg_EjecutoSql(lcSql,"mwkRDMafiliacion","")
*!*		Return .F.
*!*	Endif
*!*	mEntidaddelafiliado = ''
*!*	mnroEntidad = 0
*!*	If Reccount('mwkRDMafiliacion')>0
*!*	*	mnroAfiliacion = Padr(Alltrim(mwkRDMafiliacion.afi_nroafiliado),8,"0")
*!*	Endif
*!*	mnroEntidad = entidad
*!*	lcSql = 'select ent_descrient from entidades where ent_codent = ?mnroEntidad'
*!*	If !Prg_EjecutoSql(lcSql,"mwkRDMentidad","")
*!*		Return .F.
*!*	Endif
*!*	If Reccount('mwkRDMentidad')>0
*!*	Select mwkRDMentidad
*!*	Locate For mwkRDMentidad.ent_codent = mnroEntidad
*!*	*	mEntidaddelafiliado = Alltrim(mwkRDMentidad.ent_descrient)
*!*	Endif
*!*	* ------------
*ENT_DESCRIENT,AFI_NROAFILIADO

lcSql = 'select * '+;
	'from afiliacion INNER JOIN ENTIDADES ON AFILIACION.AFI_codentidad = ENTIDADES.ENT_codent '+;
	'where REGISTRACIO = ?mregistracion AND AFILIACION.AFI_fechabaja is null'
If !Prg_EjecutoSql(lcSql,"mwkRDMafiliacion","")
	Return .F.
Endif
If Reccount('mwkRDMafiliacion')>0
	Select mwkRDMafiliacion
	Locate For mwkRDMafiliacion.ent_codent = entidad
Endif

mPlanid = Int(Val(mwkRDMdatos.reg_distrito))
mPlan = ""
lcSql = "select * from planes where id = ?mPlanid"
If !Prg_EjecutoSql(lcSql,"mwkRDMplan","")
	Return .F.
Endif
If Reccount('mwkRDMplan')>0
	mPlan = Alltrim(mwkRDMplan.descripcion)
Endif

* local lcHC,lnIdConsumo,lnUsuario,lcMedico,lnMedicomat,lnPacDNI,lcPacNA,lcPacAfiliado,lcPacMail,;
lcPacTel,lnTiporespuesta,lnMensajeria,lnToken,ltfechahora,ldfecha,lccontrol,lnestado

* ----------------------------
lcHC = '' && Historia Clínica del Paciente
lnIdConsumo = 0 && Código Interno SG
lnUsuario = 0 && Usuario Médico
lcMedico  = '' && Nombre y Apellido del médico
lnMedicomat = 0 && Matrícula del Profesional
lnPacDNI = 0 && DNI del paciente
lcPacNA = '' && Nombre y Apellido del paciente
lcPacMail = '' && Mail del paciente para enviarle la receta
lcPacEntidad = '' && Entidad a la que pertenece el paciente
lcPacPlan = "" && Tipo de Plan que tiene el afiliado
lcPacAfiliado = '' && Número de afiliado del paciente
lcPacTel = '' && Teléfono Celular del paciente para enviarle notificación por Whatsapp / SMS
lnTiporespuesta = 0 && Para determinar el formato de respuesta (XML / Json) - lo hablamos cualquier cosa -
lnMensajeria = 0 && Si es apto para mensajería (opcional) Por si hay algún paciente que no tenga mail o telefonía móvil.
lnToken = 0 && A definir.
* ----------------------------

* Genero IdConsumo

If Messagebox('Ud. va a generar una nueva receta médica.'+Chr(10)+'Es lo que desea hacer ?',36,'AVISO')=7
	Return .F.
Endif


nModificaMail = 0
mresp = 0
Use In Select('mwkdatmail')

Do Form frmDatosPac To mresp

If Used('mwkdatplan')
	Select mwkdatplan
	If mwkdatplan.estado = 1
		mPlan = Alltrim(mwkdatplan.plan)
	Endif
Endif

If Used('mwkdatafiliado')
	Select mwkdatafiliado
	If mwkdatafiliado.estado = 1
		mnroafiliacion = mwkdatafiliado.numero
	Endif
Endif

If Used('mwkdatmail')
	Select mwkdatmail
	lnPasoEstado = mresp
	lcMailvalido = Alltrim(mwkdatmail.email)
	nModificaMail = mwkdatmail.estado
Endif


If lnPasoEstado = 0
	Messagebox('No Hay un Mail válido para enviar la receta',16,'AVISO')
	Return .F.
Endif

If lnPasoEstado = 2
	Return .F.
Endif

ltfechahora = sp_busco_fecha_serv('DT')
ldfecha = Ttod(ltfechahora)
lccontrol = Sys(2015)
lccontrol = Right(lccontrol,Len(lccontrol)-1)
lnestado = nPasoEstado && Envía pedido.

lcSql = 'insert into ZabRDMlog (RDM_fecha,RDM_estado,RDM_fechorapedido,RDM_idmedico,'+;
	'RDM_registracion,RDM_control,RDM_mailpac,RDM_modifmailpac)'+;
	'values (?ldfecha,?lnestado,?ltfechahora,?medico,?mregistracion,?lccontrol,?lcMailValido,?nModificaMail)'
If !Prg_EjecutoSql(lcSql)
	Return .F.
Endif
lcSql = 'select id from ZabRDMlog where RDM_registracion = ?mregistracion and RDM_fechorapedido = ?ltfechahora and RDM_control = ?lccontrol'
If !Prg_EjecutoSql(lcSql,'mwkRDMconsumo')
	Return .F.
Endif
If !Used('mwkRDMconsumo')
	Messagebox('Error al generar el id del consumo',0,'Error en la generación del consumo')
	Return .F.
Endif
Select mwkRDMconsumo
If Reccount('mwkRDMconsumo')<1
	Messagebox('No existe id del consumo',0,'Error en la generación del consumo')
	Return .F.
Endif
Select mwkRDMconsumo
lnIdConsumo1 = mwkRDMconsumo.Id
* --------------------------

lcHC = Alltrim(mwkRDMdatos.reg_nrohclinica)
lnIdConsumo = Alltrim(Str(lnIdConsumo1))
lnUsuario = Alltrim(Str(medico))
lcMedico = Alltrim(mwkRDMmedico.nombre)
lnMedicomat = Alltrim(mwkRDMmedico.matriculas)
lnPacDNI = Alltrim(Str(mwkRDMdatos.reg_numdocumento))
lcPacNA = Alltrim(mwkRDMdatos.reg_nombrepac)
lcPacEntidad = "4" && mEntidaddelafiliado && "4" = Hominis
lcPacAfiliado = Alltrim(mnroafiliacion) && Iif(Vartype(mnroafiliado)='N',Alltrim(Str(mnroafiliado)),mnroafiliado)
lcPacPlan = mPlan
lcPacMail = lcMailvalido
lcPacTel = Alltrim(mwkRDMdatos.reg_telefonos)
lnTiporespuesta = Alltrim( Str(1))
lnMensajeria = Alltrim(Str(1))
lnToken = 0

* Envio url + parámetros

xparams = "&hc="+lcHC+"&idconsumo="+lnIdConsumo+;
	"&usuario="+lnUsuario+"&medico="+lcMedico+;
	"&medicomat="+lnMedicomat+"&pacdni="+lnPacDNI+;
	"&pacna="+lcPacNA+"&pacentidad="+lcPacEntidad+"&pacplan="+lcPacPlan+"&pacafiliado="+lcPacAfiliado+;
	"&pacmail="+lcPacMail+"&pactel="+lcPacTel+"&tiporespuesta="+lnTiporespuesta+;
	"&mensajeria="+lnMensajeria

oCryp = Newobject("clsencrypt","lib_hce_encrypt")
lcHash_cryp = oCryp.safe_b64encode(xparams)
*!* lclink = "http://recetamedicadigital.com/rmd/nevareceta_sg.php?dat=" + lcHash_cryp
lclink = "http://rmd.sistemavinculado.com/nuevareceta_sg.php?dat=" + lcHash_cryp

*!*	o = Createobject("Shell.Application")
*!*	o.Open(lclink)

lnexiste = 0
lcfirefox1 = 'C:\Program files\Mozilla Firefox\firefox.exe'
lcfirefox2 = 'C:\program files (x86)\mozilla firefox\firefox.exe'
If File(lcfirefox1) And lnexiste = 0
	lnexiste = 1
Endif
If File(lcfirefox2) And lnexiste = 0
	lnexiste = 2
Endif
Do Case
Case lnexiste = 1
	lcfirefox = lcfirefox1
Case lnexiste = 2
	lcfirefox = lcfirefox2
Endcase

If lnexiste>0
	Declare Integer ShellExecute In "Shell32.dll" ;
		INTEGER HWnd, ;
		STRING lpVerb, ;
		STRING lpFile, ;
		STRING lpParameters, ;
		STRING lpDirectory, ;
		LONG nShowCmd
	=ShellExecute(0,"Open",lcfirefox,lclink,"",0)
Else
	oExplorer = Createobject("internetexplorer.Application")
	oExplorer.Navigate((lclink), " ")
	oExplorer.Visible=.T.
Endif

Use In Select('mwkRDMdatos')
Use In Select('mwkRDMmedico')
Use In Select('mwkRDMafiliacion')
Use In Select('mwkRDMentidad')
Use In Select('mwkRDMconsumo')
Use In Select('mwkdatmail')
