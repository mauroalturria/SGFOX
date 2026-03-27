**  Seteos del sistema

Public mcon1, midusu, mpassw, mcodvax, mcon1, mresplog,myip,mxambito 
mxambito = 1
SET ENGINEBEHAVIOR 70

Public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)
Dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)
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
Set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep, Vrs
Set optimize on
Set point to ","
Set safety off
Set separator to "."
Set status off
Set status bar off
Set talk off
Set sysmenu off
Set escape off

Do seteos_ip
myip = IPAddress()


mresplog = 0
_Screen.WindowState = 2
Modify windows screen ;
	title "Prestadores"
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify windows screen;
	fill file &cfondo

Do form frmloguin1 with 'PRESTADORES'

* mresplog = 1

If mresplog = 0
	do sp_busco_server_namespaces
	on error =aerr(eros)
	mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
	mcadcon = filetostr(mfile)
	On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	if type('mcadcon') = "C"
		mDatabase 	= mline(mcadcon,3)
		mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
		if !empty('mDatabase')
			select mwktabcfg
			replace olespaces with mDatabase 	
		endif	
	endif		
	do seteos_configuracion
*!*		Do prestamenu.mpr
*!*		Read events
Endif

Procedure LMENU
Return
