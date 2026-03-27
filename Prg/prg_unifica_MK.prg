
registracion_duplicada = 0
registracion_original = 0
 
lcURL = "http://172.20.2.7:50000/RESTAdapter/api/consultaprestaciones.php?regis_org="+Alltrim(Str(registracion_original))+"&regis_dup="+Alltrim(Str(registracion_duplicada))

Local xmlHTTP As "Microsoft.XMLHTTP"
xmlHTTP = Createobject("Microsoft.XMLHTTP")
If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP).",48,"Aviso")
	Return
Endif
xmlHTTP.Open("GET", lcURL, .F.)
xmlHTTP.setRequestHeader ("Content-Type", "text/xml;charset=utf-8")
xmlHTTP.setRequestHeader ("Authorization","94ecbc1edeee37aaef258dd36bed9888")

xmlHTTP.Send()
Do While xmlHTTP.readyState<>4
	DoEvents
Enddo

lnServidor = xmlHTTP.Status

Wait Clear

If !xmlHTTP.Status = 200
	Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
Else
	If lnServidor = 200
		lcResp = xmlHTTP.responseText
		Strtofile(lcResp,"jsonresp.txt")
		If json(lcResp,'Estado') = 'ERROR'
			lerror = json(lcResp,'Mensaje')
			Messagebox(lerror,16,'AVISO')
		Else
* OK - Puedo grabar en la tabla ERROR u OK
		Endif
	Endif
Endif

Release xmlHTTP

