****
**  Seteos del sistema
****


Do prg_set
Set ENGINEBEHAVIOR 70


Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public
mxambito = 1
mresplog = 0
myip = IPAddress()

mresplog = 0
lcTitle = 'Documentos'
lcNomExe = 'DOCUMENTOS'

With _Screen
	.Caption = lcTitle
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.Icon = 'documentos.ico'
Endwith


 
if !used("mwkserver1")
	lDisconnec = .t.
	do Sp_Conexion with "DOCUMENTOS"
endif



mexe	= "DOCUMENTOS"
do form frmguardia04e with ,'.'
if !used("mwkusuario_sec")
	messagebox("Usted no tiene usuario asignado"+chr(13)+"Se ingresara como un usuario generico",48,"Control de Ingreso")
	midusu = "ACCESO"
	mpass = "******"
	do sp_valido_usuario with midusu, mpass , "CALIDAD"
	select * from mwkusuario into cursor mwkusuario_sec
else
	midusu = mwkusuario_sec.idusuario
	mpass   = mwkusuario_sec.password
	do sp_valido_usuario with midusu, mpass , "CALIDAD"
endif
if reccount('mwkexe')= 0
	mret = sqlexec(mcon1, "select nomexe,versionactual,launcher,versionminima,tabexe.id as idexe  " + ;
		"from tabexe " + ;
		"where mbusexe = ?mexe " , "mwkexe")
else
	do sp_armo_permisos_menu with mwkusuario_sec.id, 0
endif

do seteos_configuracion

mtfhoy  = sp_busco_fecha_serv('DT')
fecha_inicio_ejecutable = mtfhoy
mlimite = 3600
mverexe = prg_version_exe("C")
mverexe = alltrim(transf(mverexe))
mverexeX = prg_version_exe("X")
mverexeX = alltrim(transf(mverexeX))
if len(mverexeX)<3
	if !prg_control_ver(mverexe, alltrim(mwknexe.versionminima))
*				do log_errores with 1, mverexe+ alltrim(mwkexe.versionminima),mwkexe.nomexe,"LOGIN", 1
		messagebox("HAY UNA ACTUALIZACION PENDIENTE PARA ESTE PROGRAMA. " + chr(13)+;
			"PARA ACTUALIZAR CIERRE TODAS LAS APLICACIONES DE ALTA COMPLEJIDAD Y EL LANZADOR"+;
			chr(13) + "DISCULPE LAS MOLESTIAS...",48,"Control Sistemas")
		cancel
	endif
else
	if !prg_control_ver(mverexe, mverexeX) or !prg_control_ver(mverexex, mverexe)
*				do log_errores with 1, mverexe+'-'+alltrim(mverexeX),mwkexe.nomexe,"MENU", 1
		messagebox("HAY UNA ACTUALIZACION PENDIENTE PARA ESTE PROGRAMA. " + chr(13)+;
			"PARA ACTUALIZAR CIERRE TODAS LAS APLICACIONES DE ALTA COMPLEJIDAD Y EL LANZADOR"+;
			chr(13) + "DISCULPE LAS MOLESTIAS...",48,"Control Sistemas")
		cancel
	endif
endif

on error do log_errores with error(), message(), message(1), program(), lineno()


if mresplog = 0
	do sp_busco_server_namespaces
	on error =aerr(eros)
	mfile = justpath(sys(16,0))+"\inicio\ini.txt"
	mcadcon = filetostr(mfile)
	on error
	if type('mcadcon') = "C"
		mDatabase 	= mline(mcadcon,3)
		mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
		if !empty('mDatabase')
			select mwktabcfg
			replace olespaces with mDatabase
		endif
	endif
	do seteos_configuracion
	if !used("mwkserver1")
		do sp_conexion
	endif
	do calidad.mpr
	read events
	do sp_desconexion
endif

procedure LMENU
	return
