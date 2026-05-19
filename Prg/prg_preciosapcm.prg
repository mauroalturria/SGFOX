Lparameters xcodent,xcodpract,lcimporteCobertura,lcimportePaciente ,lcpracticaSinCargo ,lcpracticaConvenida,lccentro
*https://servicios.sg.com.ar/interfaces/ajax/sg_valoriza_sap_srv.php?aplicacion=MK&codigoPractica=22010101&codigoEmpresa=948
codigoentidad = Transform(xcodent)
codigopractica = Transform(xcodpract)
If Vartype(lccentro)<>"N"
	lccentro = 1
Endif
Do Case
Case lccentro=1
	lcentromedico = 'C'
Case lccentro=2
	lcentromedico = 'L'
Case lccentro=3
	lcentromedico = 'P'
Otherwise
	lcentromedico = 'C'
Endcase
Do sp_busco_estados With 57,' and tipo = 11 ','mwkhabpreciosap'&&
*lclink = "https://servicios2.sg.com.ar/interfaces/ajax/sg_valoriza_sap_srv.php"
If mwkhabpreciosap.estado = 0 And myip<>'172.16.1.7'
	lcodigopractica = xcodpract
	lcimporteCobertura = ''
	lcimportePaciente = ''
	lcpracticaSinCargo = ''
	lcpracticaConvenida = ''

	Return ''
Else

	lclink = Alltrim(mwkhabpreciosap.Descrip)
	lclink = lclink + '?aplicacion=MK&'+'codigoPractica=' + codigopractica + '&'+'codigoEmpresa=' + codigoentidad + '&'+'centromedico=' + lcentromedico

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
	lnlong = At(",",Substr(lcresp,32))-1
	lcodigopractica = Substr(lcresp,32,lnlong)
	lcimporteCobertura = Alltrim(json(lcresp,"importeCobertura",0))
	nimppac = At("importePaciente",lcresp)+17
	nimpac2p =  At(",",Substr(lcresp,nimppac))-1
	npracconv =  At("practicaConvenida",lcresp)
	lcimportePaciente = Strtran(Alltrim(Substr(lcresp,nimppac,nimpac2p )),'"','')
	lcpracticaSinCargo = Alltrim(json(lcresp,"practicaSinCargo",0))
	lcpracticaConvenida = Alltrim(json(lcresp,"practicaConvenida",0))

	Return lcresp
	Release xmlHTTP
Endif

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





