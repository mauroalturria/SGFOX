*
* Envio de Mails Newsletter
*
lparameters mmail, msubject, muser, mpass, mipserver, mtiempo, mpuerto, mhora, mdia, matach, mdesti, mlinea

*!*	Set Proc To VFPwinsock

*!*	Local loSendMail

*!*	loSendMail = Createobject("VFP_Winsock_Send_Mail")

*!*	loSendMail.smtp_host     = mipserver
*!*	loSendMail.From          = mmail
*!*	loSendMail.FROM_NAME     = "CIAM"
*!*	loSendMail.AUTH_LOGIN    = muser
*!*	loSendMail.AUTH_PASSWORD = mpass
*!*	loSendMail.SMTP_PORT     = mpuerto

mlmsgbody = mlinea + chr(10)

*!*	loSendMail.Message       = mlmsgbody

*!*	minienvio = Seconds()
*!*	mfechoy   = sp_busco_fecha_serv('DD')

*!*	loSendMail.To         = mdesti
*!*	loSendMail.TO_Name    = mdesti
*!*	loSendMail.Subject    = msubject
*!*	loSendMail.attachment = matach

*!*	mretorno = .T.
*!*	If Not loSendMail.Send()
*!*		=Messagebox(loSendMail.Erreur,16,"Error")
*!*		mretorno = .F.
*!*	Else
*!*		menviados = menviados + 1
*!*	Endif

*!*	If mretorno
*!*		mveces = mveces + 1
*!*		If mveces = 5
*!*			Wait Windows "Descargando Servidor de Correo, [ Por Favor ** NO ** oprima el Teclado ]";
*!*				Timeout (mtiempo)
*!*			mveces = 0
*!*		Endif

*!*		If menviados >= mhora
*!*			If (Seconds()-minienvio) <= 3600
*!*				=Messagebox("Ha llegado al envio máximo en una hora, el proceso se cerrará"+Chr(10)+;
*!*					"podrá enviar nuevamente dentro de 20 minutos."+Chr(10)+;
*!*					Chr(10)+;
*!*					"Recuerde quitar de la lista los mails enviados."+Chr(10)+;
*!*					"Y de no exceder el máximo diario de envios.",64,"Atención")
*!*				Exit
*!*			Endif
*!*			minienvio = Seconds()
*!*		Endif

*!*	Endif
*!*	loSendMail = .Null.

loMail = newobject("Cdo2000", "Cdo2000.fxp")

With loMail
	.cServer       = "smtp.gmail.com"
	.nServerPort   = 465
	.lUseSSL       = .T.
	.nAuthenticate = 1
	.cUserName     = muser     && mEmail
	.cPassword     = mpass     && mPass
	.cFrom         = mmail     && mEmail
	.cTo           = mdesti    && mdestino
	.cSubject      = msubject  && cSubject
	.cTextBody     = mlmsgbody && cBody
	.cAttachment   = Nvl(matach,"")
Endwith

mError = ""

If loMail.send() > 0
	
	For i=1 to loMail.GetErrorCount()
		mError = mError + loMail.Geterror(i)
	Endfor
	
	If !Empty(mError)
		do sp_insert_tabCtrlErr with 1, mError , alltrim(mwkusuario.idusuario), "AUTORIZACIONES",,cSubject
		messagebox("Error al enviar el mail: " + chr(10) + mError,16,"Mail")
	Endif
	
	loMail.ClearErrors()
	mretorno = .f.
	
Else

	messagebox("Mensaje Enviado.",64,"Mail")
	mretorno = .t.
	
Endif

return mretorno


