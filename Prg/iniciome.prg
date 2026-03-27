* Todas las Conexiones e inicializaciones de Obj. y Variables
* Que necesito para el sistema y todos los seteos

Public mcon1,mcon3,mret,myip,miform,mxambito
*Nombre de los Procedures
Public GuardoDatosSQL,EjecutoSql,ActualizoGrid
*Nombre de Variables
Public  midpers, mape, mid, mob, mdt, maten, mForm,;
	midSocio,mpac,mresplog
mxambito = 1	

Public mflag, mvuelvo, mregistracio, mform, msql1, mcodent, ;
	msql_reg, msql, msql_pre, mdesc, manos, mmeses, mdias


Public mtfhoy,vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(25,4),;
	det_fac(40,8),xusuariologin,dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)

Dime vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(25,4),;
	det_fac(40,8),dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)


on error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
&& -------------------------------------------------
&& Seteos para VFP9

Set Enginebehavior 70

&& -------------------------------------------------

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
Set Path To SCX, LIB, MNU, PRG, Exe, BMP, REP
Set Library To librerias_mesa_ent.PRG
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Talk Off
Set Sysmenu Off
_Screen.KeyPreview = .T.

do seteos_ip
myip = IPAddress()

mresplog = 0
_Screen.WindowState = 2

Modify Windows Screen;
	title "Mesa de Ingresos"
cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")

Modify Windows Screen;
	fill File &cfondo
Do Form frmloguin1 With 'MESAINGRESOS'

If mresplog = 0
	Do sp_busco_server_namespaces
	lcOnError = On("error")
	On Error *
	mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
	mcadcon = Filetostr(mfile)
	On Error &lcOnError
	If Type('mcadcon') = "C"
		mDatabase 	= Mline(mcadcon,3)
		mDatabase 	=Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
		If !Empty('mDatabase')
			Select mwktabcfg
			Replace olespaces With mDatabase
		Endif
	Endif
	Do seteos_configuracion
	Do mnme.mpr
	Read Events
Endif
Set Sysmenu To Default  