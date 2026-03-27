**********************************************************************
* Program....: SETEOS_PRESUAUTOMATIC.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 30 January 2020, 10:42:14
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 30 January 2020 / 10:42:14
* Purpose....:
**********************************************************************
*
Public mcon1, mcon1, mcon4, midusu,myip,miform,mxambito
mxambito = 1


Public mflag, mvuelvo, mregistracio, mform, msql1, mcodent, ;
   msql_reg, msql, msql_pre, mdesc, manos, mmeses, mdias
Public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, msel_datos(25,4),det_fac(40,8)
Dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)

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
Set ENGINEBEHAVIOR 70

Do seteos_ip
myip = IPAddress()

*////////////////////////////////////////////////////////////
mverexe = prg_version_exe("C")
mverexe = Alltrim(Transf(mverexe))
mverexeX = prg_version_exe("X")
mverexeX = Alltrim(Transf(mverexeX))


mresplog = 0

*!*	_Screen.WindowState = 2

*!*	Modify Windows Screen Title "PRESUPUESTOS AMBULATORIO"
*!*	cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
*!*	Modify Windows Screen Fill File &cfondo

* Do Form frmPresu50 With 'PRESUAMB'

If mresplog = 0

   Do sp_busco_server_namespaces

   On Error =Aerr(eros)
   mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
   mcadcon = Filetostr(mfile)
   On Error

   If Type('mcadcon') = "C"
      mDatabase 	= Mline(mcadcon,3)
      mDatabase 	=Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
      If !Empty('mDatabase')
         Select mwktabcfg
         Replace olespaces With mDatabase
      Endif
   Endif

ldFecha = DATE()

*-- Marco el inicio del programa 
Strtofile( Dtoc( ldFecha )+" "+Time()+" - Inicio Programa "+Chr(13)+Chr(10),"PrestaPrecios.LOG",1)

   *-- Instancio el prg para ejectura la rutina da ctualizacion de precios
   oPrestaprecios = Newobject("prestaprecios","..\sp_actualiza_prestaprecios.prg")
   oPrestaprecios.ArmaSetDatos()
   oPrestaprecios.ActualizaPrecios()

Strtofile( Dtoc( ldFecha )+" "+Time()+" - Inicio Programa "+Chr(13)+Chr(10),"PrestaPrecios.LOG",1)

   * Do seteos_configuracion

   * do sp_conexion
   * Do presuAMBmenu.mpr
   * Do Form frmPresu50 With 'PRESUAMB'
   * Read Events

Endif

