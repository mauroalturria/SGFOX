****
**  Seteos del sistema
****
lparameters miparam
public mxcentromedico 

if vartype(miparam)="C"
	mxcentromedico = VAL(transf(miparam))
else
	mxcentromedico = 1
endif
public mcon1, mcon1, mcon4, midusu,mconc,myip,miform,block_ent,mxambito 
mxambito = 1
block_ent = ''

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


dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
if !file(dirfonts)
	*copy file Pf_i2of5.ttf to &dirfonts
endif

public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(200), dat_facc(20), mversion, ;
	msel_datos(25,4),det_fac(200,8),dat_busca(40,8),dat_ws(30),vdatos(100)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(200), dat_facc(20), msel_datos(25,4),;
	det_fac(200,8),dat_busca(40,8),dat_ws(30),vdatos(100)

create cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc n(13), tipdoc n(2), domici c(50), tel c(20), ;
	cpostal n(4), locali c(25), pcia c(25), fecnac d, sexo c(1), email c(50),cuit c(13))


mresplog = 0
_screen.keypreview = .t.
SET ENGINEBEHAVIOR 70

_screen.windowstate = 2
modify windows screen;
	title "ADMISION"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo
_Screen.Themes = .F.
_Screen.Icon = 'note03.ico'
DO buscoini WITH "ADMISION"
do form frmloguin1 with 'ADMISION'

if mresplog = 0

	do sp_busco_server_namespaces
	on error =aerr(eros)
	mfile = justpath(sys(16,0))+"\inicio\ini.txt"
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
	

	do admisionmenu.mpr
	read events

endif
