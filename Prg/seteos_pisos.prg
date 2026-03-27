****
**  Seteos del sistema - Pisos
****
Lparameters miparam
Public mxcentromedico


If Vartype(miparam)='C'
	If Left(miparam,1)="-"
		mxcentromedico = Val(Substr(miparam,2,2))
		miparam = 0
	Else
		mxcentromedico =  Val(miparam)
	Endif
Else
	mxcentromedico = 1
Endif
If !BETWEEN(mxcentromedico,1,9)
	mxcentromedico =1
Endif
If Vartype(miparam)="C"
	block_ent = Transf(miparam)
Else
	block_ent = ''
Endif

Do prg_var_public
mxambito = 1
 
Do prg_set
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public
Do seteos_ip && aca se asigna la MyIp

_Screen.KeyPreview = .T.
Set ENGINEBEHAVIOR 70

myip = IPAddress()

Create Cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc N(13), tipdoc N(2), domici c(50), tel c(20), ;
	cpostal N(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

****
mresplog = 0
****
lcTitle = 'Pisos'
lcNomExe = 'PISOS'
cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
With _Screen
	.Caption = lcTitle
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.Icon = 'class.ICO'
Endwith
Modify Windows Screen;
	fill File &cfondo
DO buscoini WITH "PISOS"

If Empty(block_ent)
	Do Form frmloguin1 With 'PISOS'
Else
	If 	block_ent#"149"
		Do Form frmloguin1 With 'PISOSB'
		Update mwkexe Set nomexe='PISOS'
	Else
		If 	block_ent#"149"
			Do Form frmloguin1 With 'PISOSB'
			Update mwkexe Set nomexe='PISOS'
		Else
			Do sp_conexion
			midusu	= "OSDE"
			mpassw	= "*¿*¿*¿*¿"
			mexe	= "PISOSB"
			Do sp_valido_usuario With midusu, mpassw, mexe
			Do sp_armo_permisos_menu With mwkusuario.Id, 31
			Select codigovax, idusuario, Password, mwkusuario.Id, mwkmenu.codgrupo As nivel, ;
				mwksector2.Descrip As sector,nomape,mwkusuario.passwordldap,mwkusuario.idcodmed,mwkusuario.email ;
				from mwkusuario, mwkmenu, mwksector2 ;
				where mwksector2.Descrip Like 'COORDINADORES' ;
				group By idusuario Into Cursor mwkusuario
			Update mwkexe Set nomexe='PISOS'
			Do sp_login
			Do sp_desconexion With "inicio Pisos"
		Endif
	Endif
Endif

mcantexe = 0
Do prg_exes_activos With Proper('PISOS') + "      P.Id:"
If mcantexe>2 And (mwkusuario.sector # "SISTEMAS" And mwkusuario.idusuario # "MGRECO")
	Messagebox("NO PUEDE INGRESAR A MAS DE DOS APLICACIONES DE PISOS"+;
		chr(13) + "DISCULPE LAS MOLESTIAS...";
		,48,"Control Sistemas")
	Cancel
Else

	If mresplog = 0
		Do sp_busco_server_namespaces
		Do prg_setDatabase
		Do seteos_configuracion
		Do sp_desconexion With "inicio Pisos"

		If prg_modo_exe()
*	MESSAGEBOX('voy a registrar ocx en esta IP'+myip)
			If myip<>'172.16.7.4'
				Do registroocx
			Endif
			Do pisosmenu.mpr
			Read Events
		Endif

	Endif
Endif

Procedure AFINDHWND
Procedure MF2
Procedure DAT_WS
Procedure DET_FAC
Procedure DAT_VALE1
Procedure ITEM_VALE1
Procedure AFECHAS
Procedure eros
Procedure VDATOS

