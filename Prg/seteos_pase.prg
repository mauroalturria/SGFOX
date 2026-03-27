*!*	----------------------------------------------------------------------------------- 
**  Seteos del sistema - Pase de Guardia de enfermeria // Guardia y Ambulatorio
*!*	-----------------------------------------------------------------------------------

public mcon4, mcon1, midusu, mpassw, mcodvax, msql_reg, mresplog,;
	mtfhoy,myip,miform,mcon3,xtremeoff

close data
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

set procedure to c:\desaguemes\prg\sp_conexion  additive
SET ENGINEBEHAVIOR 70
do seteos_ip
myip = IPAddress()
dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
if !file(dirfonts)
	*copy file Pf_i2of5.ttf to &dirfonts
endif

*****
public vec_vale(31,3), dat_vale(25), item_vale(31,3), dat_fac(20), mversion, ;
	msel_datos(20,4),dat_cose(40,20),item_cose(40,20),dat_busca(40,8)
dime vec_vale(31,3), dat_vale(25), item_vale(31,3), dat_fac(20), msel_datos(20,4);
	,dat_cose(40,20),item_cose(40,20),dat_busca(40,8)
mresplog = 0

create cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc n(13), tipdoc n(2), domici c(50), tel c(20), ;
	cpostal n(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

create cursor confarma ;
	(protocolo c(10), insumo c(11), cantidad n(2), descrip c(40),codinsumo n(8),fhcons t, ulti l)

****
public mcantexe
xtremeoff = .f.
_screen.windowstate = 2
modify windows screen ;
	title "Guardia"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo


*do form frmloguin1 with 'GUARDIA'
do form frmloguin1 with 'PASES'
mcantexe = 0
do prg_exes_activos with Proper('PASE') + "      P.Id:"

if mcantexe>2 and (mwkusuario.sector # "SISTEMAS" and mwkusuario.idusuario # "MGRECO")
	messagebox("NO PUEDE INGRESAR A MAS DE DOS APLICACIONES DE GUARDIA"+;
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
		if !directory("C:\temp\informes")
			mkdir "C:\temp\informes"
		endif
		if !directory("C:\temp\imagenes")
			mkdir "C:\temp\imagenes"
		endif
		if !directory("C:\temp\guardia")
			mkdir "C:\temp\guardia"
		endif

		do pase.mpr
		read event

	endif
endif

Procedure AFINDHWND
return