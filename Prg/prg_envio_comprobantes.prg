Parameters pnrovale,archivopdf

lcpaciente = ""
lcmail = ""
lnvale = pnrovale

Wait "Buscando datos del paciente. Aguarde por favor" Window Nowait Noclear
TEXT To lcsql Noshow
select REG_nombrepac,reg_email  from VALESASIST 
left join pacientes on sqluser.pacientes.PAC_codadmision = sqluser.VALESASIST.VAL_codadmision 
left join registracio on sqluser.REGISTRACIO.REG_nroregistrac = sqluser.pacientes.PAC_codhci 
where VAL_codvaleasist = ?lnvale
ENDTEXT

If !Prg_EjecutoSql(lcsql,'mwkDatosPac')
	Messagebox("Problemas con la consulta de datos (mwkDatosPac)",48,"AVISO")
	Return .F.
Endif

Wait Clear

lsigo = .T.
lcpaciente = Alltrim(mwkDatosPac.REG_nombrepac)
lcmail = Alltrim(mwkDatosPac.REG_email)
If "NO TIENE" $ Upper(lcmail)
	lsigo = .F.
Endif
If Empty(lcmail)
	lsigo = .F.
Endif
If Isnull(lcmail)
	lsigo = .F.
Endif

If !lsigo
	Return
Endif


Wait "Enviando E-mail al paciente. Aguarde por favor" Window Nowait Noclear
cfile = 'c:\tempdoc\enviomailcomp.html'
If File(cfile)
	Delete File (cfile)
Endif

lccuerpo = "<h3> &#128075; Hola <b>"+lcpaciente+" ! </b></h3> <br>"
lccuerpo = lccuerpo + "<font size = 3> Soy el <b>asistente virtual del Sanatorio Güemes</b>, te adjuntamos tu factura. </font><br><br>"

lccuerpo = lccuerpo + "<font size = 3> Si necesitás solicitar un turno, podés autogestionarlo a través de: </font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128187; Web: a través de <a href='https://www.sg.com.ar/sitio/sg-solicitar-turno.php'><b>SANATORIO GÜEMES</b></a> , sección 'Turnos' <//font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241;App: descargando la App desde Google Play Sanatorio Güemes Móvil - Aplicaciones en Google Play o App Store - Sanatorio Güemes Móvil <//font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Hasta luego &#128075;<//font><br><br>"
lccuerpo = lccuerpo + "<font size = 2> Esta es una casilla para envío de mails automáticos. Por favor no responda a éste mail. Use los medios de comunicación mencionados en el texto.<//font><br><br>"

masunto = 'Sanatorio Güemes - Envío de comprobante '

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
		.To = lcmail
		.Subject = Alltrim(masunto)
		cfile = archivo
		.CreateMHTMLBody(cfile, 0)
		.AddAttachment(archivopdf)
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
