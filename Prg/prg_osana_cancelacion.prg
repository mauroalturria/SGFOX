* Envía mensajes de Whapp a traves del servicio de Osana para Cancelación de Turnos (Masiva o Común)

Parameters nroreserva

lccancelreserva = nroreserva

* cancelación masiva (frmturnos35)

lnambito = mxambito

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
		*lclink1 = 'https://desa.sg.com.ar/ws-osana/sg-curl7.php?tipo=false&idtur='
		lclink1 = 'https://serviciosqas.sg.com.ar/ws-osana/sg-curl7.php?tipo=false&idtur='
	Otherwise  && Producción
		lclink1 = 'https://servicios.sg.com.ar/ws-osana/sg-curl7.php?tipo=false&idtur='
Endcase

mreservacancel = Alltrim(lccancelreserva)

lcsql = "select id from turnos where codreserva = ?mreservacancel"
If !Prg_EjecutoSql(lcsql,"mwkTurnoId")
	Return .F.
Endif

If Reccount("mwkTurnoId")>0

	If Nvl(mwkTurnoId.Id,0)>0

* Busco si está en turnos cancel

		mbuscoidturno = mwkTurnoId.Id
		lcsql = "select id from turnoscancel where idturnos = ?mbuscoidturno"
		If !Prg_EjecutoSql(lcsql,"mwkTurnoCancel")
			Return .F.
		Endif
		If Reccount("mwkTurnoCancel")=0
			lclink2 = lidturno + Alltrim(Str(mwkTurnoId.Id))
			lclink = lclink1+lclink2+"&tturn=VISUAL"
			lclink = Strtran(lclink,' ','%20')

*!*				loXmlHttp = Newobject( "Microsoft.XMLHTTP" )
*!*				lcresp = ''
*!*				lerror = .F.
*!*				loXmlHttp.Open( "POST" , lclink, .F. )
*!*				loXmlHttp.Send()
*!*				lcresp = Alltrim(loXmlHttp.responseText)
*!*				Release loXmlHttp

* -------------
			Wait "Enviando mensaje de whatsapp. Aguarde por favor." Window Nowait Noclear

			Try
				loXmlHttp = Createobject("MSXML2.XMLHTTP.6.0")
				lcVersion = "6"
			Catch
				loXmlHttp = Createobject("MSXML2.XMLHTTP.3.0")
				lcVersion = "3"
			Endtry
			loXmlHttp.Open( "POST" , lclink, .F. )
			loXmlHttp.Send()
			lcresp = Alltrim(loXmlHttp.responseText)

			Do While loXmlHttp.readyState<>4
				DoEvents
			Enddo

			Wait Clear

			If !loXmlHttp.Status = 200
				Messagebox('Tipo de Error: '+Alltrim(Str(loXmlHttp.Status)),48,'Problemas con el Servidor')
			Else
*!*			If !Vartype(lcresp)="C"
*!*				lcresp = "ERROR BORRAR"
*!*			Endif
*!*			lerror = .F.
*!*			If 'ERROR' $ Upper(lcresp)
*!*				lerror = .T.
*!*			Endif
*!*			If !Empty(lcresp) And !lerror
*!*				Messagebox('El mensaje fue eviado con éxito.',64,'Aviso')
*!*			Else
*!*				Messagebox('No se pudo enviar el mensaje.',48,'Aviso')
*!*			Endif
*!*		Endif
				Release loXmlHttp
* -------------



			Endif
		Endif
	Endif
Endif


Use In Select('mwkTurnoId')
Use In Select("mwkTurnoCancel")

Release mreservacancel,lccancelreserva,lidturno,lnambito,mbuscoidturno

