*** 
*** ReFox X  #UK933629  MANRIQUE ORELLANA  MANSOFT SYSTEMS [VFP60]
***
PUBLIC mcon1, midusu, mpassw, mcodvax, mcon1, mresplog, myip, miform, mintcall, mxambito
mxambito = 1
CLEAR
SET ANSI ON
SET BELL OFF
SET CENTURY ON
SET COMPATIBLE OFF
SET CONFIRM ON
SET DATE TO french
SET DECIMALS TO 2
SET DELETED ON
SET EXACT ON
SET EXCLUSIVE OFF
SET FDOW TO 1
SET HOURS TO 24
SET NEAR ON
SET NOTIFY OFF
SET PATH TO scx, lib, mnu, prg, exe, bmp, rep
SET OPTIMIZE ON
SET POINT TO ","
SET SAFETY OFF
SET SEPARATOR TO "."
SET STATUS OFF
SET STATUS BAR OFF
SET TALK OFF
SET SYSMENU OFF
_SCREEN.keypreview = .T.
*_SCREEN.visible = .F.
DO seteos_ip
myip = ipaddress()
mserver = "172.16.1.225"
mdatabase = "CATALOGO"
mport = "1972"
SQLSETPROP(0, "DispLogin", 3)
lcstringconn = "Driver={InterSystems ODBC};PORT=1972;SERVER=" + mserver + ";DATABASE=" + mdatabase +  ;
               ";Uid=_SYSTEM;Pwd=SYS"
mcon1 = SQLSTRINGCONNECT(lcstringconn)
IF mcon1 <= 0
     lcstringconn = "Driver={InterSystems ODBC35};PORT=1972;SERVER=" + mserver + ";DATABASE=" + mdatabase +  ;
                    ";Uid=_SYSTEM;Pwd=SYS"
     mcon1 = SQLSTRINGCONNECT(lcstringconn)
ENDIF
DO FORM frmantecedentes.scx && antec_prueba
READ EVENTS
ENDPROC
**
PROCEDURE DAT_VALE
**
** ReFox - this procedure is empty **
**
ENDPROC
**
PROCEDURE ITEM_VALE
**
** ReFox - this procedure is empty **
**
ENDPROC
**
PROCEDURE DAT_COSE
**
** ReFox - this procedure is empty **
**
ENDPROC
**
PROCEDURE VEC_VALE
**
** ReFox - this procedure is empty **
**
ENDPROC
**
PROCEDURE DAT_FAC
**
** ReFox - this procedure is empty **
**
ENDPROC
**
PROCEDURE ITEM_COSE
**
** ReFox - this procedure is empty **
**
ENDPROC
**
PROCEDURE AFINDHWND
**
** ReFox - this procedure is empty **
**
ENDPROC
**
PROCEDURE LMENU
**
** ReFox - this procedure is empty **
**
ENDPROC
**
PROCEDURE MF2
**
** ReFox - this procedure is empty **
**
ENDPROC
**
*** 
*** ReFox - retrace your steps ... 
***
