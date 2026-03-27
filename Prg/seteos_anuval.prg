****
**  Seteos del sistema
****
Lparameters miparam
If Empty(miparam)
   Messagebox("ACCESO NO AUTORIZADO",16,"Control de ingreso")
   Cancel
Endif

public mcon1, midusu, mpassw,mcon1,myip,mcon3,mxambito  ,mxcentromedico
mxcentromedico=1

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
SET ENGINEBEHAVIOR 70

public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(20,4),dat_cose(13)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(20,4),dat_cose(13)

mresplog = 0
do sp_busco_server_namespaces
do sp_conexion With "MAIL_ALERT"
do form frmanuval   &&& Envio Mail Mantenimiento

do sp_desconexion with "fin"

cancel
