****
**  Seteos del sistema
****
Public mcon1, midusu, mpassw, mcon1, myip, mcon3,mxambito,mxcentromedico 
mxcentromedico =1

mxambito = 1

Set Ansi On
Set Bell Off
Set Cent On
Set Compatible Off
Set Conf On
Set Date To French
Set Decimal To 2
Set Dele On
Set Exact On
Set Exclu Off
Set Fdow To 1
Set Hours To 24
Set Near On
Set Notify Off
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep, xfrx,xfrx\xfrxlib,xfrx\GDIP,xfrx\localization, xfrx\nogdip,xfrx\prevdemo
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Talk Off
Set Sysmenu Off
Set ENGINEBEHAVIOR 70

Do seteos_ip
myip = IPAddress()

mresplog = 0
	Do sp_busco_server_namespaces
	On Error =Aerr(eros)
	mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"

*   mfile = "c:\desaguemes\Exe\Inicio\ini.txt"

	mcadcon = Filetostr(mfile)
	On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	If Type('mcadcon') = "C"
		mDatabase = Mline(mcadcon,3)
		mDatabase = Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
		If !Empty('mDatabase')
			Select mwktabcfg
			Replace olespaces With mDatabase
		Endif
	Endif
Do sp_busco_server_namespaces
Do sp_conexion With "AGENDA_QUIRO"

Do Form frmquirof30
* READ EVENTS
 
Do sp_desconexion


