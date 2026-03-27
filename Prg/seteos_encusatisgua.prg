****
**  Seteos del sistema - Guardia
****

public mcon1, midusu, mpassw, mcodvax, mcon1, mresplog,myip,miform,mintcall,mxambito 
mxambito  = 1

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
_screen.Visible =  .f.

SET ENGINEBEHAVIOR 70
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


do form frmencu_satis_guardia.scx

Read Events
 