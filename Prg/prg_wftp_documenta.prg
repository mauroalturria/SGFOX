Lparameters plocal,pftp,ptipo

archivolocal = plocal
archivoftp = pftp
lntipo = ptipo

Do sp_busco_estados With 57,' and Tipo = 52 and Estado = 1','mwkLinkftp'


If Reccount('mwkLinkftp')=0
	Messagebox('Error al subir documentos al servidor'+Chr(10)+'Tipo de Error: URL no habilitada',48,'AVISO')
	Return 0
Endif

Select mwkLinkftp
lcLink = Alltrim(mwkLinkftp.descrip)

If Empty(lcLink)
	Messagebox('Error al subir documentos al servidor'+Chr(10)+'Tipo de Error: No existe URL',48,'AVISO')
	Return 0
Endif

lcUcnroregisRL = lcLink+"?tipo="+Transform(lntipo)+"&archivo="+Alltrim(archivoftp)

*Strtofile(lcUcnroregisRL,"miurl.txt")

Use In Select('mwkLinkftp')

Local xmlHTTP As "Microsoft.XMLHTTP"
xmlHTTP = Createobject("Microsoft.XMLHTTP")

If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP).",48,"Aviso")
	Return
Endif

xmlHTTP.Open("GET", lcUcnroregisRL , .F.)

xmlHTTP.Send()

Do While xmlHTTP.readyState<>4
	DoEvents
Enddo

lnServidor = xmlHTTP.Status


If !lnServidor = 200
	Messagebox('Error al obtener el documento.' +Chr(10)+'Tipo de Error: '+Transform(lnServidor)+Chr(10)+'Mensaje: ' + errorservidor(lnServidor), 16 , 'Documentación ')
	archivolocal = ""
Else
	lcResp = xmlHTTP.responseBody
	Strtofile(lcResp,archivolocal)
Endif

Release xmlHTTP

Return archivolocal

Function errorservidor(nro)
Do Case
Case nro = 400
	mensaje = "Solicitud incorrecta"
Case nro = 404
	mensaje = "No se encuentra el documento solicitado"
Otherwise
	mensaje = "Tipo de Error desconocido"
Endcase
Return mensaje
Endfunc

