****
**  Seteos del sistema - Guardia
****

public mcon1, midusu, mpassw, mcodvax, mcon1, mresplog,myip,miform,mintcall,mxambito ,mxcentromedico
mxambito  = 1
mxcentromedico=1
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
set path to scx, lib, mnu, prg, exe, bmp, rep
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off
_screen.keypreview = .t.
SET ENGINEBEHAVIOR 70
do seteos_ip
myip = IPAddress()

dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
if !file(dirfonts) AND myip<>'172.16.1.7'
*	copy file Pf_i2of5.ttf to &dirfonts
endif

do seteos_public

public vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(25,4),;
	det_fac(40,8),xusuariologin,dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)
dime vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(25,4),;
	det_fac(40,8),dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)

do form frmloguin1 with 'AMBULATORIO'
mcantexe = 0
do prg_exes_activos with Proper("AMBULATORIO") + "      P.Id:"
if mcantexe>2 and mwkusuario.sector # "SISTEMAS"
	messagebox("NO PUEDE INGRESAR A MAS DE DOS APLICACIONES DE AMBULATORIO"+;
		chr(13) + "DISCULPE LAS MOLESTIAS...";
		,48,"Control Sistemas")
	cancel
else

	if mresplog = 0
		do sp_busco_server_namespaces
		on error =aerr(eros)
		mfile = justpath(sys(16,0))+"\inicio\ini.txt"
		if at("EXE",mfile)=0
			mfile = "..\exe\inicio\ini.txt"
		endif
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
*!*			do ambulamenu.mpr
*!*			read event
	endif
endif
