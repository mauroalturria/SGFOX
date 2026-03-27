Lparameters  xturnos, xevol, xestado, operacion, xsala

If myip='172.16.1.7'
	Set Step On
Endif
If Vartype(xevol)<>"C"
	xevol=""
Endif
* Nueva versión de prg 2025-09-02 (Fabián)
* Se cambia la forma de llamar al servicio usando otro componente más compatible.

Local lnpermiso
lnpermiso = 0

Do sp_busco_estados With 57,' and tipo = 85 and subestado = ?mxcentromedico ','mwkhabilitainfevol'
Do sp_busco_estados With 57,' and tipo = 84 and subestado = ?mxcentromedico ','mwkpermiso'
Do sp_busco_estados With 57,' and tipo = 72 and subestado = ?mxcentromedico ','mwkInfevol'

Select mwkpermiso
lnpermiso = mwkpermiso.estado

If lnpermiso = 1
	cDescrip = Alltrim(mwkpermiso.Descrip)
	nCantidad = Occurs(",", cDescrip) + 1
	For i = 1 To nCantidad
		nValor = Val(Getwordnum(cDescrip, i, ","))
		If mwkusuario.codigovax = nValor
			lnhabilitaMK = 1
			Exit
		Else
			lnhabilitaMK = 0
		Endif
	Endfor
Else
	lnhabilitaMK = mwkhabilitainfevol.estado
Endif

xlestado = Iif(Inlist(xestado,17,23,28),'false','true')

lcURL = Alltrim(mwkInfevol.Descrip)

Do Case

Case operacion = "informarevol"

	lclink = lcURL
	lclink = lclink + '?operacion=informarevol'   + '&'+'turnocodigo=' + Transform(xturnos)
	lclink = lclink + '&'+'evolucion=' +  xevol+ '&'+'evolestado=' +  xlestado

Case operacion = "informaevolucion"  &&& para informes

	lclink = lcURL
	lclink = lclink + '?operacion=informaevolucion'   + '&'+'turnocodigo=' + Transform(xturnos)
	lclink = lclink + '&'+'entrEvolucion=' +  xevol+ '&'+'entrAtendido=' +  xlestado

*!*	Case operacion = "informarllamadoconsultorio"  &&& para informes

*!*		lclink = lcURL
*!*		lclink = lclink + '?operacion= informarllamadoconsultorio'   + '&'+'turnocodigo=' + Transform(xturnos)
*!*		lclink = lclink + '&consDescripcion=' + Alltrim(xsala)
*!*		lclink = lclink + '&'+'turnInicioAtencion=' +  xlestado



Case operacion = "informarllamadof" Or  operacion = "informarllamadot"  Or  operacion ="informarllamadoconsultorio"

	lclink = lcURL
	lclink = lclink + '?operacion=informarllamado'   + '&'+'turnocodigo=' + Transform(xturnos)
	lclink = lclink + '&sala=' + Alltrim(xsala)+'&inicio=' +xlestado

	If operacion = "informarllamadof"
		lclink = lclink + '&inicio=false'
	Else
		lclink = lclink + '&inicio=true'
	Endif
Case  operacion ="informarllamadoconsultorio"

	lclink = lcURL
	lclink = lclink + '?operacion=informarllamado'   + '&'+'turnocodigo=' + Transform(xturnos)
	lclink = lclink + '&sala=' + Alltrim(xsala)+'&inicio=' +xlestado
 

Otherwise

	lcresp = "Faltan Definir Parámetros para Informar a MK"
	Return

Endcase


If lnhabilitaMK = 1

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
*Messagebox("Respuesta recibida:" + Chr(13) + cResponse)
		lcresp = cResponse
	Else
*Messagebox("Error HTTP: " + Transform(oHttp.Status))
		lcresp = Transform(oHttp.Status)
	Endif

Else
	lcresp = "Servicio infevol no activo"
Endif

If mwkusuario.sector = 'SISTEMAS'
	Messagebox(lcresp,64,"AVISO")
Endif


Return lcresp
