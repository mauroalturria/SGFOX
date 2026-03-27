Lparameters xdni,xcodent,xdiagno

If myip='172.16.1.7'
	Set Step On
Endif
If Vartype(xcodent)<>"N"
	xcodent=0
Endif
If xcodent =0
	Return
Endif
micod = xcodent
*https://staging-clients.azure.megsupporttools.com/hl7/api/v1/entrypoint/sanatorio-guemes/

*https://serviciosdev.sg.com.ar/interfaces/SendMegHL7_A01.php?hc=1293334-9&dni=22363468
*&apellido=ALTURRIA&nombre=MAURO&snombre=EMILIANO&fecnac=19710904&sexo=M&calle=123%20CALLE%20FALSA%20456
*&piso=PISO%203&ciudad=CABA&prov=BUENOS%20AIRES&cp=1407&telfijo=%28011%294321-0000
*&telmovil=%28011%2915-5555-2222&email=mauro_alturria@gmail.com&tipopac=E&sector=UCO&hab=HAB-111&cama=CAMA-11
*&admision=727579-6&obrasoc=Osde&condclin=CORONARIO&motivo=Descompensacion%20por%20Presion
Do sp_busco_estados With 57,' and tipo = 88  and subestado = ?micod  ','mwkAltaOsana'&&
If mwkAltaOsana.estado = 1 && esta habilitada la entidad
	xdni =Transform(xdni)
	If Vartype(xdiagno )<>"C"
		xdiagno =''
	Endif
	If mwkAltaOsana.estado = 1
		lclink = Alltrim(mwkAltaOsana.Descrip)
		lcdatos =  '?pacienteDni=' + Alltrim(xdni) + '&'+'diagnostico=' + Transform(xdiagno)
		lclink = lclink +lcdatos

		Local oHttp, cUrl, cResponse

		Try
			oHttp = Createobject("WinHttp.WinHttpRequest.5.1")
		Catch To loError
*	Messagebox("No se pudo crear el objeto WinHttp. Error: " + loError.Message)
			Select mwkusuario
			Go Top
			midusua     = mwkusuario.idusuario
			Do sp_insert_tabctrlerr With lclink , "No se pudo crear el objeto WinHttp. Error: " + loError.Message, midusua, "prg_osana_alta"
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
*	Messagebox("Error al enviar la solicitud: " + loError.Message)
			Select mwkusuario
			Go Top
			midusua     = mwkusuario.idusuario
			Do sp_insert_tabctrlerr With lclink , "Error al enviar la solicitud: "  + loError.Message, midusua, "prg_osana_alta"

			Return
		Endtry

		If oHttp.Status = 200
			cResponse = oHttp.ResponseText
			lcresp = cResponse
		Else
			lcresp = Transform(oHttp.Status)
		Endif
		Strtofile(lcresp,"jsonresp.txt")
		If mwkusuario.sector = 'SISTEMAS'
			Messagebox("Respuesta:"+Chr(10)+Alltrim(lcresp))
		Endif
		If json(lcresp,"ok",0)<>'true'
			Select mwkusuario
			Go Top
			midusua     = mwkusuario.idusuario
			Do sp_insert_tabctrlerr With lcdatos , "ERROR OSANA ", midusua, "prg_osana_alta"


		Endif
		Release oHttp
		Wait Clear
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
