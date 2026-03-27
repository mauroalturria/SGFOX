**
* Sistema : Sanatorio Güemes
* Módulo  : Megatlon ( Seteos del Sistema )
* Fecha   : 11/2018
****

Public mcon1, mcon1, mcon4, midusu, mconc, myip, miform, mxambito

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

dirfonts = Alltrim(Getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
If !File(dirfonts)
	*copy file Pf_i2of5.ttf To &dirfonts
Endif

Public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, msel_datos(25,4),det_fac(40,8)
Dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)

Create Cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc N(13), tipdoc N(2), domici c(50), tel c(20), ;
	cpostal N(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

mresplog = 0

_Screen.WindowState = 2

Modify Windows Screen;
	title " MEGATLON"
cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify Windows Screen;
	fill File &cfondo
_Screen.Icon = 'megatlon.ico'

* VER NOMBRE *
**Do Form frmloguin1 With 'INCIDENTES'

If !Used("mwkserver1")
	lDisconnec = .T.
	Do Sp_Conexion With "XMEGATLON"
Endif


mexe	= "XMEGATLON"
Do Form frmguardia04e With ,'.'

If !Used("mwkusuario_sec")
	Messagebox("Usted no tiene usuario asignado"+Chr(13)+"Se ingresara como un usuario generico",48,"Control de Ingreso")
	Cancel
Else
	midusu = mwkusuario_sec.idusuario
	mpass   = mwkusuario_sec.Password

	If mwkusuario_sec.leg_id = 0
		Messagebox('No puede continuar. Debe comunicarse con sistemas.'+Chr(13)+'Tipo de Error: Leg_Id=0',48,'Error de Nº de Legajo')
		Return .F.
	Endif


	Do sp_valido_usuario With midusu, mpass , "XMEGATLON"
Endif


If Reccount('mwkexe')= 0
	mret = SQLExec(mcon1, "select nomexe,versionactual,launcher,versionminima,tabexe.id as idexe  " + ;
		"from tabexe " + ;
		"where nomexe = ?mexe " , "mwkexe")
Else
	Do sp_armo_permisos_menu With mwkusuario_sec.Id, 0
Endif

Select mwkusuario_sec.*,"PISOS" As SECTOR From mwkusuario_sec Into Cursor mwkusuario
USE IN SELECT('mwktabcfg')

Do seteos_configuracion
If mresplog = 0
	Do sp_busco_server_namespaces
	On Error =Aerr(eros)
	mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
	mcadcon = Filetostr(mfile)
	On Error
	If Type('mcadcon') = "C"
		mDatabase = Mline(mcadcon,3)
		mDatabase = Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
		If !Empty('mDatabase')
			Select mwktabcfg
			Replace olespaces With mDatabase
		Endif
	Endif

*!*		Do megatlonmenu.mpr
*!*		Read Events

Endif

Procedure Lmenu
Return

Procedure pdatos
Return
