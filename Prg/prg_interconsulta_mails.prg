Lparameters dat1,dat2,dat3

LOCAL cFrom,cPass,cSmtp,nPuerto,nSSL 
Local loCfg, loMsg, lcFile, loErr

*SET STEP ON

mdestinatario = dat1
masunto = dat2
mcuerpo = dat3

cFrom = ""
cPass=""
cSmtp=""
nPuerto=0
nSSL=""

DO sp_busco_estados WITH 4, " and tipo = 68 ","mwkmails"

SELECT mwkmails
GO top

SCAN all

Do Case
	Case At("EMAIL=",mwkmails.Descrip) > 0
		cFrom = Right(Alltrim(mwkmails.Descrip),Len(Alltrim(mwkmails.Descrip)) - 6)
	Case At("PASS=",mwkmails.Descrip) > 0
		cPass = Right(Alltrim(mwkmails.Descrip),Len(Alltrim(mwkmails.Descrip)) - 5)
	CASE AT("SMTP=", mwkmails.descrip) > 0
	    cSmtp = Right(Alltrim(mwkmails.Descrip),Len(Alltrim(mwkmails.Descrip)) - 5)
	CASE AT("PORT=",mwkmails.descrip) > 0
	    nPuerto = VAL(Right(Alltrim(mwkmails.Descrip),Len(Alltrim(mwkmails.Descrip)) - 5))
	CASE AT("SSL=",mwkmails.descrip) > 0
	    nSSL = VAL(Right(Alltrim(mwkmails.Descrip),Len(Alltrim(mwkmails.Descrip)) - 4))
	Endcase
ENDSCAN 

USE IN SELECT("mwkmails")

** llamada a la funcion CDO
** Lparameters matach,mdestino, cSubject, cBody, cFrom, cPass, mShowResult, mSmtp, mPuerto, mSSL, lHtmlBody
lResult = sp_enviamail_cdo2000( , mdestinatario, masunto , mcuerpo, cFrom, cPass,,cSmtp,nPuerto,nSSL,.t.)

IF !lResult
   Do log_errores_mail With 0, "Envio de Email pedido de Interconsulta", "", Program(), Lineno()
ENDIF 
 


*!*	Try
*!*		loCfg = Createobject("CDO.Configuration")
*!*		With loCfg.Fields
*!*			.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
*!*			.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 && ó 587
*!*			.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
*!*			.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = .T.
*!*			.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = .T.
*!*			.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "Dl380@sg.com.ar"
*!*			.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") =  "servidor380"
*!*			.Update
*!*		Endwith
*!*		loMsg = Createobject ("CDO.Message")
*!*		With loMsg
*!*			.Configuration = loCfg
*!*	*-- Remitenete y destinatarios
*!*			.From = "Interconsultas SG (Dl380)<Dl380@sg.com.ar>"
*!*			.To = "<"+mdestinatario+">"
*!*			.Cc = ''
*!*	*- Notificación de lectura
*!*	*!*			.Fields("urn:schemas:mailheader:disposition-notification-to") = .From
*!*	*!*			.Fields("urn:schemas:mailheader:return-receipt-to") = .From
*!*	*!*			.Fields.Update
*!*	*- Prioridad
*!*	&& -1=Low, 0=Normal, 1=High
*!*			.Fields("urn:schemas:httpmail:priority") = 1
*!*			.Fields("urn:schemas:mailheader:X-Priority") = 1
*!*			.Fields.Update
*!*	*- Importancia
*!*	&& 0=Low, 1=Normal, 2=High
*!*			.Fields("urn:schemas:httpmail:importance") = 2
*!*			.Fields.Update
*!*	*-- Tema
*!*			.Subject = masunto
*!*	*-- Formato HTML desde la Web
*!*	*    .CreateMHTMLBody("Hola", 0)
*!*			.textbody = mcuerpo
*!*	*-- Archivo adjunto
*!*	*!*			lcFile = marchivo
*!*	*!*			If File(marchivo)
*!*	*!*				.AddAttachment(lcFile)
*!*	*!*			Endif
*!*	*-- Envio el mensaje
*!*			.Send()
*!*		Endwith
*!*	Catch To loErr
*!*	*!*		Messagebox("No se pudo enviar el mensaje" + Chr(13) + ;
*!*	*!*			"Error: " + Transform(loErr.ErrorNo) + Chr(13) + ;
*!*	*!*			"Mensaje: " + loErr.Message , 16, "Error")
*!*	Finally
*!*		loMsg = Null
*!*		loCfg = Null
*!*	Endtry
