Lparameters reserva

LOCAL cLinkPago 
LOCAL cClaveUnica 
LOCAL lHabLinkpago
LOCAL lBotonPagado

* Versión Actualizada: 2022-07-27
* Actualización 2022-08-01 - Limitación a Hospital de Día / Fono

* - - - Datos Prueba
*Do sp_conexion
*reserva = "9321105-5"
*reserva = "9304897-9"
*reserva = "9315494-9" && Desarrollo Turno VC SG
*reserva = "9316224-0" && Desarrollo Turno PRESENCIAL SG
*reserva = "3936307-1" && Desarrollo Turno PRESENCIAL POLI
*reserva = "3936327-6" && Desarrollo Turno PRESENCIAL POLI
*reserva = "9859521-8" && REAL
* Set Step On
* - - - Fin Datos Prueba

mreserva = reserva

lcsql = 'select * from turnos where codreserva = ?mreserva'
If !Prg_EjecutoSql(lcsql,'mwkphorariosmail')
	Return .F.
Endif

If !Used('mwkphorariosmail')
	Return
Endif

Select mwkphorariosmail
If !Reccount('mwkphorariosmail')>0
	Return
Endif

*	# No dejo enviar mensajería para los siguientes servicios

If  Inlist(mwkphorariosmail.codserv,1130)
	Return .F.
Endif


*	# Busco tipo de turno (Presencial / Virtual)
lncodprest = mwkphorariosmail.codprest
lcsql = 'select * from PRESTACIONS where PRE_codprest = ?lncodprest'
If !Prg_EjecutoSql(lcsql,'mwktipoturno')
	Return .F.
Endif
lcpresta = Upper(Alltrim(mwktipoturno.pre_descriprest))
Use In Select('mwktipoturno')
lcTipoturno = ''
lcTipoConsulta = ''
lturnodistancia = At('DISTANCIA',Alltrim(lcpresta))>0
If lturnodistancia
	lcTipoturno = 'VIRTUAL'
	lcTipoConsulta = 'V'
Else
	lcTipoturno = 'PRESENTIAL'
	lcTipoConsulta = 'P'
Endif

*	# Filtro prestaciones para Foniatría que son presenciales (JIRA GGP-2079)
lpaso = .T.

If lturnodistancia And mwkphorariosmail.codesp = "FONI"
	lpaso = .T.
Endif

If !lturnodistancia And mwkphorariosmail.codesp = "FONI"
	lpaso = .f.
Endif

If !lpaso
	Return .F.
Endif

*	# Consulta de Exclusión (Si la consulta trae registros, no enviá wapp)
mCodMed  = mwkphorariosmail.codmed
mCodPres = mwkphorariosmail.codprest
mCodEsp  = Alltrim(mwkphorariosmail.codesp)
lexistefiltro = prg_osana_mensajes_filtros(mCodEsp,mCodPres,mCodMed,lcTipoConsulta)

If lexistefiltro
	Return .F.
Endif

*	# Datos previos del turno
buscoid = mwkphorariosmail.Id
lcmedico = nomedicolargo(mwkphorariosmail.codmed)
lcespe = especialidad(mwkphorariosmail.codesp)

*	# Datos del paciente
Select mwkphorariosmail
lnregpac = mwkphorariosmail.afiliado
lcsql = "select * from registracio where REG_nroregistrac = ?lnregpac"
If !Prg_EjecutoSql(lcsql,'mwkPaciente')
	Return .F.
Endif
lcpaciente = Alltrim(mwkPaciente.REG_nombrepac)
lcmail =  Alltrim(Nvl(mwkPaciente.REG_email,"NO TIENE"))
lcmail = Iif(Empty(lcmail),"NO TIENE",lcmail)

If mwkusuario.codigovax = 57814
	lcmail = "fcastelli@sg.com.ar"
Endif


*-------------------------------

* Ambito turno del paciente // Tener en cuenta que solo puede consultar el ambito si el turno se da desde polis, sino por defecto es SG ya que en la tabla no hay
* campo de ambito
lnambito = mxambito
lcidturno = 'A-'+Alltrim(Str(lnambito))+'-I-'+Alltrim(Str(mwkphorariosmail.Id))
*lclugar = "SANATORIO GÜEMES"
lclugar =  buscacentro(mwkphorariosmail.codprest,mwkphorariosmail.codmed,mwkphorariosmail.diasem,mwkphorariosmail.fechatur,mwkphorariosmail.hhmmTur)

If lnambito > 1
	lnbuscoelambito = Nvl(mwkphorariosmail.codambito,0)
	If lnbuscoelambito > 1
		lcsql = "select * from tabambito where id = ?lnbuscoelambito"
		If !Prg_EjecutoSql(lcsql,'mwkLugar')
			Return .F.
		Endif
		lclugar = Alltrim(mwkLugar.desclarga)
	Endif
Endif
* -----------------------------------


* Datos para el mail turno:
Select mwkphorariosmail
lcturnos = ""
Scan All
	lcfecha = Dtoc(mwkphorariosmail.fechatur)
	lchora =  Substr(Ttoc(mwkphorariosmail.horatur),12,5)
	lcturnos = lcturnos + "<font size = 3> Fecha: <b>" + lcfecha + "</b>  -  Hora: <b>" + lchora + "</b></font><br>"
	Select mwkphorariosmail
Endscan
* ---------------------------
* Obtener Link de Pago
* Marcelo Torres, 20/12/2022

* SET STEP ON

GO TOP IN ("mwkphorariosmail")

cLinkPago = ""
cClaveUnica = ""

lHabLinkpago = (mxambito = 1 .and. sp_busco_ent_linkpago(mwkphorariosmail.codEnt))

If lHabLinkpago

	lBotonPagado = sp_verifica_boton_pago(mwkphorariosmail.Id)  &&Devuelve .t. si ya pagó.
	If Used("mwkbpago")

		Select mwkbpago
		Go Top
		cLinkPago = mwkbpago._urldeudor
		cClaveUnica = mwkbpago._claveunica

	Endif

Endif

* ------------------------------------
 * SET STEP ON

If !lcmail="NO TIENE"
*	lcenvio = Enviomail(lcpaciente,lcespe,lcmedico,lcfecha,lchora,lcmail,lcTipoConsulta,lclugar)
	lcenvio = Enviomail(lcpaciente,lcespe,lcmedico,lcturnos,lcmail,lcTipoConsulta,lclugar,cLinkPago)
Endif

* SET STEP ON

Use In Select('mwkTurnoId')
Use In Select("mwkTurnoCancel")
Use In Select("mwkbpago")

Release mreservacancel,lccancelreserva,lcidturno,lnambito,mbuscoidturno



*	# ARMO NOMBRE LARGO DEL MEDICO
Function nomedicolargo (codigomedico)

*	# Profesional
lcodmed = codigomedico
Do sp_busco_medico_dat With lcodmed
lcdatprof = Alltrim(mwkdatmed.nombre)
lhaycoma = At(',',lcdatprof,1)
If lhaycoma > 0
	mv2 = Substr(lcdatprof,1,lhaycoma-1) && Apellido
	mv2 = Strtran(mv2,'#','Ñ')
	mv1 = Substr(lcdatprof,lhaycoma+1,Len(lcdatprof)-Len(mv2)) && Nombre
	mv1 = Strtran(mv1,'#','Ñ')
Else
	lhayespacio = At(' ',lcdatprof)
	mv2 = Substr(lcdatprof,1,lhayespacio-1) && Apellido
	mv2 = Strtran(mv2,'#','Ñ')
	mv1 = Substr(lcdatprof,lhayespacio+1,Len(lcdatprof)-Len(mv2)) && Nombre
	mv1 = Strtran(mv1,'#','Ñ')
Endif

*	# Trato del Profesional
lncodprof = mwkdatmed.codprof
lcsexo = Alltrim(mwkdatmed.sexo)
lcsql = "select * from SQLUser.TabProfesion where id = ?lncodprof"
If !Prg_EjecutoSql(lcsql,'mwkTrato')
	Return .F.
Endif
lctrato = ""
Select mwkTrato
If lcsexo = "F"
	lctrato1 = Alltrim(mwkTrato.titulof)
Else
	lctrato1 = Alltrim(mwkTrato.titulo)
Endif

lcnomdoc =  '<b>' + lctrato1 + " " + Alltrim(mv1) + " " + Alltrim(mv2) + "</b>"

Return lcnomdoc

Endfunc

*	# ENVIO MAIL
Function Enviomail(lcpaciente,lcespe,lcmedico,lcturnos,lmail,lcTipoConsulta,lclugar,cLinkPago)
Wait "Enviando E-mail al paciente. Aguarde por favor" Window Nowait Noclear
cfile = 'c:\tempdoc\enviomailturno.html'
If File(cfile)
	Delete File (cfile)
Endif

lccuerpo = "<h3> &#128075; Hola <b>"+lcpaciente+" ! </b></h3> <br>"
lccuerpo = lccuerpo + "<font size = 3> Soy el <b>asistente virtual del Sanatorio Güemes</b>, quería recordarte tu turno para <b>" + lcespe + "</b>. </font><br><br>"
lccuerpo = lccuerpo + lcturnos
lccuerpo = lccuerpo + "<font size = 3> Profesional: <b>" + lcmedico + "</b></font><br>"
*lccuerpo = lccuerpo + "<font size = 3> Fecha: <b>" + lcfecha + "</b></font><br>"
*lccuerpo = lccuerpo + "<font size = 3> Hora: <b>" + lchora + "</b></font><br>"

If Nvl(cLinkPago,"") <> ""
	lccuerpo = lccuerpo + "<font size = 3> Link de Pago: <b>" + cLinkPago + "</b></font><br>"
Endif

If lcTipoConsulta = "V"
	lccuerpo = lccuerpo + "<br><font size = 3> Para realizar la <b>videoconsulta</b> de manera exitosa es importante que: <//font><br>"
	lccuerpo = lccuerpo + "<font size = 3> &#10004; Elijas un <b>espacio privado</b>, evitando ruidos que puedan interferirla.<//font><br>"
	lccuerpo = lccuerpo + "<font size = 3> &#10004; Tengas una <b>buena conexión a internet</b>.<//font><br>"
	lccuerpo = lccuerpo + "<font size = 3> &#10004; Chequees que tu <b>cámara</b> y <b>micrófono</b> funcionen <b>correctamente</b>.<//font><br>"
	lccuerpo = lccuerpo + "<font size = 3> Podes ver <b>videos</> de como realizar la videoconsulta en los siguientes links:<//font><br>"
	lccuerpo = lccuerpo + "<font size = 3> &#128241; Si la videoconsulta es por WhatsApp: <a href='https://www.sg.com.ar/sitio/videos/videoconsulta_whapp.mp4'> Ingresá a este link para ver el tutorial.</a></font><br>"
	lccuerpo = lccuerpo + "<font size = 3> &#128187; Si la videoconsulta es por Mi Salud Online: <a href='https://youtu.be/tPrAw6DRaFs'> Ingresá a este link para ver el tutorial.</a></font><br><br>"
Else
	lccuerpo = lccuerpo + "<font size = 3> Lugar de atención: <b>" + lclugar + "</b></font><br><br>"
Endif
lccuerpo = lccuerpo + "<font size = 3> De no poder asistir te pedimos que canceles tu turno al <a href='https://bit.ly/sg_whatsapp'>+5491138545300</a> opción <b>Cancelar Turno</b></font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Este es un <b>mensaje automático</b>, si tenés alguna duda o necesitás más información o necesitás un nuevo turno podés contactarte de lunes a viernes de 8 a 20 horas por:</font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241; WhatsApp al <a href='https://bit.ly/sg_whatsapp'>+5491138545300</a></font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#9742; Teléfono: llamando al 4959-8300 </font><br>"
lccuerpo = lccuerpo + "<font size = 3> Si necesitás solicitar uno nuevo, podés autogestionarlo a través de: </font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128187; Web: a través de <a href='https://www.sg.com.ar/sitio/sg-solicitar-turno.php'><b>SANATORIO GÜEMES</b></a> , sección 'Turnos' <//font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241;App: descargando la App desde Google Play Sanatorio Güemes Móvil - Aplicaciones en Google Play o App Store - Sanatorio Güemes Móvil <//font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Hasta luego &#128075;<//font><br><br>"
lccuerpo = lccuerpo + "<font size = 2> Esta es una casilla para envío de mails automáticos. Por favor no responda a éste mail. Use los medios de comunicación mencionados en el texto.<//font><br><br>"

masunto = 'Sanatorio Güemes - Aviso Turno ' + lcespe

Strtofile(lccuerpo,cfile)

archivo = "file://"+cfile

lcsql = "select * from tabestados where propietario = 4 and tipo = 59 order by estado"
If !Prg_EjecutoSql(lcsql,'mwkCuenta')
	Return .F.
Endif
Select mwkCuenta

If !Used('mwkCuenta')
	Messagebox("Problemas para recuperar datos de configuración",16,"Error en envío de E-Mail")
	Return .F.
Endif

If Reccount('mwkCuenta')=0
	Messagebox("No hay datos de configuración",16,"Error en envío de E-Mail")
	Return .F.
Endif

Go Top In 'mwkCuenta'
Locate For estado = 1
lcdato1 = Alltrim(mwkCuenta.Descrip)
Locate For estado = 2
lcdato2 = Int(Val(Alltrim(mwkCuenta.Descrip)))
Locate For estado = 3
lcdato3 = Int(Val(Alltrim(mwkCuenta.Descrip)))
Locate For estado = 4
lcdato4 = Iif(Alltrim(Upper(mwkCuenta.Descrip))="T",.T.,.F.)
Locate For estado = 5
lcdato5 = Iif(Alltrim(Upper(mwkCuenta.Descrip))="T",.T.,.F.)
Locate For estado = 6
lcdato6 = Alltrim(mwkCuenta.Descrip)
Locate For estado = 7
lcdato7 = Alltrim(mwkCuenta.Descrip)
Locate For estado = 8
lcdato8 = Alltrim(mwkCuenta.Descrip)


Try
	Local lcSchema, loConfig, loMsg, loError, lcErr
	lcErr = ""
	lcSchema = "http://schemas.microsoft.com/cdo/configuration/"
	loConfig = Createobject("CDO.Configuration")
	With loConfig.Fields
		.Item(lcSchema + "smtpserver") = lcdato1
		.Item(lcSchema + "smtpserverport") = lcdato2
		.Item(lcSchema + "sendusing") = lcdato3
		.Item(lcSchema + "smtpauthenticate") = lcdato4
		.Item(lcSchema + "smtpusessl") = lcdato5
		.Item(lcSchema + "sendusername") = lcdato6
		.Item(lcSchema + "sendpassword") = lcdato7
		.Update
	Endwith
	loMsg = Createobject ("CDO.Message")
	With loMsg
		.Configuration = loConfig
		.From = lcdato8
		.To = lmail
		.Subject = Alltrim(masunto)
		cfile = archivo
		.CreateMHTMLBody(cfile, 0)
*    .TextBody = Alltrim(mCuerpo)
		.Send()
	Endwith
Catch To loError
	lcErr = [Error: ] + Str(loError.ErrorNo) + Chr(13) + ;
		[Linea: ] + Str(loError.Lineno) + Chr(13) + ;
		[Mensaje: ] + loError.Message
Finally
	Release loConfig, loMsg
	Store .Null. To loConfig, loMsg
	If Empty(lcErr)
*Messagebox("El mensaje se envió con éxito", 64, "Aviso")
	Else
		Messagebox(lcErr, 16 , "Error al Enviar E-Mail")
	Endif
Endtry

Use In Select('mwkCuenta')
Wait Clear

Endfunc


*	# ESPECIALIDAD
Function especialidad(lcCodEsp)
mlcCodEsp = lcCodEsp
lcNombreEspecialidad = ""
lcsql = "select ESP_descripcion from ESPECIALID WHERE ESP_codesp = ?mlcCodEsp"
If !Prg_EjecutoSql(lcsql,'mwkEspecialidad')
	Return .F.
Endif
Select mwkEspecialidad
If Reccount("mwkEspecialidad")>0
	lcNombreEspecialidad = Alltrim(mwkEspecialidad.ESP_descripcion)
Endif
Use In Select("mwkEspecialidad")
Return lcNombreEspecialidad  && Especialidad
Endfunc

* # BUSCA SI ES SG O CENTRO LIMA
Function buscacentro(fcodprest,fcodmed,fdiasem,ffechatur,fhhmmTur)
lclugar = ""
lnbuscopresta  	= fcodprest
lnbuscomedico 	= fcodmed
lndiasemana    	= fdiasem
lfechaturno      	= ffechatur
lhoraturno		= fhhmmTur

lcsql = "select * from MedPresta where codprest = ?lnbuscopresta and codmed = ?lnbuscomedico and diasem = ?lndiasemana and  (?lfechaturno BETWEEN fecVigend and fecVigenH) and (?lhoraturno BETWEEN hhmmDes AND hhmmHas) AND sala like '%LIMA%'"
If !Prg_EjecutoSql(lcsql,'mwkLima')
	Return .F.
Endif
If Reccount('mwkLima')>0
	lclugar = "Centro Médico Lima &#128205;"
Else
	lclugar = "Sanatorio Güemes"
Endif
Use In Select('mwkLima')
Return lclugar
Endfunc
