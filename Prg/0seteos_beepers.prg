SET DEFAULT TO "C:\desaguemes"

set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep

do prg_var_public

mxambito = 1
lcTitle = "Admin Beepers"
*lcNomExe = 'PISOS'
lcNomExe = 'BEEPERS'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_creo_Dirs
Do seteos_public

With _Screen
	.Caption = lcTitle 
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.icon = 'COSA.ICO'
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

*If prg_modo_exe()
*	Do form "c:\fabian\proyecto Beepers-systray\beepers systray.scx"
*	Read Events
*Endif  