Lparameters xfecha,xcuil,xpaciente

If myip='172.16.1.7'
*	Set Step On
Endif
*https://serviciosdev.sg.com.ar/interfaces/markey_obtmedicopac.php?paciente=1039622&profesional=20-28796500-2&fecha=20251125
xpaciente =  Transform(xpaciente)

Do sp_busco_estados With 57,' and tipo = 89 and subestado = ?mxcentromedico ','mwkAgendaMK'&&

If mwkAgendaMK.estado = 1
	lclink = Alltrim(mwkAgendaMK.Descrip)
	lclink = lclink + '?paciente=' + Alltrim(xpaciente) + '&'+'profesional=' + Transform(xcuil)
	lclink = lclink + '&'+'fecha=' + Alltrim(xfecha)

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
		Create Cursor mwkjson (turnCodigo N(12),mediMedico c(50) ,turnFechaInicio T,paciPaciente c(50);
			,turnEstado c(30),turnEspontaneo L,turnReemplazo L,procCodigoInterno N(10),procDescripcion c(50);
			,tuprCodigoInterno c(30) )
		lcturnCodigo = Val(json(lcResp,'turnCodigo',0))
		lcturnEstado = json(lcResp,'turnEstado',0)
		lctuprCodigoInterno = json(lcResp,'tuprCodigoInterno',0)
		lcturnFechaInicio =  prg_ctod(Strtran(Left(json(lcResp,'turnFechaInicio',0),19),"T"," "),'T')
		lcpaciPaciente = json(lcResp,'paciPaciente',0)
		lcmediMedico = json(lcResp,'mediMedico',0)
		lcjason = json(lcResp,'turnEspontaneo',0)
		lcturnEspontaneo =  (lcjason<>'false')
		lcjason =  json(lcResp,'turnReemplazo',0)
		lcturnReemplazo = (lcjason<>'false')
		Do While Len(Alltrim(lcresp))>20
			lcprocCodigoInterno = Val(json(lcResp,'procCodigoInterno',0))
			lcprocDescripcion = json(lcResp,'procDescripcion',0)
			lcjason =  json(lcResp,'turnReemplazo',0)

			Insert Into mwkjson   (turnCodigo,mediMedico,turnFechaInicio,paciPaciente;
				,turnEstado,turnEspontaneo,turnReemplazo,procCodigoInterno,procDescripcion,tuprCodigoInterno  );
				Values (lcturnCodigo,lcmediMedico,lcturnFechaInicio,lcpaciPaciente;
				,lcturnEstado,lcturnEspontaneo,lcturnReemplazo,lcprocCodigoInterno,lcprocDescripcion,lctuprCodigoInterno  )

			npositem = At('tuprCodigoInterno:',lcresp)+32
			lcresp =Substr(lcresp ,npositem)
		Enddo
	Endif
Endif

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
Function jsonitems(texto,clave,ocur)
lcjson = texto
lcjsonclave = '"'+Alltrim(clave)+'":'
lninicio = At(lcjsonclave,lcjson,ocur)
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
