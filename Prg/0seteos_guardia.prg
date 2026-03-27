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

Do prg_var_public

mxambito = 1
lcTitle = 'Guardia'
lcNomExe = 'GUARDIA'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public
Create Cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc N(13), tipdoc N(2), domici c(50), tel c(20), ;
	cpostal N(4), locali c(25), pcia c(25), fecnac d, sexo c(1),email c(50),cuit c(13))



Create Cursor confarma ;
	(protocolo c(15), insumo c(11), cantidad N(6), Descrip c(40),codinsumo N(8),fhcons T, ulti l,nval N(12),observa c(250))

****
Public mcantexe
xtremeoff = .F.
With _Screen
	.Caption = lcTitle
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.Icon = 'MISC05.ICO'
Endwith
Do prg_proxy   &&&& actualiza proxy
DO buscoini WITH "GUARDIA"
mresplog = 0
Do Form frmloguin1 With 'GUARDIA'
mcantexe = 0
Do prg_exes_activos With Proper('GUARDIA')
If mcantexe>2 And (mwkusuario.sector # "SISTEMAS" And mwkusuario.idusuario # "MGRECO")
	Messagebox("NO PUEDE INGRESAR A MAS DE DOS APLICACIONES DE GUARDIA"+;
		chr(13) + "DISCULPE LAS MOLESTIAS...";
		,48,"Control Sistemas")
	Cancel
Else


	If mresplog <> 0
		Cancel
	Endif
Endif
*!*	------------------------------------------------------


Do sp_busco_server_namespaces
Do prg_setDatabase
Do seteos_configuracion

If prg_modo_exe()
	Do guardiamenu.mpr
	Read Events
Endif

Procedure MF2
Procedure AFECHAS
Procedure EROS


