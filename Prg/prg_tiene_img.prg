Lparameters xhcli,xnroproto
If myip='172.16.1.7'
*	Set Step On
Endif
*https://servicios2.sg.com.ar/api/pacsrm/index.php?hc=3976954-2&proto=622072
Do sp_busco_estados With 57,' and tipo = 87 and  estado = 1 ','mwktieneImg'&&
cresp = ''
If mwktieneImg.estado = 1
	lclink = Alltrim(mwktieneImg.Descrip)
	lclink = lclink + '?hc=' + Alltrim(xhcli) + '&'+'proto=' + ALLTRIM(Transform(xnroproto))
	 
	Local oHttp, cUrl, cResponse

	Try
		oHttp = Createobject("WinHttp.WinHttpRequest.5.1")
	Catch To loError
		Messagebox("No se pudo crear el objeto WinHttp. Error: " + loError.Message)
		Return
	Endtry

	cUrl = lclink

	Try
		cUrl = lclink &&* agrega un query param único para evitar caché
		cUrl = cUrl + Iif("?" $ cUrl, "&", "?") + "_ts=" + Ttoc(Datetime(),1)
		oHttp.Open("GET", cUrl, .F.)
		oHttp.SetRequestHeader("Accept", "application/json")
		oHttp.SetRequestHeader("Cache-Control", "no-cache")
		oHttp.SetRequestHeader("Pragma", "no-cache")
		oHttp.SetRequestHeader("If-Modified-Since", "Sat, 01 Jan 2000 00:00:00 GMT")
		oHttp.Send()
	Catch To loError
		Messagebox("Error al enviar la solicitud: " + loError.Message)
		Return
	Endtry

	If oHttp.Status = 200
		cResponse = oHttp.ResponseText
		lcresp = cResponse
	Else
		lcresp = Transform(oHttp.Status)
	Endif
	Strtofile(lcResp,"jsonresp.txt")
	If mwkusuario.sector = 'SISTEMAS'
		Messagebox("Respuesta:"+Chr(10)+Alltrim(lcresp))
	Endif
	Release oHttp
	Wait Clear
	If !Empty(lcResp)
*!*			"estado": "OK",
*!*			"protocolo": "622072",
*!*			"imagen": "si",
*!*			"fecha": "2025-10-17",
*!*			"hora": "20:20:09"
		lcestado = STRTRAN( json(lcResp,'estado',0),'"','')
		lcimagen= STRTRAN( json(lcResp,'imagen',0),'"','')
		lcFecha = STRTRAN(json(lcResp,'fecha',0),'"','')
		
		If AT('OK',UPPER(lcestado))>0
			cresp = lcimagen+lcFecha 
		Endif
	Endif
ENDIF
RETURN (cresp)
Function json(texto,clave,comillas)
lcjson = texto
lcjsonclave = '"'+Alltrim(clave)+'":'
lninicio = At(lcjsonclave,lcjson)
lcstring = Substr(lcjson,lninicio,Len(lcjson)-lninicio)
lextra = At(":",lcstring)
lcstring = Substr(lcstring,lextra+1,Len(lcstring)-lextra)
If Left(lcstring,1)='"'
	lcstring = Strextract(lcstring,'"','"')
Else
	lextra = At(",",lcstring)-1
	lcstring = Left(lcstring,lextra )
Endif
Return lcstring
Endfunc
