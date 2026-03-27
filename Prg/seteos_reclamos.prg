****
**  Seteos del sistema - Reclamos
****

Public mcon3,midusu, mpassw, msql_rec, mcon1,mconexion,myip,miform,mxambito  ,mxcentromedico
mxcentromedico=1

mxambito = 1

public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(25,4),det_fac(40,8),xusuariologin
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(25,4),det_fac(40,8)

SET ENGINEBEHAVIOR 70
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
set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off

*!*	If Version(5) = 900
*!*		Set ENGINEBEHAVIOR 70
*!*		_screen.Icon = "net14.ico"
*!*	Endif 
_screen.Icon = "net14.ico"
do seteos_ip
myip = IPAddress()

mresplog = 0
mconexion = 0
modify windows screen ;
	title "Atencion Usuarios"
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
		fill file &cfondo 


_SCREEN.WindowState = 2
do form frmloguin1 with 'RECLAMOS'

if mresplog = 0
	do sp_busco_server_namespaces

	mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
	mcadcon = filetostr(mfile)
	if type('mcadcon') = "C"
		mDatabase 	= mline(mcadcon,3)
		mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
		if !empty('mDatabase')
			select mwktabcfg
			replace olespaces with mDatabase
		endif
	endif

	do reclamosmenu.mpr
	read event
endif
