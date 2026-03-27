**
* Sistema : Sanatorio Güemes
* Módulo  : CIAM ( Seteos del Sistema )
* Fecha   : 21-02-2008
* Observ. : Hereda del Proyecto FARMACIA
****

Public mcon1,mcon1,mcon4,midusu,mconc,myip,miform,mxambito ,mxcentromedico 
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
set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Talk Off
Set Sysmenu Off

Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep, ;
	xfrx,xfrx\xfrxlib,xfrx\GDIP,xfrx\localization,;
	xfrx\nogdip,xfrx\prevdemo

Set ENGINEBEHAVIOR 70

Do seteos_ip
myip = IPAddress()

Do seteos_public

dirfonts = Alltrim(Getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
If !File(dirfonts)
	*Copy File Pf_i2of5.ttf To &dirfonts
Endif

Public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, ;
	msel_datos(25,4),det_fac(40,8),dat_busca(40,8),dat_ws(30)

Dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4);
	,det_fac(40,8),dat_busca(40,8),dat_ws(30)

Create Cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc N(13), tipdoc N(2), domici c(50), tel c(20), ;
	cpostal N(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

mresplog = 0

_Screen.WindowState = 2

_Screen.Closable  = .F.
_Screen.MaxButton = .F.

Modify Windows Screen;
	title "Ciam"
	
* cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
* Modify Windows Screen fill File &cfondo

Do Form frmloguin1 With 'CIAM'

If mresplog = 0
	Do sp_busco_server_namespaces
	On Error =Aerr(eros)
	mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
	mcadcon = Filetostr(mfile)
	On Error
	If Type('mcadcon') = "C"
		mDatabase 	= Mline(mcadcon,3)
		mDatabase 	=Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
		If !Empty('mDatabase')
			Select mwktabcfg
			Replace olespaces With mDatabase
		Endif
	Endif
	do seteos_configuracion

*	do sp_conexion

	Do ciammenu2.mpr
	Read Events

Endif

* Por No definiciones documentadas en el arch. ERR, al compilar
Procedure Lmenu
Return

Procedure pdatos
Return

Procedure Dat_Vale1
Return

Procedure Item_Vale1
Return

Procedure vvdatos
Return

Procedure AFINDHWND
Return
