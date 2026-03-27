****
**  Seteos del sistema
****

Public mcon1, mcon1, mcon4, midusu,myip,miform,mxambito 
mxambito = 1


public mflag, mvuelvo, mregistracio, mform, msql1, mcodent, ;
	msql_reg, msql, msql_pre, mdesc, manos, mmeses, mdias,archini(1)
public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, ;
	msel_datos(25,4),det_fac(40,8),dat_busca(40,8),dat_ac(30)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4);
	,det_fac(40,8),dat_busca(40,8),dat_ac(30)
	
do seteos_ip
myip = IPAddress()

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

set ENGINEBEHAVIOR 70


mresplog = 0

modify windows screen;
	title "PRESUPUESTOS"
if file ("\qepd1a1\solo_marca.jpg")
	modify windows screen;
		fill file "\qepd1a1\solo_marca.jpg"
endif

do form frmloguin1 with 'PRESUPUESTOS'

if mresplog = 0
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

*!*		if !used("mwkserver1")
*!*			DO sp_conexion
*!*		ENDIF
*!*		do presumenu.mpr
*!*		read events
endif
