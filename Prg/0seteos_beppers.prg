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

set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep

do prg_var_public

mxambito = 1
lcTitle = "Beepers SG"
lcNomExe = 'BEEPERS'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_creo_Dirs
Do seteos_public

With _Screen
	.Caption = lcTitle 
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.icon = 'beepers.ico'
Endwith 	

*!*	------------------------------------------------------
*!*	Login
*!*	------------------------------------------------------
mresplog = 0
do form frmloguin1 with lcNomExe 

if mresplog <> 0
	Cancel 
Endif 	
*!*	------------------------------------------------------
If !prg_sistemas_abiertos(lcTitle, lcNomExe)
	Cancel 
Endif  


Do sp_busco_server_namespaces
Do prg_setDatabase
Do seteos_configuracion
DO sp_conexion
*do sp_desconexion

If prg_modo_exe()
	*Do form "c:\desaguemes\scx\frmbeepers00.scx"
	Do Form frmbeepers00
	Read Events
Endif  

