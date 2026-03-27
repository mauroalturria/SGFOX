****
**  Seteos del sistema - Reclamos
****

Public mcon3,midusu, mpassw, msql_rec, mcon1,mconexion,myip,mxambito ,mxcentromedico 
mxcentromedico =1
mxambito = 1

public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(20,4),dat_cose(13)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(20,4),dat_cose(13)

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

*****
mresplog = 0
mconexion = 0

modify windows screen title "CODIGOS" 
_SCREEN.WindowState = 2
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
		fill file &cfondo 
 
 
	do form frmloguin1 with 'CODIGOS'
	do seteos_configuracion

	if mresplog = 0
		do codigosmenu.mpr
		read event
	endif	
	
procedure vdatos
return	