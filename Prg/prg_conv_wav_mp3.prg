Parameters lcWav, lcMp3
* Ejemplo:

If !File("c:\Qepd1a1\Exe\lame.exe")
	If !File("x:\Qepd1a1\Exe\lame.exe")
		Return .F.
	Endif 
	Copy File ("x:\Qepd1a1\Exe\lame.exe") To ("c:\Qepd1a1\Exe\lame.exe")
Endif 

If !File("c:\Qepd1a1\Exe\lame_enc.dll")
	If !File("x:\Qepd1a1\Exe\lame_enc.dll")
		Return .F.
	Endif 
	Copy File ("x:\Qepd1a1\Exe\lame_enc.dll") To ("c:\Qepd1a1\Exe\lame_enc.dll")
Endif 

ShellWait("c:\Qepd1a1\Exe\lame.exe", " -V2 " + lcWav + " " + lcMp3 )
*ShellWait("c:\desaguemes\Scx\c\lame.EXE", " -V2 c:\desaguemes\Scx\c\182322.Wav c:\desaguemes\Scx\c\182322_1.mp3")

* Notar el espacio al comienzo del parametro

* defines
#DEFINE STARTF_USESHOWWINDOW    1
#DEFINE SW_SHOWMAXIMIZED        0

#DEFINE m0                    256
#DEFINE m1                  65536
#DEFINE m2               16777216

***
* Function ShellWait
***
FUNCTION ShellWait(cEXEFile, cCommandLine)
  LOCAL cStartupInfo, cProcInfo, nProcess

  * Declare WinAPI Functions
  DECLARE INTEGER CreateProcess IN kernel32 ;
    STRING lpApplicationName, ;
    STRING lpCommandLine, ;
    INTEGER lpProcessAttributes, ;
    INTEGER lpThreadAttributes, ;
    INTEGER bInheritHandles, ;
    INTEGER dwCreationFlags, ;
    INTEGER @lpEnvironment, ;
    STRING lpCurrentDirectory, ;
    STRING lpStartupInfo, ;
    STRING @lpProcessInformation

  DECLARE INTEGER WaitForSingleObject IN kernel32 ;
    INTEGER hHandle,;
    INTEGER dwMilliseconds

  DECLARE INTEGER CloseHandle IN kernel32 ;
    INTEGER hObject

  DECLARE INTEGER GetLastError IN kernel32


  * Incializar estructuras
  cStartupInfo = num2dword(68) + ;
    num2dword(0) + num2dword(0) + num2dword(0) + ;
    num2dword(0) + num2dword(0) + num2dword(0) + num2dword(0) + ;
    num2dword(0) + num2dword(0) + num2dword(0) + ;
    num2dword(STARTF_USESHOWWINDOW) + ;
    num2word(SW_SHOWMAXIMIZED) + ;
    num2word(0) + num2dword(0) + ;
    num2dword(0) + num2dword(0) + num2dword(0)

  cProcInfo = REPLICATE(CHR(0), 16)

  * Ejecutar comando
  IF CreateProcess(cEXEFile, cCommandLine, 0, 0, 1, 32, 0, SYS(2003), ;
cStartupInfo, @cProcInfo) == 0

    * Posibles errores
    *  2 = The system cannot find the file specified
    *  3 = The system cannot find the path specified
    * 87 = ERROR_INVALID_PARAMETER
    MESSAGEBOX("Error número: " + LTRIM(STR(GetLastError())), 64, "Error")

  ELSE
    * Esperar a que termine
    nProcess = buf2dword(SUBSTR(cProcInfo, 1, 4))
    WaitForSingleObject(nProcess, -1)
    CloseHandle(nProcess)
  ENDIF
ENDFUNC

***
* Function num2dword
***
FUNCTION num2dword(nValue)
  LOCAL b0, b1, b2, b3

  b3 = INT(nValue/m2)
  b2 = INT((nValue - b3 * m2)/m1)
  b1 = INT((nValue - b3*m2 - b2*m1)/m0)
  b0 = MOD(nValue, m0)
  RETURN(CHR(b0) + CHR(b1) + CHR(b2) + CHR(b3))
ENDFUNC

***
* Function num2word
***
FUNCTION num2word(nValue)
  RETURN(CHR(MOD(nValue, 256)) + CHR(INT(nValue / 256)))
ENDFUNC

***
* Function buf2dword
***
FUNCTION buf2dword(cBuffer)
  RETURN(ASC(SUBSTR(cBuffer, 1, 1)) + ;
    ASC(SUBSTR(cBuffer, 2, 1)) * 256 + ;
    ASC(SUBSTR(cBuffer, 3, 1)) * 65536 + ;
    ASC(SUBSTR(cBuffer, 4, 1)) * 16777216)
ENDFUNC
