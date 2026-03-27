Lparameters xnrodoc,xsexo
If Vartype(datosrena)='U'
	Public datosrena(20,2)
	Dimension datosrena(20,2)
Endif

datosrena(1,1)="resultado"
datosrena(2,1)="id"
datosrena(3,1)="identificadoRenaper"
datosrena(4,1)="nroDocumento"
datosrena(5,1)="apellido"
datosrena(6,1)="nombre"
datosrena(7,1)="sexo"
datosrena(8,1)="fechaNacimiento"
datosrena(9,1)="provincia"
datosrena(10,1)="localidad"
datosrena(11,1)="domicilio"
datosrena(12,1)="pisoDpto"
datosrena(13,1)="codigoPostal"
datosrena(14,1)="codigoBahraProvincia"
datosrena(15,1)="codigoBahraDepartamento"
datosrena(16,1)="codigoBahraLocalidad"
datosrena(17,1)="nombreObraSocial"
datosrena(18,1)="rnos"
datosrena(19,1)="tipoCobertura"
mopcion = 1&&Iif(mwkexe.nomexe='TURNOS',1,Iif(mwkexe.nomexe='GUARDIA',2, Iif(mwkexe.nomexe='ADMISION',3,1 )) )
nrodoc = Transform(xnrodoc)
sexo = Alltrim(Upper(xsexo))
Do sp_busco_estados With 57,' and tipo = 38 and subestado = '+Transform(mopcion ),'mwkhabrenaper'&&
*lclink = "https://desa.sg.com.ar/api/mk_renaper.php?documento=29319246&sexo=F"

If mwkhabrenaper.estado = 0 AND myip<>'172.16.1.7'
	Messagebox('TAREA EN IMPLEMENTACION',16,"CONTROL")
Else
	lclink = Alltrim(mwkhabrenaper.Descrip)
	lclink = lclink + '?documento=' + nrodoc + '&'+'sexo=' + sexo
	Local xmlHTTP As "Microsoft.XMLHTTP"
	xmlHTTP = Createobject("Microsoft.XMLHTTP")
	If Alltrim(Type("xmlHTTP")) <> "O"
		Messagebox( "No se pudo crear el objeto (XMLHTTP). No se pudo enviar la guía.",48,"Aviso")
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
	For xu = 1 To 19
		datosrena(xu,2)=json(lcresp,datosrena(xu,1),'"')
	Next xu

*Return datosrena
	Release xmlHTTP
Endif

Function json(texto,clave,comillas)
lcjson = texto
lcjsonclave = '"'+Alltrim(clave)+'":'
lninicio = At(lcjsonclave,lcjson)
lcstring = Substr(lcjson,lninicio,Len(lcjson)-lninicio)
lextra = At(":",lcstring)
lcstring = Substr(lcstring,lextra+1,Len(lcstring)-lextra)
lcstring = Strextract(lcstring,'"','"')
Return lcstring
Endfunc





