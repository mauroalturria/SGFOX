****
**  Seteos del sistema
****
lparameters lusuhabil
public mcodent ,msql_reg,mcon1, mcon1, mcon4, midusu,mconc,myip,musuhabil,mxambito,mxcentromedico 
mxcentromedico =1
mxambito = 1
public mversion, xusuariologin,dat_ws(30)
dime dat_ws(30)

musuhabil = lusuhabil
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
do seteos_ip
myip = ipaddress()


*!*	dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
*!*	if !file(dirfonts)
*!*		copy file Pf_i2of5.ttf to &dirfonts
*!*	endif

public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, msel_datos(25,4),det_fac(40,8)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)

create cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc n(13), tipdoc n(2), domici c(50), tel c(20), ;
	cpostal n(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

mresplog = 0
_screen.windowstate = 2
modify windows screen;
	title "PADRONES"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo
if vartype(lusuhabil) # "C"
	do form frmloguin1 with 'PADRONES'
endif
if !used('mwkexe')
	create cursor mwkexe (nomexe c(20),versionactual c(20), launcher c(50),versionminima c(20),idexe n (2))
	insert into mwkexe values ("PADRONES","1.0.0","\\172.16.5.46//C://padrones.exe","1.0.0",23)

endif
if mresplog = 0
 	on error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	do sp_busco_server_namespaces
	on error =aerr(eros)
	mfile = justpath(sys(16,0))+"\inicio\ini.txt"
	mcadcon = filetostr(mfile)
	on error
	if type('mcadcon') = "C"
		mdatabase 	= mline(mcadcon,3)
		mdatabase 	=alltrim(substr(mdatabase,at("=",mdatabase)+1))
		if !empty('mDatabase')
			select mwktabcfg
			replace olespaces with mdatabase
		endif
	endif
	do sp_conexion
	if !used('mwkusuario')
		midusu	= "MAUDITOR"
		mpassw	= "MEDICO"
		mexe	= "PADRONES"
		do sp_valido_usuario with midusu, mpassw, mexe
		if file('c:\tempdoc\usuario.txt')
			mnombre = filetostr('c:\tempdoc\usuario.txt')
		else
			mnombre 	= sys(0)
			mnombre 	= alltrim(substr(mnombre,(atc('#',mnombre) + 2)))
		endif

		select codigovax,mnombre as idusuario,password,id,1 as nivel,nomape,passwordldap	,;
			"SISTEMAS" as sector from mwkusuario into cursor mwkusuario
	endif
	do seteos_configuracion

	do form frmconsul05
	do sp_desconexion with "PADRONES"
*	do padmenu.mpr
	read events

endif
