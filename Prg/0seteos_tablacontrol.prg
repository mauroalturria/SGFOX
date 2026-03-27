*SET DEFAULT TO "C:\desaguemes"
if prg_modo_exe()

	_screen.windowstate = 0
	_screen.maxheight = 800
	_screen.maxwidth = 1060
	_screen.maxbutton = .f.
	_screen.minbutton = .t.
endif
set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep

do prg_var_public

mxambito = 1
lcTitle = "Control de Admisión y Derivaciones"
lcNomExe = 'TABCONTROL'

do prg_set
do seteos_ip && aca se asigna la MyIp
do prg_creo_Dirs
do seteos_public

with _screen
	.caption = lcTitle
	.keypreview = .t. && ver si hace falta
	.icon = 'GRAPH03.ICO'
endwith

cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo

*!*	------------------------------------------------------
*!*	Login
*!*	------------------------------------------------------
mresplog = 0
do form frmloguin1 with lcNomExe
if mresplog <> 0
	cancel
endif
*!*	------------------------------------------------------
if !prg_sistemas_abiertos(lcTitle, lcNomExe)
	cancel
endif


do sp_busco_server_namespaces
do prg_setDatabase
do seteos_configuracion
if prg_modo_exe()
	do form frmtabcontrol01
	read events
endif
