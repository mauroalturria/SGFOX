**
* Sistema : Sanatorio Güemes
* Módulo  : Suministros ( Seteos del Sistema )
* Fecha   : 14/08/2012
* Observ. : Hereda del Proyecto Farmacia
****

Public mcon1, mcon1, mcon4, midusu,mconc,myip,miform,mxambito ,mxcentromedico 
mxcentromedico =1
mxambito  = 1

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
Set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
Set optimize on
Set point to "."
Set safety off
*Set separator to "."
Set status off
Set status bar off
Set talk off
Set sysmenu off

Do seteos_ip
myip = IPAddress()
SET ENGINEBEHAVIOR 70
_screen.Icon = "DESKSTUF.ico"

dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
If !file(dirfonts)
	*Copy file Pf_i2of5.ttf to &dirfonts
Endif

Public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, msel_datos(25,4),det_fac(40,8)
Dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)

Create cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc n(13), tipdoc n(2), domici c(50), tel c(20), ;
	cpostal n(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

mresplog = 0

_Screen.WindowState = 2

Modify windows screen;
	title "SUMINISTROS"
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify windows screen;
	fill file &cfondo

Do form frmloguin1 with 'SUMINISTROS'

If mresplog = 0
	Do sp_busco_server_namespaces
	On error =aerr(eros)
	mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
*	mfile = justpath(SYS(16,0))+"c:\desaguemes\exe\inicio\ini.txt"
	mcadcon = filetostr(mfile)
	On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	If type('mcadcon') = "C"
		mDatabase = mline(mcadcon,3)
		mDatabase = alltrim(substr(mDatabase,at("=",mDatabase)+1))
		If !empty('mDatabase')
			Select mwktabcfg
			Replace olespaces with mDatabase
		Endif
	Endif

	Do sp_conexion

	If !directory("C:\temp\informes")
		Mkdir "C:\temp\informes"
	Endif
	If !directory("C:\temp\imagenes")
		Mkdir "C:\temp\imagenes"
	Endif

	Do suministrosmenu.mpr
	Read events
	Do sp_desconexion

Endif

* Por No definiciones documentadas en el arch. ERR, al compilar
Procedure Lmenu
Return

Procedure pdatos
Return
