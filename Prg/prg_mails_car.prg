PARAMETERS mctexto, lcmail,adjunto

*Do sp_conexion
*Set Step On 


*lcmail = "calvarez@sg.com.ar"
*Archivopdf = "Acà va el path del adjunto, el archivo que vas a enviar"

* De acá sale la configuraciòn de la cuenta:
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
lcdato1 =  Alltrim(mwkCuenta.Descrip)
Locate For estado = 2
lcdato2 =  Int(Val(Alltrim(mwkCuenta.Descrip)))
Locate For estado = 3
lcdato3 = Int(Val(Alltrim(mwkCuenta.Descrip)))
Locate For estado = 4
lcdato4 = Iif(Alltrim(Upper(mwkCuenta.Descrip))="T",.T.,.F.)
Locate For estado = 5
lcdato5 = Iif(Alltrim(Upper(mwkCuenta.Descrip))="T",.T.,.F.)
Locate For estado = 6
lcdato6 = 'sm@sg.com.ar' &&& Alltrim(mwkCuenta.Descrip)
Locate For estado = 7
lcdato7 = 'pbxjjxexitcuemvc'&&&Alltrim(mwkCuenta.Descrip)
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
		.Subject = Alltrim("Turnos Libres")
 		.AddAttachment(adjunto) && Acà tenes que poner el excel
	      .TextBody = Alltrim(mctexto)
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
*	Messagebox("El mensaje se envió con éxito", 64, "Aviso")
	Else
*	Messagebox(lcErr, 16 , "Error al Enviar E-Mail")
	Endif
Endtry

Use In Select('mwkCuenta')
Wait Clear
