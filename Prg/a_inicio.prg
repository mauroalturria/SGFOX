* Todas las Conexiones e inicializaciones de Obj. y Variables
* Que necesito para el sistema y todos los seteos

Public mcon1,mcon3,mret,myip,miform
*Nombre de los Procedures
Public GuardoDatosSQL,EjecutoSql,ActualizoGrid
*Nombre de Variables
Public  midpers, mape, mid, mob, mdt, maten, mForm,;
	midSocio,mpac,mresplog
on error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
&& -------------------------------------------------
&& Seteos para VFP9
*!*	If Version(5) = 900
*!*		MM = "Set Enginebehavior 70"
*!*		&MM
*!*		Set Default To "c:\mesa entradas fox\"
*!*		Set Path To SCX, LIB, MNU, PRG, Exe, BMP, REP
*!*	Endif	
&& -------------------------------------------------

do seteos_ip
myip = IPAddress()
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

mresplog = 0
_SCREEN.WindowState = 2
modify windows screen ;
	title "Mesa de Ingresos"
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
		fill file &cfondo 
		

Do Form frmmesalog With 'MESAINGRESOS'

If mresplog = 0
	Do sp_busco_server_namespaces
	On Error =Aerr(eros)
	mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
	mcadcon = Filetostr(mfile)
	on error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	If Type('mcadcon') = "C"
		mDatabase 	= Mline(mcadcon,3)
		mDatabase 	=Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
		If !Empty('mDatabase')
			Select mwktabcfg
			Replace olespaces With mDatabase
		Endif
	Endif

If !Used("mwkserver1")
	Do sp_conexion
Endif
 mvhoy = sp_busco_fecha_serv('DD')
 DO EjecutoSql with 0, mvhoy, mvhoy
 DO FORM frmMesa2.scx
Endif
Set Sysmenu To Default  