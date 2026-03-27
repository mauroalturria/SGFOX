****
**  Seteos del sistema
****
parameters mparam

musua="LTURCHI"
msector=3

public mcon1, mcon1, mcon4, midusu,mconc,myip,miform,mxambito,mxcentromedico
mxcentromedico=1
mxambito = 1



public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, ;
	msel_datos(25,4),det_fac(40,8),dat_busca(40,8)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4);
	,det_fac(40,8),dat_busca(40,8)


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
set Enginebehavior 70


do seteos_ip
myip = IPAddress()


*!*	&& DA ERROR EN USUARIO LIMITADO
*!*	dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
*!*	if !file(dirfonts)
*!*		copy file Pf_i2of5.ttf to &dirfonts
*!*	endif

public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, msel_datos(25,4),det_fac(40,8)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)
public VDATOS(100)

create cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc n(13), tipdoc n(2), domici c(50), tel c(20), ;
	cpostal n(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

mresplog = 0


if !used("mwkserver1")
	lDisconnec = .t.
	do Sp_Conexion
endif

midusu	= musua
mexe	= "TURNOS"

do sp_valido_usuario with midusu, "*¿*¿*¿*¿", mexe
do sp_armo_permisos_menu with mwkusuario.id, msector

create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
insert into mwkexe values ("AUTORPRINT","","\\172.16.5.46//C:/C/AUTORPRINT.exe","")
do seteos_configuracion

mtfhoy  = sp_busco_fecha_serv('DT')

mlimite = 3600
mverexe = prg_version_exe("C")
mverexe = alltrim(transf(mverexe))
mverexeX = prg_version_exe("X")
mverexeX = alltrim(transf(mverexeX))
if len(mverexeX)<3
	if !prg_control_ver(mverexe, alltrim(mwknexe.versionminima))
*				do log_errores with 1, mverexe+ alltrim(mwkexe.versionminima),mwkexe.nomexe,"LOGIN", 1
		messagebox("HAY UNA ACTUALIZACION PENDIENTE PARA ESTE PROGRAMA. " + chr(13)+;
			"PARA ACTUALIZAR CIERRE TODAS LAS APLICACIONES DE ALTA COMPLEJIDAD Y EL LANZADOR"+;
			chr(13) + "DISCULPE LAS MOLESTIAS...",48,"Control Sistemas")
		cancel
	endif
else
	if !prg_control_ver(mverexe, mverexeX) or !prg_control_ver(mverexex, mverexe)
*				do log_errores with 1, mverexe+'-'+alltrim(mverexeX),mwkexe.nomexe,"MENU", 1
		messagebox("HAY UNA ACTUALIZACION PENDIENTE PARA ESTE PROGRAMA. " + chr(13)+;
			"PARA ACTUALIZAR CIERRE TODAS LAS APLICACIONES DE ALTA COMPLEJIDAD Y EL LANZADOR"+;
			chr(13) + "DISCULPE LAS MOLESTIAS...",48,"Control Sistemas")
		cancel
	endif
endif
use in select('mwkexe')
create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
insert into mwkexe values ("TURNOS","","\\172.16.5.46//C:/C/TURNOS.exe","")

on error do log_errores with error(), message(), message(1), program(), lineno()

do seteos_configuracion


