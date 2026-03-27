****
**  Seteos del sistema
****
Lparameters minreg
Public mcon1, mcon1, mcon4, midusu,mconc,myip,msql_reg,mxambito , mimed

If Empty(minreg)
	Cancel
Endif
If Vartype(mcon3)= "U"
	Public mcon3
	mcon3 = 0
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
Set Enginebehavior 70


Do seteos_ip
myip = IPAddress()
Do buscoini With "TURNOS"

*!*	&& DA ERROR EN USUARIO LIMITADO
*!*	dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
*!*	if !file(dirfonts)
*!*		copy file Pf_i2of5.ttf to &dirfonts
*!*	endif

Public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, msel_datos(25,4),det_fac(40,8)
Dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)
Public VDATOS(100)

Create Cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc N(13), tipdoc N(2), domici c(50), tel c(20), ;
	cpostal N(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

mresplog = 0

If !Used("mwkserver1")
	lDisconnec = .T.
	If mxambito = 1
		Do sp_conexion
	Else
		Do sp_conexion_sa With "OTROAMBITO"
		If mcon3>0
			mcon1 = mcon3
			Select * From mwkserver2 Into Cursor mwkserver1
		Endif
	Endif
Endif
midusu	= "cfunes"
mpassw	= "qazx"
mexe	= "NUTRICION"

Do sp_valido_usuario With midusu, mpassw, mexe

Select *,"SISTEMAS" As sector From mwkusuario Into Cursor mwkusuario
On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()

If Used('mwkexe')
	Use In mwkexe
Endif

Create Cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
Insert Into mwkexe Values ("NUTRICION","","\\172.16.5.46//C:/C/NUTRICION.exe","")
Do seteos_configuracion

Do Form frmquirof24 With Val(Transform(minreg))
Read Events
If 	lDisconnec
	Do sp_desconexion
Endif
Procedure MF2
Procedure AFECHAS
Procedure EROS

