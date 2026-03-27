* Envía mensajes de Whapp a traves del servicio de Osana para Reprogramación y mails de Turnos 2021-11-01
* Acutalización: 2022-07-05 (Se agregó servicios QAS y llamada a devoluciòn de pago)

*Do sp_conexion

If !Used('mwkphorarios')
	Return
Endif

Select mwkphorarios
If !Reccount('mwkphorarios')>0
	Return
Endif

* Verificación a dónde se conecta
mccon = ''
mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)
Do Case
Case  (".190" $ mccon) && Desarrollo
	lclink1 = 'https://desa.sg.com.ar/ws-osana/sg-curl9.php?&idtur='
Case  (".50.110" $ mccon) && Desarrollo
	lclink1 = 'https://desa.sg.com.ar/ws-osana/sg-curl9.php?&idtur='
Case  (".50.102" $ mccon) && QAS
	lclink1 = 'https://serviciosqas.sg.com.ar/ws-osana/sg-curl9.php?&idtur='
Otherwise  && Producción
	lclink1 =  'https://servicios.sg.com.ar/ws-osana/sg-curl9.php?&idtur='
Endcase
* ----------------------------------------------

*lclink = prg_tablinks("SGCURL9")

If Empty(lclink1) Or "ERROR" $ Upper(lclink1)

	lcresp = "Error con la obtención del link"

Else

	lerror = .F.

	Select mwkphorarios

	Scan All

*	# Datos previos del turno
		buscoid = mwkphorarios.Id
		Select mwkphorarios_previo
		Go Top In "mwkphorarios_previo"
		Locate For mwkphorarios_previo.Id = buscoid
		lcpreviofecha = Dtoc(mwkphorarios_previo.Fechatur)
		lcpreviohora = mwkphorarios_previo.hora
		lcpreviomedico = nomedicolargo(mwkphorarios_previo.codmed)
		lcespe = especialidad(mwkphorarios_previo.codesp)

*	# Datos del paciente
		Select mwkphorarios
		lnregpac = mwkphorarios.afiliado
		lcsql = "select * from registracio where REG_nroregistrac = ?lnregpac"
		If !Prg_EjecutoSql(lcsql,'mwkPaciente')
			Return .F.
		Endif
		lcpaciente = Alltrim(mwkPaciente.REG_nombrepac)
		lcmail =  Alltrim(Nvl(mwkPaciente.REG_email,"NO TIENE"))
		lcmail = Iif(Empty(lcmail),"NO TIENE",lcmail)
*	-------------------------------

*	# Ambito
		lnambito = mxambito
		lcidturno = 'A-'+Alltrim(Str(lnambito))+'-I-'+Alltrim(Str(mwkphorarios.Id))

		lclugar = "SANATORIO GÜEMES"
		
		If mxcentromedico = 2
		lclugar = "Centro Médico Lima"
		Endif
		

		lclugar = buscacentro(mwkphorarios.Id)

		If lnambito > 1
			lnbuscoelambito = Nvl(mwkphorarios_previo.codambito,0)
			If lnbuscoelambito > 1
				lcsql = "select * from tabambito where id = ?lnbuscoelambito"
				If !Prg_EjecutoSql(lcsql,'mwkLugar')
					Return .F.
				Endif
				lclugar = Alltrim(mwkLugar.desclarga)
			Endif
		Endif
*	-------------------------------

*	# Profesional
		lcodmed = mwkphorarios.codmed
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

		lctrato        = "&trato=" + lctrato1
		lcprofnom   = "&profnom=" + mv1
		lcprofape    = "&profape=" + mv2

		lanio = Year(mwkphorarios.Fechatur)
		lmes = Month(mwkphorarios.Fechatur)
		ldia = Day(mwkphorarios.Fechatur)
		lhora = mwkphorarios.hora

* Datos para el mail turno reprogramado:
		lcmedico = lctrato1 + " " + mv1 + " " + mv2
		lcfecha = Dtoc(mwkphorarios.Fechatur)
		lchora =  mwkphorarios.hora
* ---------------------------

		lturnohorario = Alltrim(Str(lanio))+'-'+Padl(Alltrim(Str(lmes)),2,'0')+'-'+Padl(Alltrim(Str(ldia)),2,'0')+' '+lhora

		lcfechor      = "&fechor=" + lturnohorario && 2021-10-22 21:00 (Fecha + Hora Turno)

		lclink = lclink1 +"?&idtur=" + lcidturno + lctrato + lcprofnom + lcprofape + lcfechor
		lclink = Strtran(lclink,' ','%20')

*!*		loXmlHttp = Newobject( "Microsoft.XMLHTTP" )
*!*		lcresp = ''
*!*		lerror = .F.

*!*		If Vartype(loXmlHttp)="O"
*!*			loXmlHttp.Open( "POST" , lclink, .F. )
*!*			loXmlHttp.Send()
*!*			lcresp = Alltrim(loXmlHttp.responseText)
*!*			If 'ERROR' $ Upper(lcresp)
*!*				lerror = .T.
*!*			Endif
*!*			Release loXmlHttp
*!*		Endif

* 2022/01/03

*!*			Try
*!*				loXmlHttp = Createobject("MSXML2.XMLHTTP.6.0")
*!*				lcVersion = "6"
*!*			Catch
*!*				loXmlHttp = Createobject("MSXML2.XMLHTTP.3.0")
*!*				lcVersion = "3"
*!*			Endtry

*!*			loXmlHttp.Open( "POST" , lclink, .F. )
*!*			loXmlHttp.Send()
*!*			lcresp = Alltrim(loXmlHttp.responseText)

*!*			Do While loXmlHttp.readyState<>4
*!*				DoEvents
*!*			Enddo

*!*			If !loXmlHttp.Status = 200
*!*				Messagebox('Tipo de Error: '+Alltrim(Str(loXmlHttp.Status)),48,'Problemas con el Servidor')
*!*			Endif

*!*			If 'ERROR' $ Upper(lcresp)
*!*				lerror = .T.
*!*			Endif

*!*			Release loXmlHttp

		Local xmlHTTP As "Microsoft.XMLHTTP"
		xmlHTTP = Createobject("Microsoft.XMLHTTP")
		If Alltrim(Type("xmlHTTP")) <> "O"
			Messagebox( "No se pudo crear el objeto (XMLHTTP). No se pudo enviar la guía.",48,"Aviso")
			Return
		Endif
		xmlHTTP.Open("GET", lclink)
		xmlHTTP.Send()
		Do While xmlHTTP.readyState<>4
			DoEvents
		Enddo
		lcresp = xmlHTTP.responseText

		lnServidor = xmlHTTP.Status

		Wait Clear

		If !xmlHTTP.Status = 200
			Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
		Endif

		If !lcmail = "NO TIENE"
			*= Enviomail(lcpaciente,lcpreviomedico,lcespe,lcpreviofecha,lcpreviohora,lcmedico,lcfecha,lchora,lcmail,lclugar)
		Endif

		Use In Select('mwkTurnoId')
		Use In Select("mwkTurnoCancel")

		Release mreservacancel,lccancelreserva,lcidturno,lnambito,mbuscoidturno

		Select mwkphorarios
	Endscan

	If lerror
		Messagebox("Hubo errores en el envío de mensajes por Whatsapp",48,"Aviso")
	Else
		Messagebox("Los mensajes por Whatsapp fueron enviados correctamente",64,"Aviso")
	Endif

Endif


***** FUNCIONES ******


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
	lcarticulo = " la "
Else
	lctrato1 = Alltrim(mwkTrato.titulo)
	lcarticulo = " el "
Endif

lcnomdoc = lcarticulo + '<b>' + lctrato1 + " " + Alltrim(mv1) + " " + Alltrim(mv2) + "</b>"

Return lcnomdoc

Endfunc

*	# ENVIO MAIL
Function Enviomail(lcpaciente,lcpreviomedico,lcespe,lcpreviofecha,lcpreviohora,lcmedico,lcfecha,lchora,lmail)
cfile = 'c:\tempdoc\enviomailrepro.html'
If File(cfile)
	Delete File (cfile)
Endif

lccuerpo = "<h3> &#128075; Hola <b>"+lcpaciente+" ! </b></h3> <br>"
lccuerpo = lccuerpo + "<font size = 3> Soy el <b>asistente virtual del Sanatorio Güemes</b>, quería avisarte que tu turno con  " + lcpreviomedico + " para <b>" + lcespe + "</b> el día <b>" + lcpreviofecha + "</b> a las <b>" + lcpreviohora + "</b> fue <b>modificado.</b>. </font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> &#x26A0; Detalles de la modificación: </font><br>"
lccuerpo = lccuerpo + "<font size = 3> Profesional: <b>" + lcmedico + "</b></font><br>"
lccuerpo = lccuerpo + "<font size = 3> Fecha: <b>" + lcfecha + "</b></font><br>"
lccuerpo = lccuerpo + "<font size = 3> Hora: <b>" + lchora + "</b></font><br>"
lccuerpo = lccuerpo + "<font size = 3> Lugar de atención: <b>" + lclugar + "</b></font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> De no poder asistir te pedimos que canceles tu turno al <a href='https://bit.ly/sg_whatsapp'>+5491138545300 opción Cancelar Turno</a></font><br>"
lccuerpo = lccuerpo + "<font size = 3> Este es un <b>mensaje automático</b>, si tenés alguna duda o necesitás más información podés contactarte de lunes a viernes de 8 a 18 horas por:</font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241; WhatsApp al <a href='https://bit.ly/sg_whatsapp'>+5491138545300</a></font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#9742; Teléfono: llamando al 4959-8300 </font><br>"
lccuerpo = lccuerpo + "<font size = 3> Si necesitás solicitar uno nuevo, podés autogestionarlo a través de: </font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128187; Web: a través de <a href='https://www.sg.com.ar/sitio/sg-solicitar-turno.php'><b>SANATORIO GÜEMES</b></a> , sección 'Turnos' <//font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241;App: descargando la App desde Google Play Sanatorio Güemes Móvil - Aplicaciones en Google Play o App Store - Sanatorio Güemes Móvil <//font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Hasta luego &#128075;<//font><br>"

masunto = 'Sanatorio Güemes - Aviso Reprogramación Turno'

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
Function buscacentro(fidturno)
lclugar = ""
lfidturno = fidturno
lcsql = 'select * from turnos where id = ?lfidturno'
If !Prg_EjecutoSql(lcsql,'mwklugar')
	Return .F.
Endif
lnbuscopresta  	= mwkLugar.codprest
lnbuscomedico 	= mwkLugar.codmed
lndiasemana    	= mwkLugar.diasem
lfechaturno      	= mwkLugar.Fechatur
lhoraturno		= mwkLugar.hhmmTur

Use In Select('mwklugar')

lcsql = "select * from MedPresta where codprest = ?lnbuscopresta and codmed = ?lnbuscomedico and diasem = ?lndiasemana and  (?lfechaturno BETWEEN fecVigend and fecVigenH) and (?lhoraturno BETWEEN hhmmDes AND hhmmHas) AND sala like '%LIMA%'"
If !Prg_EjecutoSql(lcsql,'mwkLima')
	Return .F.
Endif
If Reccount('mwkLima')>0
	lclugar = "Centro Médico Lima"
Else
	lclugar = "Sanatorio Güemes"
Endif
Use In Select('mwkLima')
Return lclugar
Endfunc
