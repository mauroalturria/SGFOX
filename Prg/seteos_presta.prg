**  Seteos del sistema

Public mcon1, midusu, mpassw, mcodvax, mcon1, mresplog,myip,mxambito
mxambito = 1
SET ENGINEBEHAVIOR 70

Public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)
Dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)
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
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep, Vrs
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Talk Off
Set Sysmenu Off
Set Escape Off

Do seteos_ip
myip = IPAddress()


mresplog = 0
_Screen.WindowState = 2
Modify Windows Screen ;
	title "Prestadores"
cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify Windows Screen;
	fill File &cfondo

Do Form frmloguin1 With 'PRESTADORES'

* mresplog = 1

If mresplog = 0
	Do sp_busco_server_namespaces
	On Error =Aerr(eros)
	mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
	mcadcon = Filetostr(mfile)
	On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	If Type('mcadcon') = "C"
		mDatabase 	= Mline(mcadcon,3)
		mDatabase 	=Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
		If !Empty('mDatabase')
			Select mwktabcfg
			Replace olespaces With mDatabase
		Endif
	Endif

	Do seteos_configuracion
	Do registroocx
	Do prestamenu.mpr
	Read Events
Endif

Procedure LMENU
Return
