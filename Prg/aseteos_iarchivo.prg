****
**  Seteos del sistema
****

Public mcon1, mcon1, mcon4, midusu,myip,mxambito ,mxcentromedico 
 
	mxcentromedico = 1
mxambito = 1
SET ENGINEBEHAVIOR 70

public mflag, mvuelvo, mregistracio, mform, msql1, mcodent, ;
	msql_reg, msql, msql_pre, mdesc, manos, mmeses, mdias
public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, msel_datos(25,4),det_fac(40,8)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)
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

do seteos_ip
myip = IPAddress()



mresplog = 0

modify windows screen;
	title "ARCHIVO"

if file ("\qepd1a1\solo_marca.jpg")
	modify windows screen;
  		fill file "\qepd1a1\solo_marca.jpg"
endif
 

	do form frmloguin1 with 'ARCHIVOINTER'
	

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
		endif	
		if !used("mwkserver1")
			DO sp_conexion
		ENDIF
*	do archivoimenu.mpr
*  read events
	endif	
		