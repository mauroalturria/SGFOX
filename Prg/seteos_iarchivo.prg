****
**  Seteos del sistema
****

Public mcon1, mcon1, mcon4, midusu,myip,mxambito,mxcentromedico

mxcentromedico = 1
mxambito = 1


Public mflag, mvuelvo, mregistracio, mform, msql1, mcodent, ;
	msql_reg, msql, msql_pre, mdesc, manos, mmeses, mdias
Public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, msel_datos(25,4),det_fac(40,8)
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
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Talk Off
Set Sysmenu Off
Do seteos_ip
myip = IPAddress()

mresplog = 0

_Screen.WindowState = 2

_Screen.KeyPreview = .T.
Set ENGINEBEHAVIOR 70

_Screen.Themes = .F.
_Screen.Icon = 'files04.ico'
Modify Windows Screen;
	title "ARCHIVO"

cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")

Modify Windows Screen;
	fill File &cfondo

*!*	if file ("\qepd1a1\solo_marca.jpg")
*!*		modify windows screen;
*!*	  		fill file "\qepd1a1\solo_marca.jpg"
*!*	endif

Do Form frmloguin1 With 'ARCHIVOINTER'

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

	If !Used("mwkserver1")
		Do sp_conexion
	Endif

	Do archivoimenu.mpr
	Read Events
Endif

Procedure LMENU
Return
