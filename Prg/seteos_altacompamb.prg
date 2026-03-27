****
**  Seteos del sistema
****
lparameters usu_id,usu_idusuario,usu_password,usu_sector
public mcon1, mcon1, mcon4, midusu,mconc,myip,miform,mxambito
mxambito = 1
if vartype(usu_id)#"N"
	cancel
endif


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
_screen.keypreview = .t.
set ENGINEBEHAVIOR 70

do seteos_ip
myip = IPAddress()


mresplog = 0
*_screen.windowstate = 2
modify windows screen;
	title "AUTORIZACIONES"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo

do seteos_configuracion

do sp_busco_server_namespaces
ldisconnec = .f.
if !used("mwkserver1")
	do sp_conexion
	ldisconnec = .t.
endif
do sp_valido_usuario with usu_idusuario, usu_password, 'TURNOS'
select mwksec2
locate for descrip = usu_sector
usu_idsec = mwksec2.ID
do sp_armo_permisos_menu with usu_id, usu_idsec
if ldisconnec
	do sp_desconexion with "sp_busco_server_namespace"
endif

do form frmautor15 WITH "",1
