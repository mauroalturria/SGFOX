* nOpcion = 1 -> confirmar
* nOpcion = 2 -> desconfirmar

* ---------------------------------------
Lparameters nIdTurno,mDNI,nOpcion


Local loXmlHttp
Local lclink
Local lo
Local cMsg
Local nOp
Local mAmbitoHab
Local mCentroHab
Local oIn
Local laArray(1)
Local lEncontro

cMsg = ""
nOp = -1
mCentroHab = ""
mAmbitoHab = ""
lEncontro = .F.


*!*	$mCodigoTurno         = $_GET['CodigoTurno'];
*!*	$mCodigoTurnoInterno  = $_GET['CodigoTurnoInterno'];
*!*	$mEstado              = $_GET['Estado'];
*!*	$mUsuario             = $_GET['Usuario'];

*!*	Set Step On

*!*	nIdTurno = 19332694
*!*	mDNI = 24823959
*!*	nOpcion = 1

*!*	nIdTurno = 20791016
*!*	mDNI = 13165678
*!*	nOpcion = 1


*Set Step On

** ----------------------- 06/05/2025 - utiliza la tabla tabctromedico
mret = SQLExec(mcon1,"SELECT id as centromedico, ambito from tabctromedico "+;
	" where activo = 1 and ambito = ?mxAmbito and centromedico = ?mxcentromedico and centromedicoMK > 0", "mwkctrlAmbitoCentro")

Select mwkctrlAmbitoCentro
lEncontro =  Reccount("mwkctrlAmbitoCentro")>0
Use In Select("mwkctrlAmbitoCentro")

If !lEncontro
	Return 0
Endif

Do sp_busco_estados With 61	,' and tipo = 0 ','mwkdesarrollo'&& indica que estamos en prueba
Do Case
Case  mwkdesarrollo.estado = 1
	lclink = "https://serviciosqas.sg.com.ar/api/mk_ausente_presente.php"
Case  mwkdesarrollo.estado = 2
	lclink = "https://desa.sg.com.ar/api/mk_ausente_presente.php"
Case  mwkdesarrollo.estado = 0
	lclink = "https://servicios.sg.com.ar/api/mk_ausente_presente.php"
ENDCASE
USE IN SELECT('mwkdesarrollo')


*!*	mccon = ''
*!*	mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)
*!*	Do Case
*!*	Case  (".190" $ mccon) && Desarrollo 190
*!*		lclink = "https://desa.sg.com.ar/api/mk_ausente_presente.php"
*!*	Case  (".50.110" $ mccon) && Desarrollo 50.110
*!*		lclink = "https://desa.sg.com.ar/api/mk_ausente_presente.php"
*!*	Case  (".50.102" $ mccon) && QAS 50.102
*!*		lclink = "https://serviciosqas.sg.com.ar/api/mk_ausente_presente.php"
*!*	Case ("CACHEQAS"	$ mccon)  && QAS post migración - Marcelo Torres, 29/08/2024
*!*		lclink = "https://serviciosqas.sg.com.ar/api/mk_ausente_presente.php"
*!*	Otherwise  && Producción
*!*		lclink = "https://servicios.sg.com.ar/api/mk_ausente_presente.php"
*!*	Endcase

* CodigoTurno
* CodigoTurnoInterno
* Estado
* Usuario

buscoturno = nIdTurno

lcsql = "select Nvl(idturnoexterno,0) as externo from turnos where ID = ?buscoturno"
If !Prg_EjecutoSql(lcsql,'mwkbuscoturnoex')
	Return .F.
Endif

lnturnoidext = mwkbuscoturnoex.externo

If Vartype(lnturnoidext)="C"
	lnturnoidext = Int(Val(mwkbuscoturnoex.externo))
Endif

If !lnturnoidext>0
	Return 0
Endif


lclink = lclink + "?CodigoTurno=0"
lclink = lclink + "&CodigoTurnoInterno=A-"+Transform(mxAmbito)+"-ID-"+ Transform(nIdTurno)

If nOpcion = 1
	lclink = lclink + "&Estado=PRESENTE"
Else
	lclink = lclink + "&Estado=AUSENTE"
Endif

lclink = lclink + "&Usuario=" + Transform(mDNI)

Try

	loXmlHttp = Createobject("MSXML2.XMLHTTP.3.0")

	loXmlHttp.Open( "GET" , lclink, .F. )
	loXmlHttp.Send()
	lcresp = Alltrim(loXmlHttp.responseText)

	nOp = At('"ESTADO":"OK"',Upper(lcresp) )

Catch To lo

	cMsg = ' Commentario : ' + lo.Comment + Chr(10)
	cMsg = cMsg + ' Detalles : ' + lo.Details+ Chr(10)
	cMsg = cMsg + ' Error Nro: '+ Transform(lo.ErrorNo) + Chr(10)
	cMsg = cMsg + ' Contenido de linea: '+ lo.LineContents+ Chr(10)
	cMsg = cMsg + ' Linea Nro: '+ Transform(lo.Lineno)+ Chr(10)
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

	Messagebox("Error al informar a MARKEY." + Chr(10) + Chr(10) + cMensaje + Chr(10) + "ID : " + Transform(nIdTurno)+Chr(10),16,"TURNO " + Iif(nOpcion =1, "CONFIRMA","DESCONFIRMA") )

Endif

Return nOp


