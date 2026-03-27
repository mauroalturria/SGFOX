Lparameters xcodent,xcodpract,lcimporteCobertura,lcimportePaciente ,lcpracticaSinCargo ,lcpracticaConvenida
*https://servicios.sg.com.ar/interfaces/ajax/sg_valoriza_sap_srv.php?aplicacion=MK&codigoPractica=22010101&codigoEmpresa=948
codigoentidad = Transform(xcodent)
codigopractica = Transform(xcodpract)

lclink = "https://servicios.sg.com.ar/interfaces/ajax/sg_valoriza_sap_srv.php"
lclink = lclink + '?aplicacion=MK&'+'codigoPractica=' + codigopractica + '&'+'codigoEmpresa=' + codigoentidad
Local xmlHTTP As "Microsoft.XMLHTTP"
xmlHTTP = Createobject("Microsoft.XMLHTTP")
If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP). No se pudo enviar la guía.",48,"Aviso")
	Return
Endif
xmlHTTP.Open("GET", lclink)
xmlHTTP.Send()
Do While xmlHTTP.readyState<>4
	DoEvents
Enddo
lcresp = xmlHTTP.responseText

lnServidor = xmlHTTP.Status

Wait Clear

If !xmlHTTP.Status = 200
	Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
Else
	If !Vartype(lcresp)="C"
		lcresp = ""
	Endif

Endif
lnlong = At(",",Substr(lcResp,32))-1
lcodigopractica = Substr(lcResp,32,lnlong)
lcimporteCobertura = Alltrim(json(lcResp,"importeCobertura",0))
lcimportePaciente = Alltrim(json(lcResp,"importePaciente",0))
lcpracticaSinCargo = Alltrim(json(lcResp,"practicaSinCargo",0))
lcpracticaConvenida = Alltrim(json(lcResp,"practicaConvenida",0))

Return lcresp
Release xmlHTTP


Function json(texto,clave,comillas)
lcjson = texto
lcjsonclave = '"'+Alltrim(clave)+'":'
lninicio = At(lcjsonclave,lcjson)
lcstring = Substr(lcjson,lninicio,Len(lcjson)-lninicio)
lextra = At(":",lcstring)
lcstring = Substr(lcstring,lextra+1,Len(lcstring)-lextra)
lcstring = Strextract(lcstring,'"','"')
Return lcstring
Endfunc





