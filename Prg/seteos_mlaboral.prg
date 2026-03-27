****
**  Seteos del sistema
****
public mcon1, midusu, mpassw, mcodvax, mcon1, mresplog,myip,miform,mintcall,mxambito ,mxcentromedico
mxcentromedico=1
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
set path to scx, lib, mnu, prg, exe, bmp, rep
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off
_screen.keypreview = .t.
SET ENGINEBEHAVIOR 70

_Screen.Themes = .F.
_Screen.Icon = 'emplead.ico'

do seteos_ip
myip = IPAddress()

dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
if !file(dirfonts)
	*copy file Pf_i2of5.ttf to &dirfonts
endif

do seteos_public

public vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(25,4),;
	det_fac(40,8),xusuariologin,dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)
dime vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(25,4),;
	det_fac(40,8),dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)

mresplog = 0
_screen.windowstate = 2
modify windows screen;
	title "AMBULATORIO"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo

do form frmloguin1 with 'MLABORAL'

if mresplog = 0
	do sp_busco_server_namespaces
	on error =aerr(eros)
	mfile = justpath(sys(16,0))+"\inicio\ini.txt"
	if at("EXE",mfile)=0
		mfile = "..\exe\inicio\ini.txt"
	endif
	mcadcon = filetostr(mfile)
	on error do log_errores with error(), message(), message(1), program(), lineno()
	if type('mcadcon') = "C"
		mDatabase 	= mline(mcadcon,3)
		mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
		if !empty('mDatabase')
			select mwktabcfg
			replace olespaces with mDatabase
		endif
	endif
	do seteos_configuracion
	do mlabmenu.mpr
	read events
endif
