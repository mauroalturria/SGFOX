****
**  Seteos del sistema
****
Public mcon1, midusu, mpassw, mcon1, myip, mcon3,mxambito 
mxambito = 1

Set ansi on
Set bell off
Set cent on
Set compatible off
Set conf on
Set date to french
Set decimal to 2
Set dele on
Set exact on
Set exclu off
Set fdow to 1
Set hours to 24
Set near on
Set notify off
Set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep, ;
	xfrx,xfrx\xfrxlib,xfrx\gdip,xfrx\localization,;
	xfrx\nogdip,xfrx\prevdemo
Set optimize on
Set point to ","
Set safety off
Set separator to "."
Set status off
Set status bar off
Set talk off
Set sysmenu off
Set ENGINEBEHAVIOR 70
Do seteos_ip
myip = IPAddress()

mresplog = 0
Do sp_busco_server_namespaces
Do sp_conexion With "MAIL_TIME"

Do form frmplan17


Do sp_desconexion


