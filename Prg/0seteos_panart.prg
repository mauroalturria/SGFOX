****
**  Seteos del sistema
****

Public mxcentromedico ,block_ent

mxcentromedico = 1
block_ent = ''

Do prg_var_public

mxambito = 1
lcTitle = 'Panel ART'
lcNomExe = 'PANELART'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public

With _Screen
	.Caption = lcTitle
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.Icon = 'alto.ICO'
Endwith

*!*	------------------------------------------------------
*!*	Login
_Screen.Icon = 'CXico.ico'
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
Do sp_desconexion

If prg_modo_exe()
	Do panelart.mpr
	Read Events
Endif

Procedure MF2
Procedure AFECHAS
Procedure EROS


