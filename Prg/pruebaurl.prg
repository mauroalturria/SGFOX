
Local oHttp, cUrl, cResponse, lclink

lclink = "https://servicios2.sg.com.ar/interfaces/osde/api.php"+;
	"?operacion=crear-evento&numeroSocio=60396963101&numeroPrestador=6001014081&"+;
	"diagnostico=XX3&fechaInicioTentativa=2026-08-18T13:05:00&"+;
	"fechaFinTentativa=2026-08-18T13:05:00&"+;
	"api_key=27a2402e8bffd17a45f0e78c81c0f66c0a8c33a0e1b4deaa"

Set Step On

Try
	oHttp = Createobject("WinHttp.WinHttpRequest.5.1")
Catch To loError
	Messagebox("No se pudo crear el objeto WinHttp. Error: " + loError.Message)
	Return
Endtry

cUrl = lclink

Try
	cUrl = lclink
*	cUrl = cUrl + Iif("?" $ cUrl, "&", "?") + "_ts=" + Ttoc(Datetime(),1)
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
	
	Messagebox("HTTP: " + Chr(13) + lcresp)

Else

	cResponse = oHttp.ResponseText

	lcresp = Transform(oHttp.Status) + Chr(13) + cResponse

	Messagebox("Error HTTP: " + Chr(13) + lcresp)

Endif
