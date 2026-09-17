Lparameters  codigoturnomk, nombreapi, valor, codigosala

If myip='172.16.1.7' Or myip='172.16.1.160'
	Set Step On
Endif

Local lnpermiso

lnpermiso = 0

If valor = 1
	lcEstado = "TRUE"
Else
	lcEstado = "FALSE"
Endif


Do sp_busco_estados With 57,' and tipo = 99 and subestado = ?mxcentromedico ','mwkpermiso'

Select mwkpermiso
lnpermiso = mwkpermiso.estado

If lnpermiso = 1
	lnhabilitaMK = 1
Else
	lnhabilitaMK = 0
Endif

lcURL = Alltrim(mwkpermiso.Descrip)

lclink = lcURL
lclink = lclink + '?operacion=' + Alltrim(nombreapi) + '&turnocodigo=' + Transform(codigoturnomk) + '&estado=' + lcEstado + '&usuario=' + Alltrim(mwkusuario.idusuario) + '&sala=' + Alltrim(codigosala)

If lnhabilitaMK = 1

	Local oHttp, cUrl, cResponse

	Try
		oHttp = Createobject("WinHttp.WinHttpRequest.5.1")
	Catch To loError
		Messagebox("No se pudo crear el objeto WinHttp. Error: " + loError.Message)
		Return
	Endtry

	cUrl = STRTRAN(lclink, " ", "%20")

	Try
		cUrl = lclink
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

Else
	lcresp = "Servicio infevol no activo"
Endif

If mwkusuario.sector = 'SISTEMAS'
	Messagebox(lcresp,64,"AVISO")
Endif
