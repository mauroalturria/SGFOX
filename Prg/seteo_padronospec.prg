**********************************************************************
* Program....: SETEO_PADRONOSPEC.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 19 April 2021, 09:01:54
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 19 April 2021 / 09:01:54
* Purpose....:
**********************************************************************
*
Release All
Close Table All
Close Databases All
Clear Macro All

* lparameters miparam

*-- Seteo de inicio - Despues se completa el seteo
Set Talk Off
Set Near Off
Set Deleted On
Set Echo Off
Set Safety Off
Set Exclusive Off
Set Date To YMD
Set ReportBehavior 90

Public mcon1, midusu, mpassw, mcodvax, msql_reg, mcon1, mresplog, mtfhoy, myip, miform, ;
   block_ent,mxambito,archini(1)

*!*	if vartype(miparam)="C"
*!*		block_ent = transf(miparam)
*!*	else
*!*		block_ent = ''
*!*	ENDIF

mxambito = 1
lcdirectorioEXE = Fullpath(Curdir())									&& Directorio por defecto para el inicio del Ejecutable


Set Default To &lcdirectorioEXE
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep Additive

*!*	*-- Obtenemos el entorno de datos y seteamos los parametros
*!*	cDireDefa 	= Fullpath(Curdir())
ldFecha		= Date()						&& Transitorio se usa solo para inicializar variable y dato local

Do Seteos_Ip							&&  '..\prg\Seteos_Ip'
myip = IPAddress()


cfondo = Iif(_Screen.Width <= 800, "\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify Windows Screen Fill File &cfondo

*-- Para toda la pantalla configuro
With _Screen
   *//////////////////
   .WindowState = 2 					&& Maximizamos la pantalla de la aplicación
   .Caption 	= 'INCORPORACION DE LA OBRA SOCIAL OSPEC, AL PADRON DEL SISTEMA CEDI '    && titulo de la Ventana
   .BackColor = Rgb(58,73,205)
   .Icon = 'class.ico'
Endwith

Wait Window At 20,20 Nowait "Procesando Datos..." Timeout 30

Do Sp_Conexion
Do Sp_Busco_Server_Namespaces
* On Error = Aerr( Eros )

*-- Teclas para la produccion
On Key Label Alt+Q Cancel

* Try

*///////////////////////////////////////////////////////////////////////////////////////
*-- Guardo el Inicio de la atividad al ejecutar
Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"PadronOSPEC.LOG",1)
Strtofile( Dtoc( ldFecha )+" - "+Time()+" - Inicio Proceso " + Chr(13) + Chr(10),"PadronOSPECData.LOG",1)

*!*	   *--Genero la Instancia a la clase para procesar el padron
*!*	   oConsultaPadronOSPEC = Newobject("cGeneroPadronOSPEC",cDireDefa + "sp_GeneroPadronOspec.prg")
*!*	   oConsultaPadronOSPEC.GeneroDatos()
*!*	   oConsultaPadronOSPEC.DesConexionMotor()



Wait Window At 20,20 Nowait "Fin Proceso ..." Timeout 30
Strtofile( Dtoc( ldFecha )+" - "+Time()+" -  Fin Proceso " + Chr(13)+Chr(10),"PadronOSPECData.LOG",1 )


*-- Ejecuto el formulario oara cargar los archivos y disparar el proceso de subida
Do Form FRMPadronOSPEC
* do OSPECMEnu.mpr
* Read Event


*!*	Catch To oError
*!*	   =Messagebox("Error en : "+Chr(13)+;
*!*	      oError.Message+Chr(13)+;
*!*	      "Error #:"+Transform(oError.ErrorNo)+Chr(13)+;
*!*	      "Line  #:"+Transform(oError.Lineno)+Chr(13)+;
*!*	      "Error #:"+Transform(oError.LineContents),48,"Error")

*!*	   *-- Enviamos el Ojeto oError para grabar el Log de Errores
*!*	   * ocObjetoEntorno.GrabarErrorEnDisco( oError )
*!*	   Do cDireDefa + log_errores With Transform(oError.ErrorNo), oError.Message, Transform(oError.Lineno), Program(), Transform(oError.LineContents)

*!*	   *-- Desconectamos Motor
*!*	   oConsultaPadronOSPEC.DesConexionMotor()

*!*	Endtry

If ( Version(2) = 2 )
   * Do sp_desconexion
Else
   *--
   On Shutdown
   Quit
Endif
