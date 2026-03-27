Set Ansi On
Set Bell Off
Set Cent On
Set Compatible Off
Set Conf On
Set Date To French
Set Decimal To 2
Set Dele On
Set Exact On
Set Exclu Off
Set Fdow To 1
Set Hours To 24
Set Near On
Set Notify Off
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Talk Off
Set Sysmenu Off

Do prg_var_public

mxambito = 1
lcTitle = "Grupos de Contacto"
lcNomExe = 'CONTACTGROUP'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_creo_Dirs
Do seteos_public

With _Screen
	.Caption = lcTitle
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.Icon = 'users.ICO'
Endwith

*!*	------------------------------------------------------
*!*	Login
*!*	------------------------------------------------------
mresplog = 0
Do Form frmloguin1 With lcNomExe

If mresplog <> 0
	Cancel
Endif

*!*	------------------------------------------------------

If !prg_sistemas_abiertos(lcTitle, lcNomExe)
	Cancel
Endif

Do sp_busco_server_namespaces
Do prg_setDatabase
Do seteos_configuracion
Do sp_conexion

If prg_modo_exe()
	Do Form frmmensajeria0
	Read Events
Endif

