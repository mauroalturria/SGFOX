Lparameters  xturnos,xconsu,xestado

If myip='172.16.1.7'
	Set Step On
Endif
*https://desa.sg.com.ar/api/mk_sg_informar.php?operacion=informarllamado&turnCodigo=A-1-ID-22635009
*&consDescripcion=LIMA23 turnInicioAtencion: true / false        // true: paciente ingresó al consultorio; false: solo fue llamado   } }
If Vartype(xestado)<>"N"
	xestado=0
Endif

If Vartype(xturnos)="N"
	xturnos2 = Alltrim(Transform(xturnos))
Else
	If Vartype(xturnos)<>"C"
		xturnos2 = Alltrim(Transform(xturnos))
	Else
		xturnos2 = xturnos
	Endif
Endif

Do sp_busco_estados With 57,' and tipo = 72 and subestado = ?mxcentromedico ','mwkhabevMK'

xesta= Iif( xestado = 0 ,'false','true')
If mwkhabevMK.estado = 1
	lclink = Alltrim(mwkhabevMK.Descrip)
	lclink = lclink + '?operacion=informarllamadoConsultorio'   + '&'+'turnocodigo=' + Alltrim(xturnos2)
	lclink = lclink + '&'+'consDescripcion=' +  Alltrim(xconsu)+ '&'+'turnInicioAtencion=' + xesta

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

	Release xmlHTTP

	Messagebox(lcresp,64,"AVISO")

Endif
