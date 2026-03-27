****
**  Seteos del sistema - Pisos
****
lparameters lusuhabil
public mversion, xusuariologin
lusuhabil ="H"
musuhabil = lusuhabil
public mcon1, midusu, mpassw, mcodvax, msql_reg, mcon1, ;
	mresplog,mtfhoy,myip,miform,block_ent,mxambito,mxcentromedico 
mxcentromedico =1
mxambito = 1


set ansi on
set bell off
set cent on
set compatible off
set conf on
set date to french
set decimal to 2
set dele on
set exact on
set exclu off
set fdow to 1
set hours to 24
set near on
set notify off
set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off

set ENGINEBEHAVIOR 70
do seteos_ip
myip = IPAddress()

dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
if !file(dirfonts)
	*copy file Pf_i2of5.ttf to &dirfonts
endif

*****
public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(20,4),dat_cose(40,20),item_cose(40,20)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(20,4),dat_cose(40,20),item_cose(40,20)
mresplog = 0

create cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc n(13), tipdoc n(2), domici c(50), tel c(20), ;
	cpostal n(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

****

 
_screen.windowstate = 0
_screen.MaxHeight =1200
_screen.MaxWidth = 1600
_screen.MaxButton = .T.
_screen.MinButton = .f.
modify windows screen ;
	title "Panel NEWS"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo
_screen.icon = 'desknav.ico'
IF vartype(musuhabil)#"C"
	do form frmloguin1 with 'PANELNEWS'
else
	do sp_conexion  with 'PANELNEWS'
	if !used('mwkusuario')
		midusu	= "PISO"
		mpassw	= "PRUEBA"
		mexe	= "PANELNEWS"
		do sp_valido_usuario with midusu, mpassw, mexe
		do sp_armo_permisos_menu with mwkusuario.id, 31
		select codigovax, idusuario, password, mwkusuario.id, mwkmenu.codgrupo as nivel, ;
			mwksector2.descrip as sector,nomape,mwkusuario.passwordldap,mwkusuario.idcodmed,mwkusuario.email ;
			from mwkusuario, mwkmenu, mwksector2 ;
			where mwksector2.descrip like 'PISOS' ;
			group by idusuario into cursor mwkusuario
		update mwkexe set nomexe='PANELNEWS'
	endif
	do seteos_configuracion

	do form frmpanel01
	do sp_desconexion with "PANELNEWS"
	read events
endif

procedure AFINDHWND
procedure MF2
procedure DAT_WS
procedure DET_FAC
procedure DAT_VALE1
procedure ITEM_VALE1
procedure AFECHAS
procedure EROS
procedure VDATOS

*!*	if !used('mwkusuario') or vartype(musuhabil)="C"
*!*		cancel
*!*	else
*!*		dodefault()
*!*	endif