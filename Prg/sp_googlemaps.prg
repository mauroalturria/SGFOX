*
* Google Maps
*             mdireccion = Calle + Nro + Provincia + Pais
*             

Lparameters mdireccion, musuario

*Set Step On

Google_Map(mdireccion, musuario)

*"Senador Pallares 1906, Valentin Alsina, BUENOS AIRES, ARGENTINA", "Alturria Mauro Emiliano")

*Google_Map(ALLTRIM(leg.leg_direccion)+' '+ALLTRIM(STR(leg.leg_numero))+', '+
*           ALLTRIM(leg.leg_localidad)+', '+'ARGENTINA',
*
*           ALLTRIM(leg.leg_apellido)+' ,'+ALLTRIM(leg.leg_nombre))


Procedure Google_Map
Lparameters miaddress, miname_id
Local oMiForm
oMiForm = Createobject("GoogleMapForm", miaddress, miname_id)
oMiForm.Show(1)
Return
Endproc

Define Class GoogleMapForm As Form
	Height = 560
	Width = 625
	AutoCenter = .T.
	Name = "MiForm"
	SetPoint = ""
	SetDecimals = 2
	ShowWindow = 1
	WindowType = 1
	TitleBar = 0
	BorderStyle = 2
	miname_id = ""

	Add Object Descrip As TextBox With ;
		HEIGHT = 24, Left = 12, Top = 12, Width = 330, MaxLength = 100, ;
		FORECOLOR = Rgb(88,99,124), BackColor = Rgb(255,255,255), ;
		SELECTEDFORECOLOR = Rgb(255,255,255), SelectedBackColor = Rgb(88,99,124), ;
		STYLE = 0, Name = "Descrip", SelectOnEntry = .T., Enabled = .T.

	Add Object cmdMostrar As CommandButton With ;
		TOP = 10, Left = 350, Height = 27, Width = 100, ;
		CAPTION = "Mostrar mapa", Name = "cmdMostrar"

*!*		Add Object cmdPrint As CommandButton With ;
*!*			TOP = 10, Left = 500, Height = 27, Width = 60, ;
*!*			CAPTION = "Imprimir", Name = "cmdPrint"

	Add Object cmdCerrar As CommandButton With ;
		TOP = 10, Left = 573, Height = 27, Width = 40, ;
		CAPTION = "Salir", Name = "cmdCerrar"

	Add Object oleIE As OleControl With ;
		TOP = 48, Left = 12, Height = 500, Width = 600, ;
		NAME = "oleIE", OleClass = "Shell.Explorer.2"

	Procedure Load
	Sys(2333,1)
	This.SetPoint = Set("Point")
	This.SetDecimals = Set("Decimals")
	Set Point To .
	Set Decimals To 8
	Set Safety Off
	Declare Integer ReleaseCapture In WIN32API
	Declare Integer SendMessage In WIN32API Integer, Integer, Integer, Integer
	Declare Integer GetFocus In WIN32API
	Endproc

	Procedure Init
	Lparameters miaddress, miname_id
	If Type('miname_id')<>'C'
		miname_id=''
	Endif
	This.miname_id = miname_id
	If Type('miaddress')<>'C'
		This.Descrip.Value=''
	Else
		This.Descrip.Value=miaddress
		Thisform.cmdMostrar.Click()
	Endif
	Endproc

	Procedure MouseDown
	Lparameters nButton, nShift, nXCoord, nYCoord
	Local lnHandle
	If nButton = 1
		ReleaseCapture()
		SendMessage(This.HWnd, 0x112, 0xF012,0)
	Endif
	Endproc

	Procedure cmdCerrar.Click
	Set Point To (Thisform.SetPoint)
	Set Decimals To (Thisform.SetDecimals)
	Thisform.Release
	Endproc

*!*		Procedure cmdPrint.Click
*!*		Thisform.PrintWindow(GetFocus(), "Imprimiendo ...")
*!*		Endproc

	Procedure PrintWindow
	Lparameters tnHWnd, tcJobName

	Local lcJobName    && Nombre de la tarea de impresion
	Local lnRetVal     && Valor de retorno de las funciones del API

	Declare Integer PrintWindow In DibApi32 ;
		INTEGER HWnd, ;
		INTEGER fPrintArea, ;
		INTEGER fPrintOpt, ;
		INTEGER wxScale, ;
		INTEGER wyScale, ;
		STRING @ szJobName

*!* PW_WINDOW para imprimir la ventana entera
*!* PW_CLIENT para imprimir el area cliente
*!* Como ajustar la imagen
*!* PW_BESTFIT se ajusta al papel pero se mantienen las proporciones
*!* PW_STRETCHTOPAGE se ajusta para cubrir totalmente el papel pero distorsiona las proporciones
*!* PR_SCALE escala el tamaño de impresion

	#Define PW_WINDOW 1
	#Define PW_CLIENT 2
	#Define PW_BESTFIT 1
	#Define PW_STRETCHTOPAGE 2
	#Define PW_SCALE 3

	lcJobName = tcJobName + Chr(0)
	lnRetVal = PrintWindow( tnHWnd, PW_CLIENT, PW_BESTFIT, 0, 0, @lcJobName)
	If lnRetVal != 0
		If lnRetVal != 6  && 6 = El usuario cancelo la impresión
			= Messagebox("Imposible Imprimir la ventana" + CRLF + ;
				"PrintWindow API retorno " + Str(lnRetVal), ;
				MB_ICONEXCLAMATION + MB_OK, ;
				"ERROR")
		Endif
	Endif
	Endproc

	Procedure cmdMostrar.Click
	If Empty(Alltrim(Thisform.Descrip.Value))
		Thisform.Descrip.SetFocus()
		Return
	Else

		lcClave = "http://maps.google.es/maps?file=api&v=2.x&" + ;
			"key=ABQIAAAAtOjLpIVcO8im8KJFR8pcMhQjskl1-YgiA" + ;
			"_BGX2yRrf7htVrbmBTWZt39_v1rJ4xxwZZCEomegYBo1w"

		TEXT TO lcHtml NOSHOW TEXTMERGE

		<html>
		  <head>
		    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
		    <title>Busqueda en Google Maps</title>
		    <script src="<<lcClave>>" type="text/javascript"></script>
		    <script type="text/javascript">
		    //<![CDATA[
		    var map = null
		    var geocoder = null
		    var address = "<<Strtran(ALLTRIM(ThisForm.Descrip.Value),'ñ','n')>>"

		    function load()
		    { if (GBrowserIsCompatible())
		      { map = new GMap2(document.getElementById("map"),'G_SATELLITE_MAP');
		        map.addControl(new GLargeMapControl());
		        map.addControl(new GMapTypeControl());
		        map.addControl(new GOverviewMapControl());
		        geocoder = new GClientGeocoder();
		        if (geocoder) {
		          geocoder.getLatLng(address,
		        function(point)
		        { if (!point)
		          { alert("No Encontrado");
		            }
		          else
		          { map.setCenter(point, 17);
		            map.setMapType(G_NORMAL_MAP);
		            var marker = new GMarker(point);
		            map.addOverlay(marker);
		            marker.openInfoWindowHtml('<<Thisform.miname_id>>' + '<br>' + address);
		            }
		          }
		        );
		       }
		      }
		    }
		    //]]>
		    </script>
		  </head>
		  <body  scroll="no" bgcolor="#CCCCCC" topmargin="0" leftmargin="0" onload="load()" onunload="GUnload()">
		  <div id="map" style="width: 100%; height: 100%"></div>
		  </body>
		</html>
		ENDTEXT

		Strtofile(lcHtml,"MiHtml.htm")
		Thisform.oleIE.Navigate2(Fullpath("MiHtml.htm"))

	Endif
	Endproc

Enddefine







