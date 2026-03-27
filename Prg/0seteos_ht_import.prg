Public block_ent
block_ent = ''

do prg_var_public

mxambito = 1
lcTitle = 'HT IMPORT'
lcNomExe = 'TURNOS'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public

With _Screen
	.Caption = lcTitle 
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.icon = 'serverws.ico'
Endwith 	

create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
insert into mwkexe values (lcNomExe,"","\\172.16.5.46//C:/C/HTIMPORT.exe","")

*!*	mresplog = 0
*!*	do form frmloguin1 with lcNomExe 

*!*	if mresplog <> 0
*!*		Cancel 
*!*	Endif 	
*!*	------------------------------------------------------
If !prg_sistemas_abiertos(lcTitle, lcNomExe)
	Cancel 
Endif  

do sp_conexion
Do sp_busco_server_namespaces
Do prg_setDatabase
Do seteos_configuracion

create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
insert into mwkexe values ("TURNOS","","\\172.16.5.46//C:/C/TURNOS.exe","")

 
Do sp_ht_proc
DO sp_desconexion WITH "IMPORT HT"

*!*	If prg_modo_exe()
*!*		Do quirofmenu.mpr
*!*		Read Events
*!*	Endif



