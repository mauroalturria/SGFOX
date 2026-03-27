do prg_var_public

mxambito = 1
lcTitle = 'Servidores'
lcNomExe = 'TURNOS'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public
set ENGINEBEHAVIOR 70
SET STEP ON
With _Screen

	.Caption = lcTitle 
*!*		If prg_modo_exe()
*!*			.Visible = .f.
*!*		Endif 	
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.icon = 'C:\desaguemes\Bmp\serverws.ico'
Endwith 	
*!*	------------------------------------------------------
*!*	Login
*!*	------------------------------------------------------
*!*	mresplog = 0
*!*	Do Form frmloguin1 With lcNomExe

*!*	If mresplog <> 0
*!*		Cancel 
*!*	Endif 
*!*	------------------------------------------------------
*!*	If !prg_sistemas_abiertos(lcTitle, lcNomExe)
*!*		Cancel 
*!*	Endif  

Do sp_busco_server_namespaces
Do prg_setDatabase
Do seteos_configuracion
do sp_desconexion

*Public mcon1 

create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
insert into mwkexe VALUES ("Servidores","","\\172.16.5.46//C:/C/Servidores.exe","")


If prg_modo_exe()
	Do Form frmsvr01
	Read Events
Endif 

