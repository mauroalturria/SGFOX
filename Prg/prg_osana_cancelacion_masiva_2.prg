* Envía mensajes de Whapp a traves del servicio de Osana para Cancelación de Turnos (Masiva o Común)
* cancelación masiva (frmturnos35)

If !Used("mwkphorariosmsg")
	Return .F.
Endif

If !Reccount("mwkphorariosmsg")>0
	Return .F.
Endif

Select mwkphorariosmsg

Scan All
	If myip='172.16.1.7'
		Wait Windows TRANSFORM(RECNO())+'/'+TRANSFORM(RECCOUNT('mwkphorariosmsg')) nowait
	Endif
	midturno = mwkphorariosmsg.Id
	mfectur =mwkphorariosmsg.fechatur
	mhortur = mwkphorariosmsg.horatur
	mafili 	= Round(mwkphorariosmsg.afiliado, 0)
	mcodesp = mwkphorariosmsg.codesp
	mcodmed = mwkphorariosmsg.codmed

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
*lclink1 = 'https://desa.sg.com.ar/ws-osana/sg-curl7.php?tipo=true&idtur='
		lclink1 = 'https://serviciosqas.sg.com.ar/ws-osana/sg-curl7.php?tipo=false&idtur='
	Otherwise  && Producción
		lclink1 = 'https://servicios.sg.com.ar/ws-osana/sg-curl7.php?tipo=true&idtur='
	Endcase

	If midturno > 0

* Busco si está en turnos cancel

*!*			mbuscoidturno = midturno
*!*			lcsql = "select id from turnoscancel where idturnos = ?mbuscoidturno"
*!*			If !Prg_EjecutoSql(lcsql,"mwkTurnoCancel")
*!*				Return .F.
*!*			Endif
*!*			If Reccount("mwkTurnoCancel")=0
		lclink2 = lidturno + Alltrim(Str(midturno))
		lclink = lclink1+lclink2+"&tturn=VISUAL"
		lclink = Strtran(lclink,' ','%20')
		loXmlHttp = Newobject( "Microsoft.XMLHTTP" )
		lcresp = ''
		lerror = .F.
		loXmlHttp.Open( "POST" , lclink, .F. )
		loXmlHttp.Send()
		lcresp = Alltrim(loXmlHttp.responseText)
		Release loXmlHttp
*Endif
	Endif
	Select mwkphorariosmsg
Endscan

Use In Select('mwkTurnoId')
Use In Select("mwkTurnoCancel")

Release mreservacancel,lccancelreserva,lidturno,lnambito,mbuscoidturno
