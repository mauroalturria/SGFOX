
wcorreo='TU-CORREO'
wclave='TU-CONTRASEÑA'
wcorreo=ALLTRIM(wcorreo)+"@gmail.com"
wclave=ALLTRIM(wclave)
wdestino='NUMERO-DE-DESTINO-SIN-0-Y-SIN-15'
wdestino=ALLTRIM(wdestino)+"@sms.ctimovil.com.ar"
LOCAL lcSchema, loConfig, loMsg, loError, lcErr,lcFile
lcErr = ""
lcSchema = "http://schemas.microsoft.com/cdo/configuration/"
loConfig = CREATEOBJECT("CDO.Configuration" )
WITH loConfig.FIELDS
.ITEM(lcSchema + "smtpserver" ) = "smtp.gmail.com"
.ITEM(lcSchema + "smtpserverport" ) = 465 && 465 && ó 587
.ITEM(lcSchema + "sendusing" ) = 2
.ITEM(lcSchema + "smtpauthenticate" ) = .T.
.ITEM(lcSchema + "smtpusessl" ) = .T.
.ITEM(lcSchema + "sendusername" ) = wcorreo && Correo de envio
.ITEM(lcSchema + "sendpassword" ) = wclave && Clave de tu correo
.UPDATE
ENDWITH

loMsg = CREATEOBJECT ("CDO.Message" )
WITH loMsg
.Configuration = loConfig
.FROM = wcorreo
.TO = wdestino
.Subject = "ASUNTO"
.TextBody = "MENSAJE A MANDAR"
.Send()
ENDWITH
RELEASE loConfig, loMsg
STORE .NULL. TO loConfig, loMsg
IF EMPTY(lcErr)
MESSAGEBOX ("Archivo de Notas Enviado con éxito", 64, "Aviso" )
ELSE
MESSAGEBOX (lcErr, 16 , "Error" )
ENDIF
***********************
CLEAR
CLOSE DATABASES
