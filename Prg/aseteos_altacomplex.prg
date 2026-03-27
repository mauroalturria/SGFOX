public mcon1, mcon1, mcon4, midusu,mconc,myip,miform,mxambito ,block_ent ,archini(1),mxcentromedico 
mxambito = 1
mxcentromedico =1


public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, ;
	msel_datos(25,4),det_fac(40,8),dat_busca(40,8),dat_ac(30)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4);
	,det_fac(40,8),dat_busca(40,8),dat_ac(30)

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
_screen.keypreview = .t.
SET ENGINEBEHAVIOR 70
block_ent = ''
do seteos_ip
myip = IPAddress()


mresplog = 0

modify windows screen;
	title "AUTORIZACIONES"
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
		fill file &cfondo 
do seteos_configuracion

do form frmloguin1 with 'ALTACOMPLEX'
if mresplog = 0
	do sp_busco_server_namespaces

*!*		do altacmenu.mpr
*!*		read events
endif
*sp_actautprevias cambio a sp_actualizo_autp_estado.prg
*sp_acttabautobs.prg  a sp_actualizo_autp_obs.prg