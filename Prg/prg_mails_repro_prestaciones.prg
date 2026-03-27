Lparameters reserva

*!*	Do sp_conexion
*!*	reserva = "9315293-8"
*!*	reserva = "9754498-9"
*!*	reserva = "9315494-9" && Desarrollo

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
*-------------------------------

lnambito = mxambito

lcidturno = 'A-'+Alltrim(Str(lnambito))+'-I-'+Alltrim(Str(mwkphorariosmail.Id))

* Datos para el mail turno:
lcfecha = Dtoc(mwkphorariosmail.Fechatur)
lchora =  Substr(Ttoc(mwkphorariosmail.horatur),12,5)
* ---------------------------

If !lcmail="NO TIENE"
	lcenvio = Enviomail(lcpaciente,lcespe,lcmedico,lcfecha,lchora,lcmail,lcTipoConsulta)
Endif

Use In Select('mwkTurnoId')
Use In Select("mwkTurnoCancel")

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
Function Enviomail(lcpaciente,lcespe,lcmedico,lcfecha,lchora,lmail,lcTipoConsulta)
Wait "Enviando E-mail al paciente. Aguarde por favor" Window Nowait Noclear 
cfile = 'c:\tempdoc\enviomailcambio.html'
If File(cfile)
	Delete File (cfile)
Endif

lccuerpo = "<h3> &#128075; Hola <b>"+lcpaciente+" ! </b></h3> <br>"
lccuerpo = lccuerpo + "<font size = 3> Te escribo desde el Sanatorio Güemes para avisarte que tuvimos que modificar la modalidad de tu turno presencial a telemedicina (videoconsulta) con <b>" + lcmedico + "</b></font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Agradecemos tu paciencia y colaboración en estos momentos. Sigamos cuidándonos juntos.:</font><br>"
lccuerpo = lccuerpo + "<font size = 3> Te recuerdo los detalles del turno y que 30 minutos antes recibirás el link para poder ingresar:</font><br>"
lccuerpo = lccuerpo + "<font size = 3> Profesional: <b>" + lcmedico + "</b></font><br>"
lccuerpo = lccuerpo + "<font size = 3> Fecha: <b>" + lcfecha + "</b></font><br>"
lccuerpo = lccuerpo + "<font size = 3> Hora: <b>" + lchora + "</b></font><br><br>"
If lcTipoConsulta = "V"
	lccuerpo = lccuerpo + "<font size = 3> Para realizar la <b>videoconsulta</b> de manera exitosa es importante que: <//font><br>"
	lccuerpo = lccuerpo + "<font size = 3> &#10004; Elijas un <b>espacio privado</b>, evitando ruidos que puedan interferirla.<//font><br>"
	lccuerpo = lccuerpo + "<font size = 3> &#10004; Tengas una <b>buena conexión a internet</b>.<//font><br>"
	lccuerpo = lccuerpo + "<font size = 3> &#10004; Chequees que tu <b>cámara</b> y <b>micrófono</b> funcionen <b>correctamente</b>.<//font><br>"
	lccuerpo = lccuerpo + "<font size = 3> Podes ver <b>videos</> de como realizar la videoconsulta en los siguientes links:<//font><br>"
	lccuerpo = lccuerpo + "<font size = 3> &#128241; Si la videoconsulta es por WhatsApp: <a href='https://www.sg.com.ar/sitio/videos/videoconsulta_whapp.mp4'> Ingresá a este link para ver el tutorial.</a></font><br>"
	lccuerpo = lccuerpo + "<font size = 3> &#128187; Si la videoconsulta es por Mi Salud Online: <a href='https://youtu.be/tPrAw6DRaFs'> Ingresá a este link para ver el tutorial.</a></font><br><br>"
Endif
lccuerpo = lccuerpo + "<font size = 3> De no poder asistir te pedimos que canceles tu turno al <a href='https://bit.ly/sg_whatsapp'>+5491138545300</a> opción <b>Cancelar Turno</b></font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Este es un <b>mensaje automático</b>, si tenés alguna duda o necesitás más información o necesitás un nuevo turno podés contactarte de lunes a viernes de 8 a 18 horas por:</font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241; WhatsApp al <a href='https://bit.ly/sg_whatsapp'>+5491138545300</a></font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#9742; Teléfono: llamando al 4959-8300 </font><br>"
lccuerpo = lccuerpo + "<font size = 3> Si necesitás solicitar uno nuevo, podés autogestionarlo a través de: </font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128187; Web: a través de <a href='https://www.sg.com.ar/sitio/sg-solicitar-turno.php'><b>SANATORIO GÜEMES</b></a> , sección 'Turnos' <//font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241;App: descargando la App desde Google Play Sanatorio Güemes Móvil - Aplicaciones en Google Play o App Store? Sanatorio Güemes Móvil <//font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Hasta luego &#128075;<//font><br><br>"
lccuerpo = lccuerpo + "<font size = 2> Esta es una casilla para envío de mails automáticos. Por favor no responda a éste mail. Use los medios de comunicación mencionados en el texto.<//font><br><br>"

masunto = 'Sanatorio Güemes - Aviso Reprogramación de Prestacion ' + lcespe

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
*Messagebox(lcErr, 16 , "Error")
	Endif
Endtry

Use In Select('mwkCuenta')
Wait clear

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
