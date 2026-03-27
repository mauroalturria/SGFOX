*
* Envio de Mails Newsletter
*
Lparameters mmail, msubject, muser, mpass, ;
	mipserver, mtiempo, mpuerto, mhora, mdia, matach, mdesti

Set Proc To VFPwinsock

Local loSendMail

loSendMail = Createobject("VFP_Winsock_Send_Mail")

loSendMail.smtp_host     = mipserver
loSendMail.From          = mmail
loSendMail.FROM_NAME     = "SILVER-CROSS"
loSendMail.AUTH_LOGIN    = muser
loSendMail.AUTH_PASSWORD = mpass
loSendMail.SMTP_PORT     = mpuerto
*loSendMail.CCI           = mmail  && "mauroalturria@gmail.com"

mlmsgbody = "ENCUESTAS DAS" + Chr(10)

loSendMail.Message       = mlmsgbody

minienvio = Seconds()
mfechoy   = sp_busco_fecha_serv('DD')

loSendMail.To         = mdesti
loSendMail.TO_Name    = mdesti
loSendMail.Subject    = msubject

*loSendMail.data_MHTML = v_mhtml

loSendMail.attachment = matach

mretorno = .T.
If Not loSendMail.Send()
	=Messagebox(loSendMail.Erreur,16,"Error")
	mretorno = .F.
Else
	menviados = menviados + 1
Endif

If mretorno
	mveces = mveces + 1
	If mveces = 5
		Wait Windows "Descargando Servidor de Correo, [ Por Favor ** NO ** oprima el Teclado ]";
			Timeout (mtiempo)
		mveces = 0
	Endif

	If menviados >= mhora
		If (Seconds()-minienvio) <= 3600
			=Messagebox("Ha llegado al envio máximo en una hora, el proceso se cerrará"+Chr(10)+;
				"podrá enviar nuevamente dentro de 20 minutos."+Chr(10)+;
				Chr(10)+;
				"Recuerde quitar de la lista los mails enviados."+Chr(10)+;
				"Y de no exceder el máximo diario de envios.",64,"Atención")
			Exit
		Endif
		minienvio = Seconds()
	Endif

Endif
loSendMail = .Null.

Return mretorno
