*!*	_Screen.Visible = .F.
*!*	_screen.Visible = .T. 

Public zzvolumen, nentipad, ldesconecto
lcErrorAnt = On("ERROR")

If !File("c:\Qepd1a1\exe\BarCodeLibrary.dll")
	If  File("x:\qepd1a1\Exe\BarCodeLibrary.dll")
		Copy File ("x:\qepd1a1\Exe\BarCodeLibrary.dll") To ("c:\Qepd1a1\exe\BarCodeLibrary.dll")
	Endif
Endif

Set Procedure To FoxBarcode.prg  Additive

_Screen.AddProperty("oFBC")
_Screen.oFBC = Createobject("FoxBarcode")

On Error *
lcDestino = "c:\Qepd1a1\Exe\richtx32.ocx"

lcOrigen = "X:\qepd1a1\Exe\richtx32.ocx"
If !File(lcDestino)
	If File(lcOrigen)
		Copy File (lcOrigen) To (lcDestino)
	Else
		lcOrigen = "H:\qepd1a1\Exe\richtx32.ocx"
		If File(lcOrigen)
			Copy File (lcOrigen) To (lcDestino)
		Else
&& NO SE PUDO COPIAR
		Endif
	Endif
Endif
myip = IPAddress()
Do prg_proxy
On Error &lcErrorAnt

On Error =Aerr(eros)
If File("C:\Qepd1a1\xlt\sg2.bmp")
	Delete File C:\Qepd1a1\xlt\sg2.bmp
Endif
If File("C:\Qepd1a1\xlt\sg2.gif")
	Delete File C:\Qepd1a1\xlt\sg2.gif
Endif
If File("C:\Qepd1a1\xlt\sg3.bmp")
	Delete File C:\Qepd1a1\xlt\sg3.bmp
Endif
If File("C:\Qepd1a1\xlt\sg3.gif")
	Delete File C:\Qepd1a1\xlt\sg3.gif
Endif

* Modificación : 2010-11-11 15:20
* Rutina ..... : on error
* Observación  : manejo de errores, para implementacion general en todos los sistemas
Do prg_ErrorSet


miform = ''
**
#Define WS_VERSION_REQD        257
#Define WS_VERSION_MAJOR    1
#Define WS_VERSION_MINOR    1
#Define MIN_SOCKETS_REQD    1
#Define SOCKET_ERROR        -1
#Define WSADESCRIPTION_LEN     256
#Define WSASYS_STATUS_LEN     128

*!* Windows NetBIOS
#Define NCBENUM                     55
#Define NCBASTAT                    51
#Define NCBNAMSZ                    16
#Define HEAP_ZERO_MEMORY            8
#Define HEAP_GENERATE_EXCEPTIONS    4
#Define NCBRESET                    50

*!* Devuelve las direcciones IP
*!* Sintaxis: IPAddress()
*!* Valor devuelto: lcRetVal
*!* lcRetVal viene expresado como una cadena con el formato: 192.100.100.100, 192.100.100.101, ...
Function IPAddress
Local lnCnt, lpWSAData, lpWSHostEnt, lpHostName, lcRetVal, lpHostIp_Addr, ;
	lpHostEnt_Addr, lnHostEnt_Lenght, lnHostEnt_AddrList
*!* Instrucciones DECLARE DLL para manipular Windows Sockets
Declare Integer WSAGetLastError In WSock32.Dll
Declare Integer WSAStartup In WSock32.Dll Integer wVersionRequested , String @lpWSAData
Declare Integer WSACleanup In WSock32.Dll
Declare Integer gethostname In WSock32.Dll String @lpHostName, Integer iHostNameLenght
Declare Integer gethostbyname In WSock32.Dll String lpHostName
Declare RtlMoveMemory In Win32API String @lpDest, Integer nSource, Integer nBytes
*!* Valores
lcRetVal           = ''
lpHostName         = Space(256)
lnHostEnt_Addr     = 0
lnHostEnt_Lenght   = 0
lnHostEnt_AddrList = 0
lnHostIp_Addr      = 0
lpTempIp_Addr      = Chr(0)
lpHostIp_Addr      = Replicate(Chr(0), 4)
lpWSHostEnt        = Replicate(Chr(0), 4 +4 +2 +2 +4)
lpWSAData          = Replicate(Chr(0), 2 +2 + ;
	WSADESCRIPTION_LEN +1 +WSASYS_STATUS_LEN +1 +2 +2 +4)
*!* Iniciar Windows Sockets
If WSAStartup(WS_VERSION_REQD, @lpWSAData) =  0
*!* Valores
	lnVersion    = StrToInt(Substr(lpWSAData, 1, 2))
	lnMaxSockets = StrToInt(Substr(lpWSAData, 391, 2))
*!* Determinar si Windows Sockets responde
	If gethostname(@lpHostName, 256) <> SOCKET_ERROR
*!* Valores
		lpHostName = Alltrim(lpHostName)
		lnHostEnt_Addr = gethostbyname(lpHostName)
*!* Determinar si Windows Sockets no dio error
		If lnHostEnt_Addr <> 0
*!* Mover bloques de memoria
			RtlMoveMemory(@lpWSHostEnt, lnHostEnt_Addr, 16)
*!* Valores
			lnHostEnt_AddrList = StrToLong(Substr(lpWSHostEnt, 13, 4))
			lnHostEnt_Lenght   = StrToInt(Substr(lpWSHostEnt, 11, 2))
*!* Obtener todas las direcciones IP de la máquina
			Do While .T.
*!* Mover bloques de memoria
				RtlMoveMemory(@lpHostIp_Addr, lnHostEnt_AddrList, 4)
*!* Valores
				lnHostIp_Addr = StrToLong(lpHostIp_Addr)
*!* No hay o no quedan más direcciones validas
				If lnHostIp_Addr = 0
					Exit
				Else
*!* Separar multiples IP`s con comas
					lcRetVal = lcRetVal + Iif(Empty(lcRetVal), '', ',')
				Endif
				lpTempIp_Addr = Replicate(Chr(0), lnHostEnt_Lenght)
*!* Mover bloques de memoria
				RtlMoveMemory(@lpTempIp_Addr, lnHostIp_Addr, lnHostEnt_Lenght)
*!* Componer cadena IP con puntos
				For lnCnt = 1 To lnHostEnt_Lenght
					lcRetVal = lcRetVal + Transform(Asc(Substr(lpTempIp_Addr, lnCnt, 1))) + ;
						iif(lnCnt = lnHostEnt_Lenght, '', '.')
				Endfor
*!* Continuar con la siguiente direccion
				lnHostEnt_AddrList = lnHostEnt_AddrList + 4
			Enddo
		Endif
	Endif
Endif
*!* Parar Windows Sockets
If WSACleanup() <> 0
	lcRetVal = ''
Endif

*!*	Control
*!*	lcRetVal1 = "192.168.1.1,5.74.214.35,4.4.4.4,172.16.1.9"
*!*	lcRetVal1 = "172.16.1.9,192.168.1.1,5.74.214.35,4.4.4.4"
*!*	lcRetVal1 = "192.168.1.1,172.16.1.9,5.74.214.35,4.4.4.4"
*!*	lcRetVal = "172.16.1.9"
*!*	lcRetVal = ''
lcRetVal = Selecciono_Ip(lcRetVal)

*!* Retorno
Return lcRetVal
Endfunc


********************************************************************************
** Libreria de funciones de conversion de tipo                                **
********************************************************************************


*!* Convierte un 4-byte character string a un long integer
*!* Sintaxis: StrToLong(tcLongStr)
*!* Valor devuelto: lnRetval
*!* Argumentos: tcLongStr
*!* tcLongStr especifica el 4-byte character string a convertir
Function StrToLong
Lparameters tcLongStr
Local lnCnt, lnRetVal, lcLongStr
*!* Valores
lnRetVal  = 0
lcLongStr = Iif(Empty(tcLongStr), '', tcLongStr)
*!* Convertir
For lnCnt = 0 To 24 Step 8
	lnRetVal  = lnRetVal + (Asc(lcLongStr) * (2^lnCnt))
	lcLongStr = Right(lcLongStr, Len(lcLongStr) - 1)
Next
*!* Retorno
Return lnRetVal
Endfunc

*!* Convierte un integer a un 2-byte character string
*!* Sintaxis: IntToStr(tnIntVal)
*!* Valor devuelto: lcRetStr
*!* Argumentos: tnIntVal
*!* lnIntVal especifica el integer a convertir
Function IntToStr
Lparameters tnIntVal
Local lnCnt, lcRetStr, lnIntVal
*!* Valores
lcRetStr = ''
lnIntVal = Iif(Empty(tnIntVal), 0, tnIntVal)
*!* Convertir
For lnCnt = 8 To 0 Step -8
	lcRetStr = Chr(Int(lnIntVal/(2^lnCnt))) + lcRetStr
	lnIntVal = Mod(lnIntVal, (2^lnCnt))
Next
*!* Retorno
Return lcRetStr
Endfunc

*!* Convierte un 2-byte character string a un integer
*!* Sintaxis: StrToInt(tcIntStr)
*!* Valor devuelto: lnRetval
*!* Argumentos: tcIntStr
*!* tcIntStr especifica el 2-byte character string a convertir
Function StrToInt
Lparameters tcIntStr
Local lnCnt, lnRetVal, lcIntStr
*!* Valores
lnRetVal = 0
lcIntStr = Iif(Empty(tcIntStr), '', tcIntStr)
*!* Convertir
For lnCnt = 0 To 8 Step 8
	lnRetVal = lnRetVal + (Asc(lcIntStr) * (2^lnCnt))
	lcIntStr = Right(lcIntStr, Len(lcIntStr) - 1)
Next
*!* Retorno
Return lnRetVal
Endfunc

Procedure OpenShell
Parameters pFileName, pAction

Declare Integer ShellExecute In shell32.Dll ;
	integer hndWin, ;
	string cAction, ;
	string cFileName, ;
	string cParams, ;
	string cDir, ;
	integer nShowWin

ShellExecute( 0, pAction, pFileName, "", "", 1 )

Return

Function borraerror()
Lparameters  nerror, mess1
Messagebox("ERROR - " + Str(nerror)+" - " + mess1 ,48,"Aviso")
Endfun


** Procedimientos y rutinas relacionados con Monitores de Impresión/comunicación.
*  -RLV

*** Procedimientos incluidos (para ser llamados desde aplicaciones):
*
*  CargaParam    := Carga en memoria variables ZZ* de configuración general (startup)
*  GetDatVapFile := Carga en cursors el contenido de un file de interfaz de monitor
*  GetFiles      := Carga en cursor los nombres de los files de interfaz de un tipo dado
*
******************************************************************************

*----------------------------------------------------------------------------
Function Selecciono_Ip(lcRetVal)
*----------------------------------------------------------------------------
Local I, lbFin, lcRetVal1

I = 1
lbFin = .F.
lcRetVal1 = lcRetVal

If Substr(lcRetVal1,1,3) = "172"
	lini = At(",",lcRetVal1,1)
	If lini > 0
		lcRetVal = Substr(lcRetVal1,1,lini-1)
	Endif
Else
	Do While .T.
		If At(",",lcRetVal1,I) > 0
			If I = 1
				lcRetVal = Substr(lcRetVal1,1,At(",",lcRetVal1,I)-1)
			Else
				lini = At(",",lcRetVal1,I-1)+1
				lfin = At(",",lcRetVal1,I)
				If lfin = 0
					lcRetVal = Substr(lcRetVal1,lini)
				Else
					lcRetVal = Substr(lcRetVal1,lini,lfin-lini)
				Endif
			Endif
		Else
			If I <> 1
				lcRetVal = Substr(lcRetVal1,At(",",lcRetVal1,I-1)+1)
			Endif
			lbFin = .T.
		Endif
		I = I + 1
		If Substr(lcRetVal,1,3) = "172"
			Exit
		Else
			If lbFin
				lcRetVal = lcRetVal1
				Exit
			Endif
		Endif
	Enddo
Endif

Return lcRetVal

Function ValidarCuentaEmail
Lparameters email && la cuenta
loRegExp = Createobject("VBScript.RegExp")
loRegExp.IgnoreCase = .T.
loRegExp.Pattern =  '^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)­*)\.([A-Za-z]{2,})$'
m.valid = loRegExp.Test(m.email)
Release loRegExp
Return M.valid
Endfunc

