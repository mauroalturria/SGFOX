*
* FTP - Upload - parámetros
*
* mlcSourcePath = [ Directorio local ]
* mlcTargetPath = [ Directorio de ftp destino ]
* mlnFiles      = [ Tipo de archivo a procesar *.txt, *.*, etc. ]
* mhost         = [ IP ]
* muser         = [ Usuario ]
* mpassw        = [ Contraseña ]
*
* ( No usar un acceso anónimo. )

Lparameters mlcTargetPath, mlcSourcePath, mlnFiles, mhost, muser, mpassw

#Define GENERIC_READ    2147483648   && &H80000000
#Define GENERIC_WRITE   1073741824   && &H40000000

Public hOpen, hFtpSession
Declare INTEGER InternetOpen IN wininet.dll;
	STRING  sAgent,;
	INTEGER lAccessType,;
	STRING  sProxyName,;
	STRING  sProxyBypass,;
	STRING  lFlags

Declare INTEGER InternetCloseHandle IN wininet.dll;
	INTEGER hInet

Declare INTEGER InternetConnect IN wininet.dll;
	INTEGER hInternetSession,;
	STRING  sServerName,;
	INTEGER nServerPort,;
	STRING  sUsername,;
	STRING  sPassword,;
	INTEGER lService,;
	INTEGER lFlags,;
	INTEGER lContext

Declare INTEGER FtpOpenFile IN wininet.dll;
	INTEGER hFtpSession,;
	STRING  sFileName,;
	INTEGER lAccess,;
	INTEGER lFlags,;
	INTEGER lContext

Declare INTEGER InternetWriteFile IN wininet.dll;
	INTEGER   hFile,;
	STRING  @ sBuffer,;
	INTEGER   lNumBytesToWrite,;
	INTEGER @ dwNumberOfBytesWritten

****

*mhost  = "200.5.235.233"
*muser  = "Upload"
*mpassw = "&$Upload"

* ok prueba * lcSourcePath = "C:\Temp\Web\"   && Directorio local *lcTargetPath = "/www.sanatoriog.com/adjuntos/28/importacion/"     && directorio de ftp destino
* ok prueba * lnFiles      = ADIR (arr, lcSourcePath + "*.txt")
* ok prueba * lcTargetPath = "adjuntos/28/importacion/"     && directorio de ftp destino

lcSourcePath = mlcSourcePath
lnFiles      = ADIR (arr, lcSourcePath + mlnFiles)
lcTargetPath = mlcTargetPath

mdesde = 1

*connect2ftp ("200.5.235.233", "Upload", "&$Upload")

If connect2ftp (mhost, muser, mpassw)
	For lnCnt = mdesde TO lnFiles
		lcSource = lcSourcePath + LOWER (arr [lnCnt, 1])
		lcTarget = lcTargetPath + LOWER (arr [lnCnt, 1])
		mreinten = 1
		msigo    = .t.
		Do while msigo
			Wait "Copiando archivo "+lcSource+" a "+lcTarget + " intento "+alltrim(str(mreinten)) Windows Nowait
			mretcopy = local2ftp(hFtpSession, lcSource, lcTarget)
			If mretcopy < 0
				mreinten = mreinten + 1
				= InternetCloseHandle (hFtpSession)
				= InternetCloseHandle (hOpen)
				If connect2ftp (mhost, muser, mpassw)
					If mreinten = 4
						msigo = .f.
					Endif
					Loop
				Else
					Messagebox("No puede establecerse conexion para FTP",48,"Validación")
				Endif
			Endif
			msigo = .f.
		Enddo
	Endfor
	= InternetCloseHandle (hFtpSession)
	= InternetCloseHandle (hOpen)
Else
	Messagebox("No puede establecerse conexion para FTP",48,"Validación")
Endif

*!* Messagebox("FIN")

**--------------------------------------------
** Establecemos la conexión
**--------------------------------------------
Function  connect2ftp (strHost, strUser, strPwd)

*!* Abrimos el acceso.
hOpen = InternetOpen ("vfp", 1, 0, 0, 0)

If hOpen = 0
	Messagebox("No tiene acceso a WinInet.Dll",48,"Validación")
	Return .F.
Endif

*!* Conectando al FTP.
hFtpSession = InternetConnect (hOpen, strHost, 0, strUser, strPwd, 1, GENERIC_READ, 0)

If hFtpSession = 0
*!* Cerrando acceso y saliendo.
	= InternetCloseHandle (hOpen)
	Messagebox("FTP " + strHost + " no está disponible",48,"Validación")
	Return .F.
*!* Else
*!*	? "Conectado a " + strHost + " como: [" + strUser + ", *****]"
Endif

Return .T.


*******
*!*	'Declaraciones
*!*	Private Declare Function InternetConnect Lib "wininet.dll" Alias "InternetConnectA" (ByVal hInternetSession As Long, ByVal sServerName As String, ByVal nServerPort As Integer, ByVal sUserName As String, ByVal sPassword As String, ByVal lService As Long, ByVal lFlags As Long, ByVal lContext As Long) As Long
*!*	Private Declare Function InternetOpen Lib "wininet.dll" Alias "InternetOpenA" (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, ByVal sProxyBypass As String, ByVal lFlags As Long) As Long
*!*	Private Declare Function FtpPutFile Lib "wininet.dll" Alias "FtpPutFileA" (ByVal hConnect As Long, ByVal lpszLocalFile As String, ByVal lpszNewRemoteFile As String, ByVal dwFlags As Long, ByVal dwContext As Long) As Boolean
*!*	Private Declare Function InternetCloseHandle Lib "wininet.dll" (ByVal hInet As Long) As Integer
*!*	Private Declare Function FtpSetCurrentDirectory Lib "wininet.dll" Alias "FtpSetCurrentDirectoryA" (ByVal hFtpSession As Long, ByVal lpszDirectory As String) As Boolean
*!*	Const INTERNET_OPEN_TYPE_PRECONFIG = 0
*!*	Const INTERNET_DEFAULT_FTP_PORT = 21
*!*	Const INTERNET_SERVICE_FTP = 1
*!*	Const PassiveConnection As Boolean = True
*!*	Const INTERNET_FLAG_PASSIVE = &H8000000
*!*	Const FTP_TRANSFER_TYPE_UNKNOWN = &H0

*!*	Dim hConnection, hOpen, Num As Long

*!*	'Subir el archivo a un ftp

*!*	hOpen = InternetOpen("IE", INTERNET_OPEN_TYPE_PRECONFIG, vbNullString, vbNullString, 0)
*!*	DoEvents

*!*	hConnection = InternetConnect(hOpen, "ftp.webcindario.com", INTERNET_DEFAULT_FTP_PORT, "usuario",
*"password", INTERNET_SERVICE_FTP, IIf(PassiveConnection, INTERNET_FLAG_PASSIVE, 0), 0)

*!*	DoEvents
*!*	FtpSetCurrentDirectory hConnection, "\"
*!*	DoEvents
*!*	FtpPutFile hConnection, "C:\ruta_local.txt", "nombre_remoto.txt", FTP_TRANSFER_TYPE_UNKNOWN, 0
*!*	DoEvents
*!*	InternetCloseHandle hConnection
*!*	InternetCloseHandle hOpen
*!*	*******

**--------------------------------------------
** Copia del/los archivos
**--------------------------------------------
Function local2ftp (hConnect, lcSource, lcTarget)

*!* Copiando el archivo local al directorio remoto ftp.
hSource = FOPEN (lcSource)
If (hSource = -1)
	Return -1
Endif

*!* Creamos el nuevo archivo
hTarget = FtpOpenFile(hConnect, lcTarget, GENERIC_WRITE, 2, 0)
If hTarget = 0
	= FCLOSE (hSource)
	Return -2
Endif
lnBytesWritten = 0
lnChunkSize    = 512    && 128, 256
Do WHILE Not FEOF(hSource)
	lcBuffer = FREAD (hSource, lnChunkSize)
	lnLength = Len(lcBuffer)
	If lnLength > 0
		If InternetWriteFile (hTarget, @lcBuffer, lnLength, @lnLength) = 1
			lnBytesWritten = lnBytesWritten + lnLength
*!*          Podemos mostrar aquí el progreso de la operación
		Else
			Exit
		Endif
	Else
		Exit
	Endif
Enddo
= InternetCloseHandle (hTarget)
= FCLOSE (hSource)
Return lnBytesWritten
