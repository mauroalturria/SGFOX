**  Seteos del sistema
*close database
*close tables

public mcon1, mcon1, midusu, mpassw, mcodvax, myip,mxambito,mxcentromedico
mxambito = 1
mxcentromedico=1
                            
public vec_vale(31,3), dat_vale(30), item_vale(31,3)
dimension vec_vale(31,3), dat_vale(30), item_vale(31,3)

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

_screen.keypreview = .t.
_Screen.Icon = "secur02b.ico"


Set Enginebehavior 70


do seteos_ip
myip = IPAddress()


****
_screen.windowstate = 2
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")

modify windows screen;
	title "Usuarios" ;
	fill file &cfondo

mresplog = 0
do form frmloguin1 with 'ADMINISTRADOR'

if mresplog = 0
	do sp_busco_server_namespaces

	on error = aerr(eros)
	mfile = justpath(sys(16,0))+"\inicio\ini.txt"
	mcadcon = filetostr(mfile)
	on error

	if type('mcadcon') = "C"
		mDatabase 	= mline(mcadcon,3)
		mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
		if !empty('mDatabase')
			select mwktabcfg
			replace olespaces with mDatabase
		endif
	endif
	do form frmadminis01
endif
