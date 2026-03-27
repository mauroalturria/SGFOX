****
**  Seteos del sistema
****
lparameters miparam
public mxcentromedico 

if vartype(miparam)="C"
	mxcentromedico = VAL(transf(miparam))
else
	mxcentromedico = 1
endif
Public block_ent
block_ent = ''


do prg_var_public

mxambito = 1
lcTitle = 'Pre Quirúrgicos'
lcNomExe = 'PREQUIRUR'

Do prg_set

*Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public
Do seteos_ip && aca se asigna la MyIp
With _Screen
	.Caption = lcTitle 
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.icon = 'CXico.ICO'
Endwith 	

*!*	------------------------------------------------------
*!*	Login
_Screen.Icon = 'CXico.ico'
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
	Do prequirur.mpr
	Read Events
Endif

procedure MF2 
procedure AFECHAS 
procedure EROS 


