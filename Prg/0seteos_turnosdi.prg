do prg_var_public

mxambito = 1
lcTitle = 'TurnoDI'
lcNomExe = 'TURNODI'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public
SET ENGINEBEHAVIOR 70

With _Screen
	.Caption = lcTitle 
	.WindowState = 2
	.icon = 'net14.ico'
	.KeyPreview = .T. && ver si hace falta
*	.icon = ''
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
do sp_desconexion


If prg_modo_exe()
	Do turnoDImenu.mpr
	Read Events
Endif 	



procedure LMENU 
procedure MF2 
procedure XMLTOCURSOR 
procedure ASTACKINFO
procedure ALLAMADA
procedure GETWORDCOUNT
procedure GETWORDNUM

