**  Seteos del sistema

public mcon1, midusu, mpassw, mcodvax, mcon1, mresplog,myip,mxambito ,mxcentromedico
mxcentromedico=1
mxambito = 1
public vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, ;
	msel_datos(25,4),det_fac(40,8),xusuariologin,dat_cose(40,13)
dime vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), ;
	msel_datos(25,4),det_fac(40,8),dat_cose(40,13)

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
set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep, Vrs
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off
do seteos_ip
myip = IPAddress()

SET ENGINEBEHAVIOR 70
mresplog = 0

mresplog = 0
_screen.windowstate = 2
modify windows screen;
	title "Medicos"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo
do form frmloguin1 with 'MEDICOS1'
	do seteos_configuracion
if mresplog = 0
	do medicos1menu.mpr
	read events
endif
