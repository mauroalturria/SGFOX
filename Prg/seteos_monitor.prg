****
**  Seteos del sistema
****
lparameters miparam
public mcon1, midusu, mpassw,mcon1,myip
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
do seteos_ip
myip = IPAddress()
modify windows screen;
	title "MONITOR"
on error =aerr(eros)
mfile = "H:\interfaz\destinos\ini.txt"
mcadcon = filetostr(mfile)
on error
if type('mcadcon') = "C"
	nlineas = alines(mimatini,mcadcon)
	lmyip = ascan(mimatini,"["+ alltrim(myip) +"]")
	miparam	= alltrim(mline(mcadcon,1+lmyip ))
endif

do form frmmonitor01 with miparam	&&
read event

