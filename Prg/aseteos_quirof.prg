****
**  Seteos del sistema
****

Public mcon1, mcon1, mcon4, midusu,mconc,myip,msql_reg,mxambito, mimed 
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
set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off
Set Enginebehavior 70
Set Multilocks On
 
do seteos_ip
myip = IPAddress()

*!*	&& DA ERROR EN USUARIO LIMITADO
*!*	dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
*!*	if !file(dirfonts)
*!*		copy file Pf_i2of5.ttf to &dirfonts
*!*	endif

public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, msel_datos(25,4),det_fac(40,8)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)

create cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc n(13), tipdoc n(1), domici c(50), tel c(20), ;
	cpostal n(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

mresplog = 0
modify windows screen;
	title "ADMISION"
if file ("\qepd1a1\solo_marca.jpg")
	modify windows screen;
  		fill file "\qepd1a1\solo_marca.jpg"
endif
	do form frmloguin1 with 'QUIROFANO'
	
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
	do seteos_configuracion

*	do quirofmenu.mpr
*		read events
	
	endif	