**  Seteos del sistema
**  Seteos del sistema
lparameters miparam

public mcon1,mcon1, midusu, mpassw,myip,miform,menthabil ,mxambito ,block_ent,musuhabil,mxcentromedico 
mxcentromedico =1
mxambito = 1
if vartype(miparam)="C"
	if miparam <> "C"
		block_ent = transf(miparam)
		musuhabil= block_ent
	else
		
		block_ent  = ''
		musuhabil= miparam
	endif
else
	block_ent  = ''
	musuhabil= miparam
endif
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
public dat_vale(30), item_vale(30)
do seteos_ip
myip = IPAddress()
SET ENGINEBEHAVIOR 70

modify windows screen;
	title "Internados"
_screen.windowstate = 2
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo

if vartype(musuhabil) # "C"
	do form frmloguin1 with 'PADRONES'
endif

do sp_busco_server_namespaces
on error =aerr(eros)
mfile = justpath(sys(16,0))+"\inicio\ini.txt"
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
create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
insert into mwkexe values ("SOLOINTERNADOS","","\\172.16.5.46//C:/C/solointernados1.exe","")
do form frmPAC_internados1
read events
