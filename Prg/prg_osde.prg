Lparameters xafi,xtipo,xctipo,xfechaini,xfechafin,xdiagno,xnroevento,xmotivoegreso

If myip='172.16.1.7'
	Set Step On
Endif
If Vartype(xfechaini)<>"T"
	xfechaini = sp_busco_fecha_serv("DT")
Endif
If Vartype(xfechafin)<>"T"
	xfechafin = sp_busco_fecha_serv("DT")
Endif
If Vartype(xtipo)<>"N"
	Return
Endif
xcfechaini = Strtran(prg_dtoc(xfechaini)," ","T")
xcfechafin = Strtran(prg_dtoc(xfechafin)," ","T")

Use In Select('mwkjson')
Create Cursor mwkjson (Consok L, numeroEvento N(10),mensaje c(200)   )

If xtipo = 1  && crear
***api.php?operacion=crear-evento&numeroSocio=70003276102&numeroPrestador=6001014081&diagnostico=X41&fechaInicioTentativa=01%2F09%2F2026%2008%3A00
	xcopera = "?operacion="+Alltrim(xctipo)+'&' +"numeroSocio="+Alltrim(Transform(xafi))+'&'+;
		"numeroPrestador=6001014081"+'&' +"diagnostico="+Alltrim(xdiagno)+'&' +"fechaInicioTentativa="+;
		xcfechaini+'&' +"api_key=27a2402e8bffd17a45f0e78c81c0f66c0a8c33a0e1b4deaa"
Endif
If xtipo = 2 &&& buscar
&&"api.php?operacion=buscar-evento&numeroSocio=70003276102&numeroPrestador=6001014081",
	xcopera = "?operacion="+Alltrim(xctipo)+'&' +"numeroSocio="+Alltrim(Transform(xafi))+'&'+;
		"numeroPrestador=6001014081"+'&' +"api_key=27a2402e8bffd17a45f0e78c81c0f66c0a8c33a0e1b4deaa"
Endif
If xtipo = 3 &&& Informar Internacion
&&api.php?operacion=informar-internacion&numeroEvento=NUMERO_EVENTO&numeroSocio=70003276102&numeroPrestador=6001014081&fechaIngreso=31%2F08%2F2026%2011%3A37
	xcopera = "?operacion="+Alltrim(xctipo)+'&' +"numeroEvento="+Alltrim(Transform(xnroevento)) +;
		+'&' +"numeroSocio="+Alltrim(Transform(xafi))+'&'+;
		"numeroPrestador=6001014081"+'&' +"fechaIngreso="+	xcfechaini+;
		'&' +"api_key=27a2402e8bffd17a45f0e78c81c0f66c0a8c33a0e1b4deaa"
Endif
If xtipo = 4 &&& Informar externacion
** api.php?operacion=informar-externacion&numeroEvento=NUMERO_EVENTO&numeroSocio=70003276102&numeroPrestador=6001014081&fechaEgreso=31%2F08%2F2026%2011%3A37&motivoEgreso=
	xcopera = "?operacion="+Alltrim(xctipo)+'&' +"numeroEvento="+Alltrim(Transform(xnroevento)) +;
		'&' +"numeroSocio="+Alltrim(Transform(xafi))+'&'+"motivoEgreso="+Alltrim(Transform(xmotivoegreso))+;
		'&'+"numeroPrestador=6001014081"+'&' +"fechaEgreso="+xcfechafin+;
		'&' +"api_key=27a2402e8bffd17a45f0e78c81c0f66c0a8c33a0e1b4deaa"
Endif


*https://servicios2.sg.com.ar/interfaces/osde/api.php
If !Used('mwkosde')
	Do sp_busco_estados With 57,' and tipo = 97  and subestado = 149  ','mwkosde'&&
Endif
If mwkosde.estado = 1 && esta habilitada la entidad
	lclink = Alltrim(mwkosde.Descrip)
	lclink = lclink +xcopera
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
*		cUrl = cUrl + Iif("?" $ cUrl, "&", "?") + "_ts=" + Ttoc(Datetime(),1)
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
		If mwkusuario.sector = 'SISTEMAS'
			Messagebox("Respuesta:"+Chr(10)+Alltrim(lcresp))
			Messagebox("Respuesta:"+Chr(10)+Alltrim(oHttp.ResponseText))
		Endif
		lcresp = oHttp.ResponseText

	Endif
	Strtofile(lcresp,"jsonresp.txt")
	If mwkusuario.sector = 'SISTEMAS'
		Messagebox("Respuesta:"+Chr(10)+Alltrim(lcresp))
	Endif
	Release oHttp
	If !Empty(lcresp)
		Create Cursor mwkjson (Consok L, numeroEvento N(10),mensaje c(200)   )
		lcjason = json(lcresp,'ok',0)
		lConsok =  (lcjason<>'false')
		lnumeroEvento  = Val(json(lcresp,'value',0))
		lmensaje   =  json(lcresp,'mensaje',0)
		Insert Into mwkjson   (Consok , numeroEvento ,mensaje ) Values (lConsok, lnumeroEvento, lmensaje)
	Else
		Insert Into mwkjson   (Consok , numeroEvento ,mensaje ) Values (.F., 0, "NO SE PUDO VALIDAR")
	Endif

	Wait Clear
Endif
Function json(texto,clave,comillas)
lcjson = texto
lcjsonclave = '"'+Alltrim(clave)+'":'
lninicio = At(lcjsonclave,lcjson)
lcstring = Substr(lcjson,lninicio,Len(lcjson)-lninicio)
lextra = At(":",lcstring)
lcstring = Substr(lcstring,lextra+1,Len(lcstring)-lextra)
If Left(lcstring,1)='"'
	lcstring = ALLTRIM(Strextract(lcstring,'"','"'))
Else
	lextra = At(",",lcstring)-1
	lcstring = ALLTRIM(Left(lcstring,lextra ))
Endif
lcstring = Strtran(lcstring,'"','')
Return lcstring
Endfunc
