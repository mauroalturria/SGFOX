****
**  Seteos del sistema
****

Public block_ent
block_ent = ''

Do prg_var_public

mxambito = 1
lcTitle = 'Teleconsulta'
lcNomExe = 'TELECONSULTA'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public
Create Cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc N(13), tipdoc N(2), domici c(50), tel c(20), ;
	cpostal N(4), locali c(25), pcia c(25), fecnac d, sexo c(1),email c(50),cuit c(13))

Release mflag, mvuelvo, mregistracio, mprotocolo, mform, msql1, mprima, mlet1, mcodent,ncodbar,ccodbar,mtfhoy
Public mflag, mvuelvo, mregistracio, mprotocolo, mform, msql1, mprima, mlet1, mcodent,ncodbar,ccodbar,mtfhoy


Create Cursor confarma ;
	(protocolo c(15), insumo c(11), cantidad N(6), Descrip c(40),codinsumo N(8),fhcons T, ulti l,nval N(12),observa c(250))

****
Public mcantexe
xtremeoff = .F.
With _Screen
	.Caption = lcTitle
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.Icon = 'PHONE05.ICO'
Endwith
Do prg_proxy   &&&& actualiza proxy

mresplog = 0


Do sp_busco_server_namespaces
Do prg_setDatabase
Do seteos_configuracion


If !Used("mwkserver1")
	lDisconnec = .T.
	Do Sp_Conexion With "TELECONSULTA"
Endif


mexe	= "TELECONSULTA"

midusu ='CARMENA'
mpass   = 'QAZX'
Do sp_valido_usuario With midusu, mpass , "TELECONSULTA"
Select * From mwkusuario Into Cursor mwkusuario_sec

If Nvl(mwkusuario_sec.idcodmed,1)<=1
	Cancel
Endif

If Used('mwkexe')
	If Reccount('mwkexe')>0
		Do sp_armo_permisos_menu With mwkusuario_sec.Id, 0
	Else
		mret = SQLExec(mcon1, "select nomexe,versionactual,launcher,versionminima,tabexe.id as idexe  " + ;
			"from tabexe " + ;
			"where nomexe = ?mexe " , "mwkexe")
	Endif
Else
	mret = SQLExec(mcon1, "select nomexe,versionactual,launcher,versionminima,tabexe.id as idexe  " + ;
		"from tabexe " + ;
		"where nomexe = ?mexe " , "mwkexe")
Endif


Do Form frmguardia86C

If  Used("mwkserver1")
	Do sp_desconexion
Endif

Procedure MF2
Procedure AFECHAS
Procedure EROS


