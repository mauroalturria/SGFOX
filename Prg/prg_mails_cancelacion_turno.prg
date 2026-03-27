Parameters idturno

*Do sp_conexion
*mcodreserva = "9302260-0"
*idturno = 19302260

midturno = idturno

* - - - TURNO DEL PACIENTE

*!*	TEXT To lcsql noshow
*!*	select id,codent,codesp,codmed,codprest,codreserva,codserv,fechatur,horatur,
*!*	pre_descriprest,reg_nroregistrac,reg_nombrepac,reg_sexo,reg_email,reg_numdocumento,reg_telefonos
*!*	from turnos
*!*	inner join SQLUser.PRESTACIONS on turnos.codprest = sqluser.PRESTACIONS.PRE_codprest
*!*	inner join SQLUser.REGISTRACIO on turnos.afiliado = registracio.REG_nroregistrac
*!*	where turnos.codreserva = ?mcodreserva
*!*	ENDTEXT

TEXT To lcsql noshow
select id,codent,codesp,codmed,codprest,codreserva,codserv,fechatur,horatur,
pre_descriprest,reg_nroregistrac,reg_nombrepac,reg_sexo,reg_email,reg_numdocumento,reg_telefonos
from turnos
inner join SQLUser.PRESTACIONS on turnos.codprest = sqluser.PRESTACIONS.PRE_codprest
inner join SQLUser.REGISTRACIO on turnos.afiliado = registracio.REG_nroregistrac
where turnos.id = ?midturno
ENDTEXT

If !Prg_EjecutoSql(lcSql,'mwkturno')
	Return .F.
Endif

*!*	* - - - Consulta de Exclusión (Si la consulta trae registros, no enviá wapp)

*!*	mCodMed  = mwkTurno.codmed
*!*	mCodPres = mwkTurno.codprest
*!*	mCodEsp  = Alltrim(mwkTurno.codesp)
*!*	lexistefiltro = prg_osana_mensajes_filtros(mCodEsp,mCodPres,mCodMed,lcTipoConsulta)

*!*	If lexistefiltro
*!*		Return .F.
*!*	Endif

*	# Paciente
mregistracio = mwkTurno.reg_nroregistrac
lcpaciente = filtrochar(Alltrim(mwkTurno.reg_nombrepac))
lhaycoma = At(',',lcpaciente,1)
mv4 = Substr(lcpaciente,1,lhaycoma-1) && Apellido
mv4 = Strtran(mv4,'#','Ñ')
mv3 = Substr(lcpaciente,lhaycoma+1,Len(lcpaciente)-Len(mv4))  && Nombre
mv3 = Strtran(mv3,'#','Ñ')
mv6 = Iif(Isnull(Alltrim(mwkTurno.reg_email)),'NO TIENE',Alltrim(mwkTurno.reg_email)) && eMail

If mv6 = "NO TIENE" && Sin mail no sigue
	Return .F.
Endif

mdestinatario = mv6

*	# Profesional
midcodmed = mwkTurno.codmed
Do sp_busco_medico_dat With midcodmed
lcdatprof = Alltrim(mwkdatmed.nombre)
lcdatprof = filtrochar(lcdatprof)
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
lcSql = "select * from SQLUser.TabProfesion where id = ?lncodprof"
If !Prg_EjecutoSql(lcSql,'mwkTrato')
	Return .F.
Endif
lctrato = ""
Select mwkTrato
If lcsexo = "F"
	lctrato = Alltrim(mwkTrato.titulof)
	lcarticulo = " la "
Else
	lctrato = Alltrim(mwkTrato.titulo)
	lcarticulo = " el "
Endif

* - - - DATOS A ENVIAR
lcpaciente = mv3 + " " + mv4
lcmedico = lctrato + " " + mv1 +" " + mv2
lchora = Left(Alltrim(Ttoc(mwkTurno.horatur,2)),5)
lcfecha = Dtoc(mwkTurno.fechatur)

* - - - ENVIO MAIL

cfile = 'c:\tempdoc\enviomailcancelacion.html'
If File(cfile)
	Delete File (cfile)
Endif

lccuerpo = "<h3> &#128075; Hola <b>"+lcpaciente+" ! </b></h3> <br>"
lccuerpo = lccuerpo + "<font size = 3> Soy el <b>asistente virtual del Sanatorio Güemes</b>, quería avisarte que tu turno con  " + lcarticulo + "<b>" + lcmedico + "</b> fue <b>cancelado</b>. </font><br>"
lccuerpo = lccuerpo + "<font size = 3> Te pido disculpas por este inconveniente &#128542; </font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Detalles del turno cancelado: </font><br>"
lccuerpo = lccuerpo + "<font size = 3> Fecha: " + lcfecha + "</font><br>"
lccuerpo = lccuerpo + "<font size = 3> Hora: " + lchora + "</font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Este es un <b>mensaje automático</b>, si tenés alguna duda o necesitás más información podés contactarte de lunes a viernes de 8 a 18 horas por:</font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241; WhatsApp al <a href='https://bit.ly/sg_whatsapp'>+5491138545300</a></font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#9742; Teléfono: llamando al 4959-8300 </font><br>"
lccuerpo = lccuerpo + "<font size = 3> Si necesitás solicitar uno nuevo, podés autogestionarlo a través de: </font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128187; Web: a través de <a href='https://www.sg.com.ar/sitio/sg-solicitar-turno.php'><b>SANATORIO GÜEMES</b></a> , sección 'Turnos' <//font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241;App: descargando la App desde Google Play Sanatorio Güemes Móvil - Aplicaciones en Google Play o App Store? Sanatorio Güemes Móvil <//font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Hasta luego &#128075;<//font><br>"

masunto = 'Sanatorio Güemes - Aviso Cancelación Turno'

Strtofile(lccuerpo,cfile)

archivo = "file://"+cfile

Wait "Enviando mail..."

lcSql = "select * from tabestados where propietario = 4 and tipo = 59 order by estado"
If !Prg_EjecutoSql(lcSql,'mwkCuenta')
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
		.To = mdestinatario
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
Wait Clear

*!*	Try
*!*		Local lcSchema, loConfig, loMsg, loError, lcErr
*!*		lcErr = ""
*!*		lcSchema = "http://schemas.microsoft.com/cdo/configuration/"
*!*		loConfig = Createobject("CDO.Configuration")
*!*		With loConfig.Fields
*!*			.Item(lcSchema + "smtpserver") = "smtp.gmail.com"
*!*			.Item(lcSchema + "smtpserverport") = 465 && ó 587
*!*			.Item(lcSchema + "sendusing") = 2
*!*			.Item(lcSchema + "smtpauthenticate") = .T.
*!*			.Item(lcSchema + "smtpusessl") = .T.
*!*			.Item(lcSchema + "sendusername") = "turnos@sg.com.ar" && "informespacientes@sg.com.ar"
*!*			.Item(lcSchema + "sendpassword") = "call2022" && "sanatorio"
*!*			.Update
*!*		Endwith
*!*		loMsg = Createobject ("CDO.Message")
*!*		With loMsg
*!*			.Configuration = loConfig
*!*			.From = "Turnos SG <turnos@sg.com.ar>" && "Turnos SG <informespacientes@sg.com.ar>"
*!*			.To = mdestinatario && "gfernandez@sg.com.ar" && "fcastelli@sg.com.ar"
*!*			.Subject = Alltrim(masunto)
*!*			cfile = archivo
*!*			.CreateMHTMLBody(cfile, 0)
*!*	*    .TextBody = Alltrim(mCuerpo)
*!*			.Send()
*!*		Endwith
*!*	Catch To loError
*!*		lcErr = [Error: ] + Str(loError.ErrorNo) + Chr(13) + ;
*!*			[Linea: ] + Str(loError.Lineno) + Chr(13) + ;
*!*			[Mensaje: ] + loError.Message
*!*	Finally
*!*		Release loConfig, loMsg
*!*		Store .Null. To loConfig, loMsg
*!*		If Empty(lcErr)
*!*	*		Messagebox("El mensaje se envió con éxito", 64, "Aviso")
*!*		Else
*!*	*		Messagebox(lcErr, 16 , "Error")
*!*		Endif
*!*	Endtry

* - - - FIN ENVIO MAIL

Function filtrochar(FiltroCadena)
NewCadena = ''
Cadena = Alltrim(Upper(FiltroCadena))
Cadena = Strtran(Cadena,'Ñ','N')
Cadena = Strtran(Cadena,'Á','A')
Cadena = Strtran(Cadena,'É','E')
Cadena = Strtran(Cadena,'Í','I')
Cadena = Strtran(Cadena,'Ó','O')
Cadena = Strtran(Cadena,'Ú','U')

For nLong = 1 To Len(Cadena)
	cChar = Substr(Cadena,nLong,1)
	nChar = Asc(cChar)
	If Between(nChar,65,90) Or Inlist(nChar,32,44)
		NewCadena = NewCadena + cChar
	Endif
Endfor

Return NewCadena
Endfunc
