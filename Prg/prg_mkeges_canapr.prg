Lparameters xnovedad,xturnos,xnroregistrac,xvale,xsala,xcodprest,xentidad
If Vartype(xnroregistrac)<>"N"
	xnroregistrac= 0
Endif
If Vartype(xnroregistrac)<>"N"
	xnroregistrac= 0
Endif
If Vartype(xcodprest)<>"C"
	If Vartype(xcodprest)<>"N"
		xcodprest = 0
	Endif
Endif
If Vartype(xvale)<>"C"
	If Vartype(xvale)<>"N"
		xvale= 0
	Endif
Endif
If Vartype(xsala)<>"C"
	xsala = 'SINFRANJA'
Endif
If Vartype(xentidad)<>"N"
	xentidad= 0
Endif
If myip='172.16.1.7'
	Set Step On
Endif
*https://desa.sg.com.ar/api/mk_eges_admcan.php?novedad=A&turnos=0&nroregistrac=2801826&vale=12345&sala=9&codprest=34055960&entidad=948
Do sp_busco_estados With 57,' and tipo = 43 ','mwkhabegMK'&&

If mwkhabegMK.estado = 1
	lclink = Alltrim(mwkhabegMK.Descrip)
	lclink = lclink + '?novedad=' + Alltrim(xnovedad) + '&'+'turnos=' + Transform(xturnos)
	lclink = lclink + '&'+'nroregistrac=' +  Alltrim(Transform(xnroregistrac))
	lclink = lclink + '&'+'vale=' +  Alltrim(Transform(xvale))
	lclink = lclink + '&'+'sala=' + Alltrim(Transform(xsala))
	lclink = lclink + '&'+'codprest=' +  Alltrim(Transform(xcodprest))
	lclink = lclink + '&'+'entidad=' +  Alltrim(Transform(xentidad))

	Local xmlHTTP As "Microsoft.XMLHTTP"
	xmlHTTP = Createobject("Microsoft.XMLHTTP")
	If Alltrim(Type("xmlHTTP")) <> "O"
		Messagebox( "No se pudo crear el objeto (XMLHTTP). ",48,"Aviso")
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
	Return lcresp
	Release xmlHTTP
Endif
