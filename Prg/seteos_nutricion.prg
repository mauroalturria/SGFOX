****
**  Seteos del sistema
****
public mxcentromedico 

if vartype(miparam)="C"
	mxcentromedico = VAL(transf(miparam))
else
	mxcentromedico = 1
endif
do prg_var_public

mxambito = 1
lcTitle = 'NUTRICION'
lcNomExe = 'NUTRICION'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public
SET ENGINEBEHAVIOR 70
mresplog = 0
_Screen.WindowState = 2
Modify Windows Screen;
	title "NUTRICION"
cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify Windows Screen;
	fill File &cfondo
DO buscoini WITH "NUTRICION"

Do Form frmloguin1 With 'NUTRICION'
If mresplog = 0
	Do sp_busco_server_namespaces
	On Error =Aerr(eros)
	mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
	mcadcon = Filetostr(mfile)
*	on error
	On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	If Type('mcadcon') = "C"
		mDatabase 	= Mline(mcadcon,3)
		mDatabase 	=Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
		If !Empty('mDatabase')
			Select mwktabcfg
			Replace olespaces With mDatabase
		Endif
	Endif
	Do seteos_configuracion
	If !Used("mwkserver1")
		Do sp_conexion
	Endif
	Do nutricionmenu.mpr
	Read Events
Endif
