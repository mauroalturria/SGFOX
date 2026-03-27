do prg_var_public

mxambito = 1
lcTitle = 'Ingreso por Cordoba'
lcNomExe = 'TOTEM'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
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
do sp_desconexion

If prg_modo_exe()
	Do form frmtotgua1
	Read Events
Endif  
 

 