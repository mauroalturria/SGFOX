****
**  Seteos del sistema
****

public mcon1, mcon1, mcon4, midusu,myip,miform,mxambito 
mxambito = 1


public mflag, mvuelvo, mregistracio, mform, msql1, mcodent, ;
	msql_reg, msql, msql_pre, mdesc, manos, mmeses, mdias,archini(1)
public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, ;
	msel_datos(25,4),det_fac(40,8),dat_busca(40,8),dat_ac(30)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4);
	,det_fac(40,8),dat_busca(40,8),dat_ac(30)
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
set ENGINEBEHAVIOR 70


mresplog = 0
_screen.windowstate = 2
modify windows screen;
	title "PRESUPUESTOS"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo

do form frmloguin3 with 'PRESUPUESTOS'

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
	if !directory("C:\temp\informes")
		mkdir "C:\temp\informes"
	endif
	if !directory("C:\temp\imagenes")
		mkdir "C:\temp\imagenes"
	endif
	do seteos_configuracion
	do sp_conexion
	do presumenu.mpr
	read events
endif
