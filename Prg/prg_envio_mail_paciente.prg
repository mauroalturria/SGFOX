Lparameters reserva

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
*	lcmail = Iif(Empty(lcmail),"fcastelli@sg.com.ar",lcmail) && Quitar en producción
*lcmail = "fcastelli@sg.com.ar"
*lcmail = "gfernandez@sg.com.ar"
*	-------------------------------

	lnambito = mxambito

	lcidturno = 'A-'+Alltrim(Str(lnambito))+'-I-'+Alltrim(Str(mwkphorariosmail.Id))

* Datos para el mail turno:
	lcfecha = Dtoc(mwkphorariosmail.Fechatur)
	lchora =  Substr(Ttoc(mwkphorariosmail.horatur),12,5)
* ---------------------------

	If !lcmail="NO TIENE"
	= Enviomail(lcpaciente,lcespe,lcmedico,lcfecha,lchora,lcmail)
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
Function Enviomail(lcpaciente,lcespe,lcmedico,lcfecha,lchora,lmail)
cfile = 'c:\tempdoc\enviomailrepro.html'
If File(cfile)
	Delete File (cfile)
Endif

lccuerpo = "<h3> &#128075; Hola <b>"+lcpaciente+" ! </b></h3> <br>"
lccuerpo = lccuerpo + "<font size = 3> Soy el <b>asistente virtual del Sanatorio Güemes</b>, quería recordarte tu turno para <b>" + lcespe + "</b>. </font><br><br>"
*lccuerpo = lccuerpo + "<font size = 3> Profesional: <b>" + lcmedico + "</b></font><br>"
lccuerpo = lccuerpo + "<font size = 3> Fecha: <b>" + lcfecha + "</b></font><br>"
lccuerpo = lccuerpo + "<font size = 3> Hora: <b>" + lchora + "</b></font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> De no poder asistir te pedimos que canceles tu turno al <a href='https://bit.ly/sg_whatsapp'>+5491138545300</a> opción 7</font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Este es un <b>mensaje automático</b>, si tenés alguna duda o necesitás más información o necesitás un nuevo turno podés contactarte de lunes a viernes de 8 a 18 horas por:</font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241; WhatsApp al <a href='https://bit.ly/sg_whatsapp'>+5491138545300</a></font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#9742; Teléfono: llamando al 4959-8300 </font><br>"
lccuerpo = lccuerpo + "<font size = 3> Si necesitás solicitar uno nuevo, podés autogestionarlo a través de: </font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128187; Web: a través de <a href='https://www.sg.com.ar/sitio/sg-solicitar-turno.php'><b>SANATORIO GÜEMES</b></a> , sección 'Turnos' <//font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241;App: descargando la App desde Google Play Sanatorio Güemes Móvil - Aplicaciones en Google Play o App Store? Sanatorio Güemes Móvil <//font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Hasta luego &#128075;<//font><br>"

masunto = 'Sanatorio Güemes - Aviso Turno ' + lcespe

Strtofile(lccuerpo,cfile)

archivo = "file://"+cfile

Try
	Local lcSchema, loConfig, loMsg, loError, lcErr
	lcErr = ""
	lcSchema = "http://schemas.microsoft.com/cdo/configuration/"
	loConfig = Createobject("CDO.Configuration")
	With loConfig.Fields
		.Item(lcSchema + "smtpserver") = "smtp.gmail.com"
		.Item(lcSchema + "smtpserverport") = 465 && ó 587
		.Item(lcSchema + "sendusing") = 2
		.Item(lcSchema + "smtpauthenticate") = .T.
		.Item(lcSchema + "smtpusessl") = .T.
		.Item(lcSchema + "sendusername") = "turnos@sg.com.ar" && "informespacientes@sg.com.ar"
		.Item(lcSchema + "sendpassword") = "call2022" && "sanatorio"
		.Update
	Endwith
	loMsg = Createobject ("CDO.Message")
	With loMsg
		.Configuration = loConfig
		.From = "Turnos SG <turnos@sg.com.ar>" && "Turnos SG <informespacientes@sg.com.ar>"
		.To = lmail && "gfernandez@sg.com.ar" && "fcastelli@sg.com.ar"
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
*		Messagebox("El mensaje se envió con éxito", 64, "Aviso")
	Else
*		Messagebox(lcErr, 16 , "Error")
	Endif
Endtry

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
