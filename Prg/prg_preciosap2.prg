Lparameters xcodent,xcodpract
*https://servicios.sg.com.ar/interfaces/ajax/sg_valoriza_sap_srv.php?aplicacion=MK&codigoPractica=22010101&codigoEmpresa=948
lcURL = "https://servicios.sg.com.ar/interfaces/ajax/sg_valoriza_sap_srv.php"
cobertura = "E"
*fechaatencion =STRTRAN(LEFT(prg_dtoc(sp_busco_fecha_serv("DD")),10),'-','')
codigoentidad = Transform(xcodent)
clase = 1
codigopractica = Transform(xcodpract)
 
lclink = "https://servicios.sg.com.ar/interfaces/ajax/sg_valoriza_sap_srv.php"
lclink = lclink + '?aplicacion=MK&'+'codigoPractica=' + codigopractica + '&'+'codigoEmpresa=' + codigoentidad

*			lclink = Strtran(lclink,' ','%20')

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
		lcresp = "ERROR BORRAR"
	Endif

Endif

Release xmlHTTP

Endif

Else
	lcresp = "NO PUDO OBTENER RESPUESTA DE SAP"
	Messagebox(lcresp,48,"AVISO")

Endif


