****
**  Seteos del sistema
****

public mcon1, mcon1, mcon4, midusu,mconc,myip,miform,mxambito
mxambito= 1
public mflag, mvuelvo, mregistracio, mform, msql1, mcodent, ;
	msql_reg, msql_pre, mdesc, manos, mmeses, mdias

set ansi on
set bell off
set cent on
set compatible off
set conf on
set date to french
set decimal to 2
set dele on
set exact on
set exclu off
set fdow to 1
set hours to 24
set near on
set notify off
set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off

do seteos_ip
myip = IPAddress()

SET ENGINEBEHAVIOR 70

public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(200), mversion, msel_datos(20,4),dat_cose(13)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(200), msel_datos(20,4),dat_cose(13)

mresplog = 0
do sp_busco_server_namespaces
*do sp_conexion With "TAREAS_TURNOS"
if !used('mwkexe')
	create cursor mwkexe (nomexe c(20),versionactual c(20), launcher c(50),versionminima c(20),idexe n (2))
	insert into mwkexe values ("TAREASTURNOS","1.0.0","\\172.16.5.46//C://mail_turnos.exe","1.0.0",23)
endif

mresplog = 0
*	do sp_control_program with 0
*		do form frmverip

	DO turnodoblepoli
	cancel	
#DEFINE WS_VERSION_REQD        257
#DEFINE WS_VERSION_MAJOR    1
#DEFINE WS_VERSION_MINOR    1
#DEFINE MIN_SOCKETS_REQD    1
#DEFINE SOCKET_ERROR        -1
#DEFINE WSADESCRIPTION_LEN     256
#DEFINE WSASYS_STATUS_LEN     128

*!* Windows NetBIOS
#DEFINE NCBENUM                     55
#DEFINE NCBASTAT                    51
#DEFINE NCBNAMSZ                    16
#DEFINE HEAP_ZERO_MEMORY            8
#DEFINE HEAP_GENERATE_EXCEPTIONS    4
#DEFINE NCBRESET                    50

*!* Devuelve las direcciones IP
*!* Sintaxis: IPAddress()
*!* Valor devuelto: lcRetVal
*!* lcRetVal viene expresado como una cadena con el formato: 192.100.100.100, 192.100.100.101, ...
FUNCTION IPAddress
  LOCAL lnCnt, lpWSAData, lpWSHostEnt, lpHostName, lcRetVal, lpHostIp_Addr, ;
    lpHostEnt_Addr, lnHostEnt_Lenght, lnHostEnt_AddrList
  *!* Instrucciones DECLARE DLL para manipular Windows Sockets
  DECLARE INTEGER WSAGetLastError IN WSock32.DLL
  DECLARE INTEGER WSAStartup IN WSock32.DLL INTEGER wVersionRequested , STRING @lpWSAData
  DECLARE INTEGER WSACleanup IN WSock32.DLL
  DECLARE INTEGER gethostname IN WSock32.DLL STRING @lpHostName, INTEGER iHostNameLenght
  DECLARE INTEGER gethostbyname IN WSock32.DLL STRING lpHostName
  DECLARE RtlMoveMemory IN Win32API STRING @lpDest, INTEGER nSource, INTEGER nBytes
  *!* Valores
  lcRetVal           = ''
  lpHostName         = SPACE(256)
  lnHostEnt_Addr     = 0
  lnHostEnt_Lenght   = 0
  lnHostEnt_AddrList = 0
  lnHostIp_Addr      = 0
  lpTempIp_Addr      = CHR(0)
  lpHostIp_Addr      = REPLICATE(CHR(0), 4)
  lpWSHostEnt        = REPLICATE(CHR(0), 4 +4 +2 +2 +4)
  lpWSAData          = REPLICATE(CHR(0), 2 +2 + ;
    WSADESCRIPTION_LEN +1 +WSASYS_STATUS_LEN +1 +2 +2 +4)
  *!* Iniciar Windows Sockets
  IF WSAStartup(WS_VERSION_REQD, @lpWSAData) =  0
    *!* Valores
    lnVersion    = StrToInt(SUBSTR(lpWSAData, 1, 2))
    lnMaxSockets = StrToInt(SUBSTR(lpWSAData, 391, 2))
    *!* Determinar si Windows Sockets responde
    IF gethostname(@lpHostName, 256) <> SOCKET_ERROR
      *!* Valores
      lpHostName = ALLTRIM(lpHostName)
      lnHostEnt_Addr = gethostbyname(lpHostName)
      *!* Determinar si Windows Sockets no dio error
      IF lnHostEnt_Addr <> 0
        *!* Mover bloques de memoria
        RtlMoveMemory(@lpWSHostEnt, lnHostEnt_Addr, 16)
        *!* Valores
        lnHostEnt_AddrList = StrToLong(SUBSTR(lpWSHostEnt, 13, 4))
        lnHostEnt_Lenght   = StrToInt(SUBSTR(lpWSHostEnt, 11, 2))
        *!* Obtener todas las direcciones IP de la máquina
        DO WHILE .T.
          *!* Mover bloques de memoria
          RtlMoveMemory(@lpHostIp_Addr, lnHostEnt_AddrList, 4)
          *!* Valores
          lnHostIp_Addr = StrToLong(lpHostIp_Addr)
          *!* No hay o no quedan más direcciones validas
          IF lnHostIp_Addr = 0
            EXIT
          ELSE
            *!* Separar multiples IP`s con comas
            lcRetVal = lcRetVal + IIF(EMPTY(lcRetVal), '', ',')
          ENDIF
          lpTempIp_Addr = REPLICATE(CHR(0), lnHostEnt_Lenght)
          *!* Mover bloques de memoria
          RtlMoveMemory(@lpTempIp_Addr, lnHostIp_Addr, lnHostEnt_Lenght)
          *!* Componer cadena IP con puntos
          FOR lnCnt = 1 TO lnHostEnt_Lenght
            lcRetVal = lcRetVal + TRANSFORM(ASC(SUBSTR(lpTempIp_Addr, lnCnt, 1))) + ;
              IIF(lnCnt = lnHostEnt_Lenght, '', '.')
          ENDFOR
          *!* Continuar con la siguiente direccion
          lnHostEnt_AddrList = lnHostEnt_AddrList + 4
        ENDDO
      ENDIF
    ENDIF
  ENDIF
  *!* Parar Windows Sockets
  IF WSACleanup() <> 0
    lcRetVal = ''
  ENDIF
  *!* Retorno
  RETURN lcRetVal
ENDFUNC


********************************************************************************
** Libreria de funciones de conversion de tipo                                **
********************************************************************************


*!* Convierte un 4-byte character string a un long integer
*!* Sintaxis: StrToLong(tcLongStr)
*!* Valor devuelto: lnRetval
*!* Argumentos: tcLongStr
*!* tcLongStr especifica el 4-byte character string a convertir
FUNCTION StrToLong
  LPARAMETERS tcLongStr
  LOCAL lnCnt, lnRetVal, lcLongStr
  *!* Valores
  lnRetVal  = 0
  lcLongStr = IIF(EMPTY(tcLongStr), '', tcLongStr)
  *!* Convertir
  FOR lnCnt = 0 TO 24 STEP 8
    lnRetVal  = lnRetVal + (ASC(lcLongStr) * (2^lnCnt))
    lcLongStr = RIGHT(lcLongStr, LEN(lcLongStr) - 1)
  NEXT
  *!* Retorno
  RETURN lnRetVal
ENDFUNC

*!* Convierte un integer a un 2-byte character string
*!* Sintaxis: IntToStr(tnIntVal)
*!* Valor devuelto: lcRetStr
*!* Argumentos: tnIntVal
*!* lnIntVal especifica el integer a convertir
FUNCTION IntToStr
  LPARAMETERS tnIntVal
  LOCAL lnCnt, lcRetStr, lnIntVal
  *!* Valores
  lcRetStr = ''
  lnIntVal = IIF(EMPTY(tnIntVal), 0, tnIntVal)
  *!* Convertir
  FOR lnCnt = 8 TO 0 STEP -8
    lcRetStr = CHR(INT(lnIntVal/(2^lnCnt))) + lcRetStr
    lnIntVal = MOD(lnIntVal, (2^lnCnt))
  NEXT
  *!* Retorno
  RETURN lcRetStr
ENDFUNC

*!* Convierte un 2-byte character string a un integer
*!* Sintaxis: StrToInt(tcIntStr)
*!* Valor devuelto: lnRetval
*!* Argumentos: tcIntStr
*!* tcIntStr especifica el 2-byte character string a convertir
FUNCTION StrToInt
  LPARAMETERS tcIntStr
  LOCAL lnCnt, lnRetVal, lcIntStr
  *!* Valores
  lnRetVal = 0
  lcIntStr = IIF(EMPTY(tcIntStr), '', tcIntStr)
  *!* Convertir
  FOR lnCnt = 0 TO 8 STEP 8
    lnRetVal = lnRetVal + (ASC(lcIntStr) * (2^lnCnt))
    lcIntStr = RIGHT(lcIntStr, LEN(lcIntStr) - 1)
  NEXT
  *!* Retorno
  RETURN lnRetVal
ENDFUNC
