* Marcelo Torres, 07/11/2024
* Creamos objeto xmlhttp, según la versión de sistema operativo

Lparameters xmlHTTP

Local lOk

lOk = .T.

*Set Step On

If EsMayorIgualWin10()
	xmlHTTP = Createobject("Msxml2.ServerXMLHTTP.6.0")
Else
	xmlHTTP = Createobject("Microsoft.XMLHTTP")
*xmlHTTP = Createobject( "Msxml2.XMLHTTP.3.0" )
*xmlHTTP = Createobject("MSXML2.XMLHTTP")
Endif

If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP). No se puede consultar el servicio.",48,"Aviso")
	lOk = .F.
Endif


Return lOk

* ----------------------------------------
Function EsMayorIgualWin10()

Local loWMI, loOS, lcCaption
Local lResult
Local cVersion
Local nPosIni, nPosFin

lResult = .T.
cVersion = ""
nPosIni = 0
nPosFin = 0
lcCaption = ""

Try
* Crear un objeto WMI para acceder a información del sistema
	loWMI = Getobject("winmgmts:\\.\root\cimv2")
* Ejecutar la consulta para obtener información del sistema operativo
	loOS = loWMI.ExecQuery("SELECT * FROM Win32_OperatingSystem")
* Recorrer la colección y obtener el nombre completo del sistema operativo
	For Each objOS In loOS
		lcCaption = Upper(objOS.Caption)
&& Esto contiene el nombre completo del sistema operativo
*? "Sistema Operativo:", lcCaption

	Endfor
Catch TO oError

Endtry

nPosIni = At("WINDOWS", lcCaption)

If nPosIni > 0

	cVersion = Substr(lcCaption,nPosIni+8,Len(lcCaption)-nPosIni+8)

	If !Empty(cVersion)
		nPosFin = At(" ",cVersion)

		If nPosFin > 0
			cVersion = Alltrim(Substr(cVersion,1,nPosFin))
		Endif

		Do Case
		Case Val(cVersion) >= 8   && Mayor o igual a Windows 8
			lResult = .T.
		Otherwise     && Menor a Windows 10
			lResult = .F.
		Endcase
	Endif

Endif

loWMI = null 
loOS = null

Return lResult
