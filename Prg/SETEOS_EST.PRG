****
**  Seteos del sistema - Informes
****

Public mcon1, midusu, mpassw, msql_reg, mcon1

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

*****
mresplog = 0
public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(22), mversion, msel_datos(25,4),det_fac(40,8)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(22), msel_datos(25,4),det_fac(40,8)

modify windows screen ;
	title "Informes" ;
	FILL FILE "\qepd1a1\solo_marca.jpg"
 
	do form frmloguin1 with 'ESTADISTICAS'

	if mresplog = 0

		do sp_busco_server_namespaces
		do informesmenu.mpr
		read event
	endif	