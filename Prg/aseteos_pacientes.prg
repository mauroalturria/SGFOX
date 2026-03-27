**  Seteos del sistema
Lparameters miparam
*lusuhabil='asd'
Public mcon1,mcon1, midusu, mpassw,myip,miform,menthabil ,mxambito ,block_ent,mxcentromedico
mxambito = 1
miparam= '945,948,904,909'
mxcentromedico = 1
If Vartype(miparam)="C"
	block_ent = Transf(miparam)
Else
	block_ent = 'PROTO'
Endif
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
_Screen.KeyPreview = .T.
Set ENGINEBEHAVIOR 70
Public dat_vale(30), item_vale(30)
Do seteos_ip
myip = IPAddress()

Modify Windows Screen;
	title "Pacientes"
_Screen.WindowState = 2
cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify Windows Screen;
	fill File &cfondo

Do Form frmloguin1 With 'PACIENTES'
If Used('mwkusuario')
	If Reccount('mwkusuario')>0

		Do sp_busco_server_namespaces
		On Error =Aerr(eros)
		mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
		mcadcon = Filetostr(mfile)
		On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()

		If Type('mcadcon') = "C"
			mDatabase 	= Mline(mcadcon,3)
			mDatabase 	=Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
			If !Empty('mDatabase')
				Select mwktabcfg
				Replace olespaces With mDatabase
			Endif
		Endif
		If block_ent = 'PROTO'
			Do sp_conexion
			If !sp_busco_permiso_usua('frmopera30', 'CMDAUTORIZA', mwkusuario.Id,"mwkPerMASTER") && && permite modificar motivo de ingreso
				Return
			Endif

			If Reccount("mwkPerMASTER")>0
				Do Form frmopera30
			Endif
			Do sp_busco_EntiUsu With 1,mwkusuario.Id
			block_ent = '17'
			Select mwkEntiUsu
			Scan
				block_ent = block_ent + ","+Transform(ENT_codent)
			Endscan

			Do sp_desconexion
		Endif
		Do Form frmarchivo63r
*	Read Events
	Else
		Cancel
	Endif
Else
	Cancel
Endif

