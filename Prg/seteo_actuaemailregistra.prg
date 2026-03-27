**********************************************************************
* Program....: SETEO_ACTUAEMAILREGISTRA.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 01 July 2020, 09:46:25
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 01 July 2020 / 13:46:25
* Purpose....:
**********************************************************************
**  Seteos del sistema - Correo Electronico desde web a registracion
*
Lparameters miparam

*-- Limpieza del el Entono de Datos
Close Table All
Close Databases All
Clear Macro All
*
*-- Seteo de inicio - Despues se completa el seteo
Set Talk Off
Set Near Off
Set Deleted On
Set Echo Off
Set Safety Off
Set Exclusive Off
Set Date To British
* Set Path To

Public mcon1, midusu, mpassw, mcodvax, msql_reg, mcon1, mresplog, mtfhoy, myip, miform, ;
   block_ent,mxambito,archini(1)

*!*	Try
   mxambito = 1

   *-- Seteo directorio y Path de busqueda
   lcdirectorioEXE = Fullpath(Curdir())
   Set Default To &lcdirectorioEXE
   Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep

   If Vartype(miparam)="C"
      block_ent = Transf(miparam)
   Else
      block_ent = ''
   Endif

   Do seteos_ip
   myip = IPAddress()

   cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
   Modify Windows Screen Fill File &cfondo

   With _Screen
      *//////////////////
      .WindowState = 2 					&& Maximizamos la pantalla de la aplicación
      .Caption 	= 'Actualización de Email registrados vía Web a tabla Registración del SG'    && titulo de la Ventana
      .BackColor = Rgb(58,73,205)
      .Icon = 'class.ico'

      *!*	      .AddObject ( "Title1", "Title" )
      *!*	      .AddObject ( "Title2", "Title" )
      *!*	      .Title2.Top  = .Title2.Top  - 2
      *!*	      .Title2.Left = .Title2.Left - 2
      *!*	      .Title2.ForeColor = Rgb ( 255, 0, 0 )
   Endwith

   Wait Window At 20,20 Nowait "Procesando Datos..." Timeout 40

   Do sp_conexion
      Do sp_busco_server_namespaces
      On Error =Aerr(eros)

   *--Instancio la clase para procesar los mails de web
   oActualizaViaWeb = Newobject("ActualizaViaWeb","...\sp_actualiza_email_registra.prg")
   oActualizaViaWeb.ArmoSetdatos()

   Wait Window At 20,20 Nowait "Proceso Terminado..." Timeout 30
 
   *-- Colocamos la propiedad del Objeto en .T. para saver el modo de trabajo
   If ( Version(2) = 2 )
      Do sp_desconexion
   Else
      *--
      On Shutdown
      Quit
   Endif

*!*	Catch To oError
*!*	   *!*	  Messagebox( "Error occurrido en : " + Transform(Datetime())+ Chr(13) +;
*!*	   *!*	      'Mensaje ' + Alltrim( oError.Message ) + Chr(13) +;
*!*	   *!*	      "Error   : "+Transform( oError.ErrorNo )+ Chr(13) + ;
*!*	   *!*	      "Linea   : "+Transform( oError.Lineno )+ Chr(13) + ;
*!*	   *!*	      "Error   : "+Transform( oError.LineContents) + Chr(13) + ;
*!*	   *!*	      "Detalle : "+oError.Details ,0+16 , 'Aviso al Usuario' )

*!*	   Do Log_errores With Transform(oError.ErrorNo), ;
*!*	      oError.Message,;
*!*	      Transform(oError.LineContents),;
*!*	      PROGRAM() ,;
*!*	      Transform(oError.Lineno)
*!*	Endtry

*!*	Define Class Title As Label
*!*	   FontName = [Times New Roman]
*!*	   FontSize = 26
*!*	   Visible  = .T.
*!*	   Width	= 600
*!*	   Height	= 125
*!*	   Top		= _Screen.Height - 150
*!*	   Left	    = 25
*!*	   Caption	= [Actualización de Email registrados vía Web a tabla Registración del SG]
*!*	   ForeColor = Rgb ( 192,192,192 )
*!*	   BackStyle = 0	&& Transparent
*!*	Enddefine
