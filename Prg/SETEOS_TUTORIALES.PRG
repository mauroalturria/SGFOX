**
* Sistema : Sanatorio Güemes
* Módulo  : Tutoriales ( Seteos del Sistema )
* Fecha   : 18-07-2008
* Observ. : Hereda del Proyecto Legales
****

Public mcon1, mcon2, mcon4, midusu,mconc,myip,miform

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
Set point to ","
Set safety off
Set separator to "."
Set status off
Set status bar off
Set talk off
Set sysmenu off

Set resource off

Do seteos_ip
myip = IPAddress()


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
	title " TUTORIALES"
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify windows screen;
	fill file &cfondo

	If !directory("C:\temp\videos")
		Mkdir "C:\temp\videos"
	Endif
	Do sp_conexion
	midusu	= "MEDICO"
	mpassw	= "GUARDIA"
	mexe	= "TUTORIALES"

	do sp_valido_usuario with midusu, mpassw, mexe
	do sp_armo_permisos_menu with mwkusuario.id, 7
	select codigovax, idusuario, password, mwkusuario.id, mwkmenu.codgrupo as nivel, ;
		mwksector2.descrip as sector,nomape,mwkusuario.passwordldap ;
		from mwkusuario, mwkmenu, mwksector2 ;
		where mwksector2.ID =7;
		group by idusuario into cursor mwkusuario

	Do tutorialesmenu.mpr
	Read events
	Do sp_desconexion

* Por No definiciones documentadas en el arch. ERR, al compilar
Procedure Lmenu
Return

Procedure pdatosfrmtutoriales01
Return

Procedure DAT_COSE
Return

Procedure ITEM_COSE
Return
