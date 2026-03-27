LPARAMETERS xcodent,xcodpract
*https://servicios.sg.com.ar/interfaces/ajax/sg_valoriza_sap_srv.php?aplicacion=MK&codigoPractica=22010101&codigoEmpresa=948
lcURL = "https://servicios.sg.com.ar/interfaces/ajax/sg_valoriza_sap_srv.php?aplicacion=MK&"
cobertura = "E"
fechaatencion =STRTRAN(LEFT(prg_dtoc(sp_busco_fecha_serv("DD")),10),'-','')
codigoentidad = TRANSFORM(xcodent)
clase = 1
codigopractica = TRANSFORM(xcodpract)

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
* EVALUAR QUE RESPUESTA MANDAN SI DEVUELVE ALGUN TIPO DE ERROR
	Endif
Endif

Release xmlHTTP
