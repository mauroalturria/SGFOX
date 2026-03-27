****
**  Seteos del sistema
****
Lparameters miparam
Public mxcentromedico

If Vartype(miparam)="C"
	mxcentromedico = Val(Transf(miparam))
Else
	mxcentromedico = 1
Endif
Do prg_var_public

mxambito = 14
lcTitle = 'Rendimientos '
lcNomExe = 'TURNOS'
Do prg_set
Do seteos_ip && aca se asigna la MyIp
*Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public
*Set ENGINEBEHAVIOR 70

With _Screen
	.Caption = lcTitle
	.WindowState = 2
	.Icon = 'crdfle04.ico'
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


Do sp_busco_server_namespaces
Do prg_setDatabase
Do seteos_configuracion
Do sp_desconexion


*!*	If prg_modo_exe()
*!*		Do rendimenu.mpr
*!*		Read Events
*!*	Endif



Procedure LMENU
Procedure MF2
Procedure Xmltocursor
Procedure Astackinfo
Procedure ALLAMADA
Procedure Getwordcount
Procedure Getwordnum

