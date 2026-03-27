*
* Habilitación médicos de guardia
* Hereda de Medicos
*
public mcon1, midusu, mpassw,myip,mxambito
mxambito = 1

public fecha_inicio_ejecutable

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
do seteos_ip
myip = IPAddress()
_screen.windowstate = 2
modify windows screen ;
	title "Habilitación Responsable de Piso"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo
do sp_busco_server_namespaces
on error =aerr(eros)
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
create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
insert into mwkexe values ("MEDICOSI","","\\172.16.5.46//C://medicosi.exe","")
on error do log_errores with error(), message(), message(1), program(), lineno()

do form frmmedicos09
read events

procedure Dat_cose
	return

procedure Dat_fac
	return

procedure Item_cose
	return

procedure Lmenu
	return
