****
**  Seteos del sistema - AlfaBeta
****

Public mcon1, mcon1, mcon4, midusu,myip,miform,mxambito,mxcentromedico 
mxambito = 1
mxcentromedico  = 1

Public mflag, mvuelvo, mregistracio, mform, msql1, mcodent, ;
	msql_reg, msql, msql_pre, mdesc, manos, mmeses, mdias


Public mtfhoy,vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(25,4),;
	det_fac(40,8),xusuariologin,dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)

Dime vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(25,4),;
	det_fac(40,8),dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)


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
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Message To 
Set Talk Off
Set Sysmenu Off

Set Enginebehavior 70

_Screen.Themes = .F.
_Screen.Icon = 'AB_2.ico'

Do seteos_ip
myip = IPAddress()

*!*	----------------------------------------------------------------
dirfonts = Alltrim(Getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
If !File(dirfonts)
**	Copy File Pf_i2of5.ttf To &dirfonts
Endif

*!*	----------------------------------------------------------------
_Screen.WindowState = 2

cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify Windows Screen ;
	title "ALFABETA" ;
	fill File &cfondo
*!*	----------------------------------------------------------------


mresplog = 0
Do Form frmloguin1 With 'ALFABETA'

If mresplog = 0

	Do sp_busco_server_namespaces

	mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
	If File(mfile)
		mcadcon = Filetostr(mfile)
	Endif 	

	If Type('mcadcon') = "C"
		mDatabase 	= Mline(mcadcon,3)
		mDatabase 	= Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
		If !Empty('mDatabase')
			Select mwktabcfg
			Replace olespaces With mDatabase
		Endif
	Endif

	If prg_modo_exe()
*		On Shutdown do prg_salir
		Do alfabetamenu.mpr
		Read Events
	Endif 	

Endif
*!*	----------------------------------------------------------------
Procedure AFINDHWND
Return

Procedure LMENU
Return