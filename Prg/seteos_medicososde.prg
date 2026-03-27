**  Seteos del sistema
lparameters lusuhabil
*lusuhabil='asd'
Public mcon1,mcon1, midusu, mpassw,myip,miform,musuhabil,mxambito 
mxambito = 1

musuhabil = lusuhabil

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
_screen.keypreview = .t.
public dat_vale(30), item_vale(30)
do seteos_ip
myip = IPAddress()

modify windows screen;
	title "Medicos Externos"
_SCREEN.WindowState = 2
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
		fill file &cfondo 
set ENGINEBEHAVIOR 70
if vartype(lusuhabil) # "C"
	do form frmloguin1 with 'PADRONES'
endif

	do sp_busco_server_namespaces
	on error =aerr(eros)
	mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
	mcadcon = filetostr(mfile)
 	on error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()

	if type('mcadcon') = "C"
		mDatabase 	= mline(mcadcon,3)
		mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
		if !empty('mDatabase')
			select mwktabcfg
			replace olespaces with mDatabase 	
		endif	
	endif	
	create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
	insert into mwkexe VALUES ("MEDICOSDE","","\\172.16.5.46//C:/C/MEDICOSDE.exe","")
	do form frmprestadvig
	read events