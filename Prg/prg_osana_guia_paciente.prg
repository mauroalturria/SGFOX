Parameters pdat1,ptipo,pdelay

* Mensajes OSANA (Envia guía del paciente cuando el paciente se interna)

* 2022-03-04
* tipo 1 = Alta
* tipo 2 = Internación
* tipo 3 = Prequirúrgico
* tipo 4 = Concierge

* 2023-12-19
* tipo 5 = Review


*!*	* -----------  Para prueba
*!*	Do sp_conexion
*!*	*!*	*dat1 = "3269525-2" && HC Andre
*!*	*!*	pdat1 = "3749316-9"
*!*	pdat1 = "3749316-9"
*!*	ptipo = 2
*!*	pdelay = 1
*!*	Set Step On
*!*	* ------------------------------



mhc = pdat1
lntipo = ptipo
ldelay = Alltrim(Str(pdelay))

If !Vartype(mhc)="C"
	Messagebox("El parámetro de HC no es válido.",48,"Envío de mensajeria")
	Return
Endif

lcSql = "select REG_nroregistrac,REG_numdocumento from registracio where REG_nrohclinica = ?mhc"

If !Prg_EjecutoSql(lcSql,'mwkRegPac')
	Return .F.
Endif

If !Used('mwkRegPac')
	Return .F.
Endif

Select mwkRegPac

msigo = .T.

mv1 = ''
mv2 = ''
lctipo = ""
lcmensaje = ""

Do Case
Case lntipo = 1
	lctipo = "ALTA"
	lcmensaje = "Aguarde por favor"
Case lntipo = 2
	lctipo = "INTERNACION"
	lcmensaje = "Enviando Mensaje de Guía del Paciente. Aguarde por favor"
Case lntipo = 3
	lctipo = "PREQUIRURGICO"
	lcmensaje = "Enviando Mensaje de Guía Preoperatoria al Paciente. Aguarde Por Favor"
Case lntipo = 4
	lctipo = "CONCIERGE"
	lcmensaje = "Enviando Mensaje de Guía del Paciente (Concierge). Aguarde Por Favor"
Case lntipo = 5
	lctipo = "REVIEW"
	lcmensaje = "Enviando Mensaje. Aguarde Por Favor"
Endcase


* Envio de Wapp


lnenviado = 0
mccon = ''
mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)

lcbusco = ""

Do Case
Case  (".190" $ mccon) && Desarrollo 190
	lcbusco = Transform(mwkRegPac.REG_nroregistrac)
	lclink = "https://desa.sg.com.ar/ws-osana/sg-info-paciente.php?tipo="+lctipo+"&regi="+lcbusco+'&delay='+ldelay
Case  (".50.110" $ mccon) && Desarrollo 50.110
	lcbusco = Transform(mwkRegPac.REG_nroregistrac)
	lclink = "https://desa.sg.com.ar/ws-osana/sg-info-paciente.php?tipo="+lctipo+"&regi="+lcbusco+'&delay='+ldelay
Case ("CACHEQAS.SERV.SCA.LOCAL" $ mccon) Or (".50.102" $ mccon)
*!*	Case  (".50.102" $ mccon) && QAS 50.102
	lcbusco = Transform(mwkRegPac.REG_nroregistrac)
	lclink = "https://serviciosqas.sg.com.ar/ws-osana/sg-info-paciente.php?tipo="+lctipo+"&regi="+lcbusco+'&delay='+ldelay
Otherwise  && Producción
	lcbusco = Transform(mwkRegPac.REG_numdocumento)
	lclink = "https://servicios.sg.com.ar/ws-osana/sg-info-paciente.php?tipo="+lctipo+"&docu="+lcbusco+'&delay='+ldelay
Endcase


lclink = Strtran(lclink,' ','%20')


*!*		loXmlHttp = Newobject( "Microsoft.XMLHTTP" )
*!*		If Vartype(loXmlHttp)="O"
*!*			loXmlHttp.Open( "POST" , lclink, .F. )
*!*			If loXmlHttp.ReadyState = 1
*!*				loXmlHttp.Send()
*!*				If loXmlHttp.ReadyState = 4
*!*					lcresp = Alltrim(loXmlHttp.responseText)
*!*					If loXmlHttp.Status = 200
*!*						If !Vartype(lcresp)="C"
*!*							lcresp = "ERROR BORRAR"
*!*						Endif
*!*						lcmsgtel = "Número de celular: " + mv7
*!*						lerror = .F.
*!*						If 'ERROR' $ Upper(lcresp)
*!*							lerror = .T.
*!*						Endif
*!*						If !Empty(lcresp) And !lerror
*!*							Messagebox('El recordatorio de turno fue enviado con éxito.'+Chr(10)+lcmsgtel,64,'Aviso')
*!*						Else
*!*							Messagebox('No se pudo enviar recordardatorio de turno al Whatsapp del paciente.',48,'Aviso')
*!*						Endif
*!*					Else
*!*						lcresp = "No se puedo enviar. Estado: " + Alltrim(Str(loXmlHttp.Status))
*!*						Messagebox(lcresp,16,"Problema con XMLHTTP 1")
*!*					Endif
*!*				Else
*!*					lcresp = "Problema de conexión. Estado: " + Alltrim(Str(loXmlHttp.ReadyState))
*!*					Messagebox(lcresp,16,"Problema con XMLHTTP 2")
*!*				Endif
*!*			Else
*!*				lcresp = "NO ENVIADO - ESTADO: "+Alltrim(Str(loXmlHttp.ReadyState))
*!*				Messagebox(lcresp,16,"Problema con XMLHTTP 3")
*!*			Endif
*!*		Else
*!*			lcresp = "NO ENVIADO - Problema XMLHTTP 4"
*!*			Messagebox(lcresp,16,'Aviso')
*!*		Endif
*!*		Release loXmlHttp

Wait lcmensaje Window Nowait Noclear

*!*	Try
*!*		loXmlHttp = Createobject("MSXML2.XMLHTTP.6.0")
*!*		lcVersion = "6"
*!*	Catch
*!*		loXmlHttp = Createobject("MSXML2.XMLHTTP.3.0")
*!*		lcVersion = "3"
*!*	Endtry
*!*	loXmlHttp.Open( "POST" , lclink, .F. )
*!*	loXmlHttp.Send()
*!*	lcresp = Alltrim(loXmlHttp.responseText)

*!*	Do While loXmlHttp.readyState<>4
*!*		DoEvents
*!*	Enddo

*!*	Wait Clear

*!*	If !loXmlHttp.Status = 200
*!*		Messagebox("No se pudo enviar la Guía del Paciente en estos momentos."+Chr(10)+"",48,'Problemas con el servidor - Error: '+Alltrim(Str(loXmlHttp.Status)))
*!*		Else
*!*		If !Vartype(lcresp)="C"
*!*			lcresp = "ERROR BORRAR"
*!*		Endif
*!*		lerror = .F.
*!*		If 'ERROR' $ Upper(lcresp)
*!*			lerror = .T.
*!*		Endif
*!*		If !Empty(lcresp) And !lerror
*!*			Messagebox('La Guía del Paciente fue enviada con éxito.',64,'Aviso')
*!*		Else
*!*			Messagebox('No se pudo enviar la Guía del Paciente en estos momentos.'+Chr(10)+"Puede volver a intentar desde el botón Envío de Guìa del Paciente",48,'Aviso')
*!*		Endif
*!*	Endif

*!*	Release loXmlHttp

lcResu = ""
lnServidor = 0
*!*	loHTTP = Createobject("WinHttp.WinHttpRequest.5.1")
*!*	loHTTP.Open("GET", lclink , .F.)
*!*	loHTTP.Send()
*!*	lcResu = loHTTP.ResponseText
*!*	If loHTTP.Status = 200
*!*		Messagebox('La Guía del Paciente fue enviada con éxito.' ,64,'Aviso')
*!*	Endif
*!*	lnServidor = loHTTP.status
*!*	lbResu = Empty(loHTTP.ResponseText)
*!*	loHTTP = Null
*!*	Release loHTTP

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
lcResu = xmlHTTP.responseText
If xmlHTTP.Status = 200
	Messagebox('El mensaje fue enviado con éxito.' ,64,'Aviso')
Endif
lnServidor = xmlHTTP.Status
Release xmlHTTP

Wait Clear

ldato1 = mhc
ldato2 = lntipo
ldato3 = mwkRegPac.REG_nroregistrac
ldato4 = mwkRegPac.REG_numdocumento
ldato5 = sp_busco_fecha_serv("DT")
ldato6 = lcResu
ldato7 = lnServidor
ldato8 = lclink

lcSql = "insert into zablogguia (zlg_dni,zlg_fechora,zlg_hc,zlg_link,zlg_registracion,zlg_respserv,zlg_respuesta,zlg_tipo) values"+;
	"(?ldato4,?ldato5,?ldato1,?ldato8,?ldato3,?ldato7,?ldato6,?ldato2)"
If !Prg_EjecutoSql(lcSql)
	Return .F.
Endif


* Return

*!*	Strtofile(lclink,'linklog.txt')
*!*	_Cliptext=lclink
*!*	Wait

Function filtrochar(FiltroCadena)
NewCadena = ''
Cadena = Alltrim(Upper(FiltroCadena))
Cadena = Strtran(Cadena,'Ñ','N')
Cadena = Strtran(Cadena,'Á','A')
Cadena = Strtran(Cadena,'É','E')
Cadena = Strtran(Cadena,'Í','I')
Cadena = Strtran(Cadena,'Ó','O')
Cadena = Strtran(Cadena,'Ú','U')

For nLong = 1 To Len(Cadena)
	cChar = Substr(Cadena,nLong,1)
	nChar = Asc(cChar)
	If Between(nChar,65,90) Or Inlist(nChar,32,44)
		NewCadena = NewCadena + cChar
	Endif
Endfor

Return NewCadena
Endfunc

