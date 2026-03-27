Lparameters valor

* Set Step On 

* Envio mail de epicrisis al paciente 2021/12/14
* Modificaciòn de texto 2022/10/12

*valor = "3749316-9"
*Do sp_conexion

mhc = valor

lcsql = "select * from SQLUser.REGISTRACIO where REG_nrohclinica = ?mhc"

If !Prg_EjecutoSql(lcsql,'mwkRegPac')
	Return .F.
Endif

lcNombre = Alltrim(mwkRegPac.REG_nombrepac)
lcMail = Alltrim(mwkRegPac.REG_email)

lexistemail = 'NO TIENE' $ Upper(lcMail)

If lexistemail
	Return .F.
Endif


* Armo el texto del mail
If !Directory('c:\tempdoc')
	Md 'c:\tempdoc'
Endif

cfile = 'c:\tempdoc\enviomailepi.html'
If File(cfile)
	Delete File (cfile)
Endif

lccuerpo = "<h3> &#128075; Hola <b>"+lcNombre+" ! </b></h3> <br>"
lccuerpo = lccuerpo + "<font size = 3> Soy un asistente virtual del Sanatorio Güemes, te escribo para avisarte que tu epicrisis ya se encuentra disponible para ser visualizada desde <a href='https://www.sg.com.ar/sitio/sg-mi-salud-online.php'>Mi Salud Online</a></font><br><br>"
*!*	lccuerpo = lccuerpo + "<font size = 3> Este es un <b>mensaje automático</b>, si tenés alguna duda o necesitás más información podés contactarte de lunes a viernes de 8 a 18 horas por:</font><br>"
*!*	lccuerpo = lccuerpo + "<font size = 3> &#128241; WhatsApp al <a href='https://bit.ly/sg_whatsapp'>+5491138545300</a></font><br>"
*!*	lccuerpo = lccuerpo + "<font size = 3> &#9742; Teléfono: llamando al 4959-8300 </font><br>"

lccuerpo = lccuerpo + "<font size = 3> Este es un <b>mensaje automático</b>, por favor <b>no respondas este correo.</b></font><br>"
lccuerpo = lccuerpo + "<font size = 3> Si necesitás más información podés contactarte de lunes a viernes de 8 a 20 horas con nuestra central de turnos por:</font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128241; WhatsApp de lunes a viernes enviando un mensaje al <a href='https://bit.ly/sg_whatsapp'>+5491138545300</a></font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#9742; Atención Telefónica de lunes a viernes llamando al: 4959-8300 </font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128172; Por mensaje directo a través de nuestras redes sociales: <a href='https://es-la.facebook.com/sanatorioguemessalud/'>Facebook</a> / <a href='https://www.instagram.com/sanatorioguemessalud/?hl=es'>Instragram</a></font><br>"
lccuerpo = lccuerpo + "<font size = 3> &#128187; Por la Web a través de tu portal de salud digital: <a href='https://www.sg.com.ar/sitio/sg-mi-salud-online.php'>Mi Salud Online</a>, las 24 hs. los 365 días. </font><br><br>"
lccuerpo = lccuerpo + "<font size = 3> Hasta luego &#128075;</font><br>"
lccuerpo = lccuerpo + "<font size = 2> Sanatorio Güemes</font><br><br>"

lasunto = 'Sanatorio Güemes - Epicrisis del Paciente'
mdestinatario = lcMail

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
		.Item(lcSchema + "sendusername") = "documentacion@sg.com.ar" && "informespacientes@sg.com.ar"
		.Item(lcSchema + "sendpassword") = "documentacion.21" && "sanatorio"
		.Update
	Endwith
	loMsg = Createobject ("CDO.Message")
	With loMsg
		.Configuration = loConfig
		.From = "SG - Epicrisis <documentacion@sg.com.ar>" && "Turnos SG <informespacientes@sg.com.ar>"
		.To = mdestinatario 
		.Subject = Alltrim(lasunto)
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

Use In Select('mwkRegPac')

