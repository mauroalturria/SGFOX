****
**  Seteos del sistema - Informes
****

public mcon1, midusu, mpassw, msql_reg, mcon3,mconc,myip,miform,mcon4,mxambito ,mxcentromedico 
mxcentromedico =1

mxambito = 1

public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)
public mcodent 
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

Set ENGINEBEHAVIOR 70

Create Cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc N(13), tipdoc N(2), domici c(50), tel c(20), ;
	cpostal N(4), locali c(25), pcia c(25), fecnac d, sexo c(1),email c(50),cuit c(13))

*****
mresplog = 0
public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(22), mversion, msel_datos(25,4),det_fac(40,8), msel_datos(25,4),det_fac(40,8),dat_cose(40,20),item_cose(40,20),dat_ws(30)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(22), msel_datos(25,4),det_fac(40,8), msel_datos(25,4),det_fac(40,8),dat_cose(40,20),item_cose(40,20),dat_ws(30)

modify windows screen title "Auditoria"
_screen.windowstate = 2
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo

do form frmloguin1 with 'AUDITORIA'
if mresplog = 0

	do sp_busco_server_namespaces
	on error =aerr(eros)
	mfile = justpath(sys(16,0))+"\inicio\ini.txt"
	mcadcon = filetostr(mfile)
	on error
 	on error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	if type('mcadcon') = "C"
		mDatabase 	= mline(mcadcon,3)
		mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
		if !empty('mDatabase')
			select mwktabcfg
			replace olespaces with mDatabase
		endif
	endif

	do seteos_configuracion
	do auditoriamenu.mpr
	read event
endif
