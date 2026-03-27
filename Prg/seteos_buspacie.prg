*!*	Set Deleted On
*!*	Set Date FRENCH
Set Enginebehavior 70



Public mcon1, myIp, mxambito
myIp = ""
mxambito = 1

SQLSETPROP(0,"DispLogin",3)
*!*	mcon1 = Sqlconnect("Conec04")
lcStringConn = "Driver={InterSystems ODBC};PORT=1972;SERVER=172.16.1.4;DATABASE=CATALOGO;Uid=_SYSTEM;Pwd=SYS"

mcon1 = Sqlstringconnect(lcStringConn)

If mcon1 <= 0
	Messagebox("ERROR AL CONECTAR CON EL SERVIDOR",48,"VALIDACION")
	Return .f.
Endif 

Do Form frmbuspacie
*Read Events
 
Sqldisconnect(mcon1)
*!*	----------------------------------------------------------------
Procedure AFINDHWND
Return

Procedure LMENU
Return
  
Procedure DAT_VALE 
Procedure ITEM_VALE 
Procedure DAT_WS
Procedure DAT_FAC
Procedure DET_FAC
Procedure VEC_VALE 

  