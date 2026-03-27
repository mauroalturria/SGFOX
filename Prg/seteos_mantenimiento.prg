****
**  Seteos del sistema
****


Public mcon1, mcon1, mcon4, midusu,myip,miform,mxambito  ,mxcentromedico
mxcentromedico=1

mxambito = 1


public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(20,4),dat_cose(40,20),item_cose(40,20)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(20,4),dat_cose(40,20),item_cose(40,20)
mresplog = 0

do seteos_ip
myip = IPAddress()

_screen.WindowState = 2
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
mresplog = 0
 SET ENGINEBEHAVIOR 70
*!*	modify windows screen;
*!*		title "MANTENIMIENTO"
*!*	if file ("\qepd1a1\solo_marca.jpg")
*!*		modify windows screen;
*!*			fill file "\qepd1a1\solo_marca.jpg"
*!*	endif
Modify windows screen;
	title "MANTENIMIENTO"
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify windows screen;
	fill file &cfondo

do form frmloguin1 with 'MANTENIMIENTO' 

if mresplog = 0
	do sp_busco_server_namespaces
	on error =aerr(eros)
	mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
	mcadcon = filetostr(mfile)
	on error
	if type('mcadcon') = "C"
		mDatabase 	= mline(mcadcon,3)
		mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
		if !empty('mDatabase')
			select mwktabcfg
			replace olespaces with mDatabase
		endif
	ENDIF
	
	do  mantenimientomenu.mpr
	read events

	
endif
Procedure Lmenu
Return