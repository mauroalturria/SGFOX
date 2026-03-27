****
**  Seteos del sistema
****
do prg_var_public
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
set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep, ;
	xfrx,xfrx\xfrxlib,xfrx\gdip,xfrx\localization,;
	xfrx\nogdip,xfrx\prevdemo
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

Do seteos_public

mresplog = 0
do sp_busco_server_namespaces
do sp_conexion With "TURNOS"
midusu	= "CARMENA"
mexe	= "TURNOS"

do sp_valido_usuario with midusu, "*¿*¿*¿*¿", mexe
do sp_armo_permisos_menu with mwkusuario.id, 5

if !used('mwkexe')
	create cursor mwkexe (nomexe c(20),versionactual c(20), launcher c(50),versionminima c(20),idexe n (2))
	insert into mwkexe values ("TURNOS","1.0.0","\\172.16.5.46//C://turnos_bloq.exe","1.0.0",23)
endif

do form frmplan27   &&& Desbloqueo de turnos


do sp_desconexion with "fin"

cancel
