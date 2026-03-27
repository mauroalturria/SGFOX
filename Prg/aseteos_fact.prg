****
**  Seteos del sistema - Informes
****

public mcon1, midusu, mpassw, msql_reg, mcon3,mconc,myip,miform,mxambito 
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
set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off
SET ENGINEBEHAVIOR 70
do seteos_ip
myip = IPAddress()


*****
mresplog = 0
public vec_vale(31,3), dat_facc(20), dat_fac(100),det_fac(200,8), item_vale(61,3),  ;
	mversion, msel_datos(25,4),msel_datos(25,4),;
	dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)
dime vec_vale(31,3), dat_vale(30), item_vale(61,3), dat_facc(20), dat_fac(100),det_fac(200,8), ;
	msel_datos(25,4),msel_datos(25,4) ,;
	dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)

modify windows screen ;
	title "Facturacion"
_screen.windowstate = 2
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo
_screen.icon = 'biz.ico'

do form frmloguin1 with 'FACTURACION'

if mresplog = 0

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
	do seteos_configuracion
*!*		do facturamenu.mpr
*!*		read event
endif


Procedure AFINDHWND
Procedure DAT_VALE 
Procedure MF2 
