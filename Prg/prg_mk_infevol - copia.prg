Lparameters  xturnos,xevol,xestado
 
If myip='172.16.1.7'
	Set Step On
ENDIF
*https://desa.sg.com.ar/api/mk_sg_informar.php?operacion=informarevol&turnocodigo=526782213
*   &evolucion=esto es la evolucion del paciente&evolestado=true 
Do sp_busco_estados With 57,' and tipo = 72 ','mwkhabevMK'&&
xlestado = IIF(INLIST(xestado,17,23,28),'false','true')
If mwkhabevMK.estado = 1
	lclink = Alltrim(mwkhabevMK.Descrip)
	lclink = lclink + '?operacion=informarevol'   + '&'+'turnocodigo=' + Transform(xturnos)
	lclink = lclink + '&'+'evolucion=' +  xevol+ '&'+'evolestado=' +  xlestado

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
