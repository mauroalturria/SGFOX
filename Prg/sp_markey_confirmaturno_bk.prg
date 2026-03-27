* nOpcion = 1 -> confirmar
* nOpcion = 2 -> desconfirmar

* ---------------------------------------
Lparameters nIdTurno,mDNI,nOpcion

Local loXmlHttp
Local lclink
Local lo
Local cMsg
Local nOp


cMsg = ""
nOp = -1

*!*	$mCodigoTurno         = $_GET['CodigoTurno'];
*!*	$mCodigoTurnoInterno  = $_GET['CodigoTurnoInterno'];
*!*	$mEstado              = $_GET['Estado'];
*!*	$mUsuario             = $_GET['Usuario'];

*!*	Set Step On

*!*	nIdTurno = 19332694
*!*	mDNI = 24823959
*!*	nOpcion = 1

*!*	Set Step On

mccon = ''
mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)

Do Case
Case  (".190" $ mccon) && Desarrollo 190
	lclink = "https://desa.sg.com.ar/api/mk_ausente_presente.php"
Case  (".50.110" $ mccon) && Desarrollo 50.110
	lclink = "https://desa.sg.com.ar/api/mk_ausente_presente.php"
Case  (".50.102" $ mccon) && QAS 50.102
	lclink = "https://serviciosqas.sg.com.ar/api/mk_ausente_presente.php"
Otherwise  && Producción
	***lclink = "https://servicios.sg.com.ar/api/mk_ausente_presente.php"
	RETURN 0
Endcase

* CodigoTurno
* CodigoTurnoInterno
* Estado
* Usuario

lclink = lclink + "?CodigoTurno=0"
lclink = lclink + "&CodigoTurnoInterno=A-"+Transform(mxAmbito)+"-ID-"+ Transform(nIdTurno)

If nOpcion = 1
	lclink = lclink + "&Estado=PRESENTE"
Else
	lclink = lclink + "&Estado=AUSENTE"
Endif

lclink = lclink + "&Usuario=" + Transform(mDNI)

TRY
      
	loXmlHttp = Createobject("MSXML2.XMLHTTP.3.0")

	loXmlHttp.Open( "GET" , lclink, .F. )
	loXmlHttp.Send()
	lcresp = Alltrim(loXmlHttp.responseText)

	nOp = At('"ESTADO":"OK"',Upper(lcresp) )        
    
Catch To lo

	cMsg = ' Commentario : ' + lo.Comment + Chr(10)
	cMsg = cMsg + ' Detalles : ' + lo.Details+ Chr(10)
	cMsg = cMsg + ' Error Nro: '+ TRANSFORM(lo.ErrorNo) + Chr(10)
	cMsg = cMsg + ' Contenido de linea: '+ lo.LineContents+ Chr(10)
	cMsg = cMsg + ' Linea Nro: '+ TRANSFORM(lo.Lineno)+ Chr(10)
	cMsg = cMsg + ' Mensaje: '+ lo.Message+ Chr(10)
	cMsg = cMsg + ' Procedure: '+ lo.Procedure+ Chr(10)
	*cMsg = cMsg + ' UserValue: '+ lo.UserValue+ Chr(10)
	*cMsg = cMsg + ' StackLevel: '+ TRANSFORM(lo.StackLevel) + Chr(10)

	Messagebox(cMsg,48,"ERROR DE COMUNICACION CON MARKEY")

Endtry


If nOp = 0

	nPos = At('"MENSAJE":',Upper(lcresp))
	cMensaje = ""

	If nPos > 0
		nPos = nPos + 11
		cMensaje = Substr(lcresp,nPos,Len(lcresp)-nPos)
		cMensaje = Strtran(cMensaje,'"',"")
	Endif

	Messagebox("Error al informar a MARKEY." + Chr(10) + Chr(10) + cMensaje + CHR(10) + "ID : " + TRANSFORM(nIdTurno)+CHR(10),16,"TURNO " + IIF(nOpcion =1, "CONFIRMA","DESCONFIRMA") )

Endif

Return nOp


