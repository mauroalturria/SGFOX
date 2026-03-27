* Envía mensajes de Whapp a traves del servicio de Osana para Cancelación de 1 Turno

Parameters turnoid

*turnoid = 20703696
*Do sp_conexion
*Set Step On 

lnambito = mxambito
lnturnoid = turnoid

lidturno = 'A-'+Alltrim(Str(lnambito))+'-I-'

* Verificación a dónde se conecta

mccon = ''
mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)

Do Case
Case  (".190" $ mccon) && Desarrollo
	lclink1 = 'https://desa.sg.com.ar/ws-osana/sg-curl7.php?tipo=false&idtur='
Case  (".50.110" $ mccon) && Desarrollo
	lclink1 = 'https://desa.sg.com.ar/ws-osana/sg-curl7.php?tipo=false&idtur='
Case  (".50.102" $ mccon) && QAS
	lclink1 = 'https://serviciosqas.sg.com.ar/ws-osana/sg-curl7.php?tipo=false&idtur='
Otherwise  && Producción
	lclink1 = 'https://servicios.sg.com.ar/ws-osana/sg-curl7.php?tipo=false&idtur='
Endcase


* Busco si está en turnos cancel (si está quiere decir que ya fue cancelado)
mbuscoidturno = lnturnoid
lcsql = "select id from turnoscancel where idturnos = ?mbuscoidturno"
If !Prg_EjecutoSql(lcsql,"mwkTurnoCancel")
	Return .F.
Endif
If Reccount("mwkTurnoCancel")>0
	lclink2 = lidturno + Alltrim(Str(lnturnoid))
	lclink = lclink1+lclink2+"&tturn=VISUAL"
	lclink = Strtran(lclink,' ','%20')

	Wait "Enviando mensaje de whatsapp. Aguarde por favor." Window Nowait Noclear

*!*		Try
*!*			loXmlHttp = Createobject("MSXML2.XMLHTTP.6.0")
*!*			lcVersion = "6"
*!*		Catch
*!*			loXmlHttp = Createobject("MSXML2.XMLHTTP.3.0")
*!*			lcVersion = "3"
*!*		Endtry

*!*		loXmlHttp.Open( "POST" , lclink, .F. )
*!*		loXmlHttp.Send()
*!*		lcresp = Alltrim(loXmlHttp.responseText)

*!*		Do While loXmlHttp.readyState<>4
*!*			DoEvents
*!*		Enddo

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

	If !lnServidor = 200
		Messagebox('No se pudo enviar Whatsapp. Tipo de Error: '+Alltrim(Str(lnServidor)),48,'Problemas con el Servidor')
	Endif

	Release xmlHTTP

Endif

Use In Select("mwkTurnoCancel")

Release mreservacancel,lccancelreserva,lidturno,lnambito,mbuscoidturno

* Notas de la versión
* Actualización 2022-07-05
* Actualización 2022-12-26 (Se cambió el objeto MSXML)
