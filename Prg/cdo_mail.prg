

marchivo = carchivo 				&& archivo adjunto
Local loCfg, loMsg, lcFile, loErr

Try
   loCfg = Createobject("CDO.Configuration")
   With loCfg.Fields
      .Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
      .Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 && ó 587
      .Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
      .Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = .T.
      .Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = .T.
      .Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "etkachuk@sg.com.ar" && ejemplo: "edu@sg.com.ar"
      .Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") =  "sanatorio123" && ejemplo: "eduardo123"
      .Update
   Endwith
 
   loMsg = Createobject ("CDO.Message")
 
   With loMsg
      .Configuration = loCfg

      *-- Remitenete y destinatarios
      .From = "Chequeos Pami (SG)" Acá poné lo que quieras mostrar al destinatario
      .To = "<"+mdestinatario+">" Acá va el destinatario
      .Cc = lccopia Acá va si querés copiar a alguien

      *- Notificación de lectura
      .Fields("urn:schemas:mailheader:disposition-notification-to") = .From
      .Fields("urn:schemas:mailheader:return-receipt-to") = .From
      .Fields.Update

      *- Prioridad
      && -1=Low, 0=Normal, 1=High
      .Fields("urn:schemas:httpmail:priority") = 1
      .Fields("urn:schemas:mailheader:X-Priority") = 1
      *- Importancia
      && 0=Low, 1=Normal, 2=High
      .Fields("urn:schemas:httpmail:importance") = 2
      .Fields.Update
      *-- Tema
      .Subject = masunto Acá va el asunto del Mail
      *-- Formato HTML desde la Web
      *    .CreateMHTMLBody("Hola", 0)
      .textbody = mcuerpo
      *-- Archivo adjunto
      lcFile = marchivo Acá va el archivo adjunto, fijate que antes de enviar me aseguro que esté fisicamente el archivo generado.
      If File(marchivo)
         .AddAttachment(lcFile)
      Endif
      *-- Envio el mensaje
      .Send() Envío
   Endwith
Catch To loErr
   Messagebox("No se pudo enviar el mensaje" + Chr(13) + ;
      "Error: " + Transform(loErr.ErrorNo) + Chr(13) + ;
      "Mensaje: " + loErr.Message , 16, "Error")
   menviado = 0
Finally
   loMsg = Null
   loCfg = Null
Endtry

Endif
