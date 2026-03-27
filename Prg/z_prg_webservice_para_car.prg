
lcURL = "http://172.20.2.7:50000/RESTAdapter/api/consultaprestaciones"
codigoentidad = 948
cobertura = "E"
fechaatencion = "20230328"
clase = 1
codigopractica = "42030731"

TEXT To lcXML Textmerge Noshow Pretext 7
{
    "prestaciones": [
        {
            "codigoEmpresa": <<codigoentidad>>,
            "codigoCobertura": "<<cobertura>>",
            "fechaAtencion": "<<fechaatencion>>",
            "guardia": " ",
            "clase": "<<clase>>",
            "codigoPractica": "<<codigopractica>>"
        }
    ]
}
ENDTEXT


Local xmlHTTP As "Microsoft.XMLHTTP"
xmlHTTP = Createobject("Microsoft.XMLHTTP")
If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP).",48,"Aviso")
	Return
Endif
xmlHTTP.Open("POST", lcURL, .F.)
xmlHTTP.setRequestHeader ("Content-Type", "text/xml;charset=utf-8")
xmlHTTP.setRequestHeader ("Authorization","Basic bWFya2V5d3M6TWFya2V5QFdTLjIw")

xmlHTTP.Send(lcXML)

Do While xmlHTTP.readyState<>4
	DoEvents
Enddo

lnServidor = xmlHTTP.Status


If !xmlHTTP.Status = 200
	Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
Else
	If lnServidor = 200
		lcResp = xmlHTTP.responseText

		Strtofile(lcResp,"jsonresp.txt")

		lnlong = At(",",Substr(lcResp,32))-1
		lcodigopractica = Substr(lcResp,32,lnlong)
		lcimporteCobertura = Alltrim(json(lcResp,"importeCobertura",0))
		lcimportePaciente = Alltrim(json(lcResp,"importePaciente",0))
		lcpracticaSinCargo = Alltrim(json(lcResp,"practicaSinCargo",0))
		lcpracticaConvenida = Alltrim(json(lcResp,"practicaConvenida",0))
	Endif
Endif

Release xmlHTTP

Messagebox(lcodigopractica)
Messagebox(lcimporteCobertura)
Messagebox(lcimportePaciente)
Messagebox(lcpracticaSinCargo)
Messagebox(lcpracticaConvenida)

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
