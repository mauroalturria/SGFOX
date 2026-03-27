Lparameters xnroreg,xtabm
mitiempo = Seconds()
nroreg = Transform(xnroreg)
tabm = Alltrim(Upper(xtabm))
Wait Windows "Actualiza MK" Nowait
mopcion =  Iif(mwkexe.nomexe='TURNOS',1,Iif(mwkexe.nomexe='GUARDIA',2, Iif(mwkexe.nomexe='ADMISION',3,1 )) )
Do sp_busco_estados With 57,' and tipo = 39 order by subestado ','mwkhabnovmk'&&
Select mwkhabnovmk
Locate For subestado = mopcion
If !Found()
	Go Top
Endif
If mwkhabnovmk.estado=1
*lclink = "https://desa.sg.com.ar/api/mk_novedad_paciente.php?registracion=953470&tipo=A"
	lclink = Alltrim(mwkhabnovmk.Descrip)
	lclink = lclink + '?registracion=' + nroreg + '&'+'tipo=' + tabm
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
	mitiemp2 = Seconds()
	secdem = mitiemp2 -mitiempo
*!*		If mwkusuario.idusuario = 'CARMENA' And sp_busco_fecha_serv("DD")=Ctod("11/06/2024")
*!*			Messagebox("Proceso Actualizacion demora " + Transform(secdem ))
*!*		Endif
	If !xmlHTTP.Status = 200
		Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
	Else
		If !Vartype(lcresp)="C"
			lcresp = ""
		Endif
		If myip='172.16.1.7'
			Messagebox(lcresp)
		Endif
	Endif
	Wait Windows "Fin Actualizacion MK" Nowait


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





