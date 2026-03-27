Lparameters lusuhabil

musuhabil = lusuhabil

Set Ansi On
Set Bell Off
Set Cent On
Set Compatible Off
Set Conf On
Set Date To French
Set Decimal To 2
Set Dele On
Set Exact On
Set Exclu Off
Set Fdow To 1
Set Hours To 24
Set Near On
Set Notify Off
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Talk Off
Set Sysmenu Off
Set NullDisplay To ""

Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep

Do prg_var_public

mxambito = 1
lcTitle = "Beepers SG"
lcNomExe = 'BEEPERSSG'
mxcentromedico=1
*lcNomExe = 'PISOS'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_creo_Dirs
Do seteos_public

With _Screen
	.Caption = lcTitle
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.Icon = 'beeper.ico' && ver icono acorde
Endwith

*!*	------------------------------------------------------
*!*	Login
*!*	------------------------------------------------------

mresplog = 0

If Vartype(lusuhabil) # "C"
	Do Form frmloguin1 With lcNomExe
Endif
If !Used('mwkexe')
	Create Cursor mwkexe (nomexe c(20),versionactual c(20), launcher c(50),versionminima c(20),idexe N (2))
	Insert Into mwkexe Values ("BEEPERSSG","1.0.0","\\172.16.5.46//C://beeperssg.exe","1.0.0",23)
Endif

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
Do sp_conexion

*-----------------------------

If Used("mwkusuario")
	Create Cursor mwkremite (nombres c(35))
	Insert Into mwkremite (nombres) Values (mwkusuario.nomape)
Endif


If !Used('mwkusuario')
	midusu	= "MAUDITOR"
	mpassw	= "MEDICO"
	mexe	= "BEEPERSSG"
	Do sp_valido_usuario With midusu, mpassw, mexe
	If File('c:\tempdoc\usuario.txt')
		mnombre = Filetostr('c:\tempdoc\usuario.txt')
	Else
		mnombre = Sys(0)
		mnombre = Alltrim(Substr(mnombre,(Atc('#',mnombre) + 2)))
	Endif

	Select codigovax,mnombre As idusuario,Password,Id,1 As nivel,nomape,passwordldap	,;
		"PISOS" As sector From mwkusuario Into Cursor mwkusuario
Endif
*----------------------------
If prg_modo_exe()
	Do Form frmbeepers1
	Read Events
Endif
